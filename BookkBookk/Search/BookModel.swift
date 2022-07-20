//
//  BookModel.swift
//  BookkBookk
//
//  Created by chanju Jeon on 2022/07/18.
//

import Foundation

struct BookResponse: Decodable, Equatable {
    var items: [Book]
    var totalItems: Int
}

struct Book: Decodable, Equatable, Identifiable {
    var id: String
    var volumeInfo: VolumeInfo
    
    struct VolumeInfo: Decodable, Equatable {
        var title: String
        var authors: [String]?
        var publishedDate: String?
        var imageLinks: ImageLinks?
        
        struct ImageLinks: Decodable, Equatable {
            var smallThumbnail: String
            var thumbnail: String
        }
    }
}

enum APIError: Error {
    case downloadError
    case decodingError
}
