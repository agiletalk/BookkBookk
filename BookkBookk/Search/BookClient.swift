//
//  BookClient.swift
//  BookkBookk
//
//  Created by chanju Jeon on 2022/07/18.
//

import ComposableArchitecture
import Foundation

struct BookClient {
    var search: (String) -> Effect<BookResponse, APIError>
}

extension BookClient {
    static let live = BookClient(
        search: { query in
            var components = URLComponents(string: "https://www.googleapis.com/books/v1/volumes")!
            components.queryItems = [URLQueryItem(name: "q", value: query)]
            
            return URLSession.shared.dataTaskPublisher(for: components.url!)
                .mapError { _ in APIError.downloadError }
                .map { data, _ in data }
                .decode(type: BookResponse.self, decoder: jsonDecoder)
                .mapError { _ in APIError.decodingError }
                .eraseToEffect()
        }
    )
}

extension BookClient {
    static let mock = BookClient(
        search: { _ in
            let books = [
                Book(
                    id: UUID().uuidString,
                    volumeInfo: .init(
                        title: "책 제목",
                        authors: ["저자"],
                        publishedDate: "2022",
                        imageLinks: nil
                    )
                ),
                Book(
                    id: UUID().uuidString,
                    volumeInfo: .init(
                        title: "Book's Title",
                        authors: ["Author1", "Author2"],
                        publishedDate: "2021-10",
                        imageLinks: nil
                    )
                ),
                Book(
                    id: UUID().uuidString,
                    volumeInfo: .init(
                        title: "本のタイトル",
                        authors: nil,
                        publishedDate: "2012-12-25",
                        imageLinks: nil
                    )
                )
            ]
            return Effect(value: BookResponse(items: books, totalItems: 3))
        }
    )
}

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    return decoder
}()
