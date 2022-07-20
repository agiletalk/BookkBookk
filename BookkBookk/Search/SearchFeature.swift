//
//  SearchFeature.swift
//  BookkBookk
//
//  Created by chanju Jeon on 2022/07/18.
//

import Combine
import ComposableArchitecture

struct SearchState: Equatable {
    var books: [Book] = []
    var count: Int = 0
    var searchQuery = ""
}

enum SearchAction: Equatable {
    case searchQueryChanged(String)
    case searchResponse(Result<BookResponse, APIError>)
    case searchResultTapped(Book)
}

struct SearchEnvironment {
    var bookClient: BookClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, environment in
    switch action {
    case let .searchQueryChanged(query):
        enum SearchBookId {}
        
        state.searchQuery = query

        guard !query.isEmpty else {
            state.books = []
            state.count = 0
            return .cancel(id: SearchBookId.self)
        }

        return environment.bookClient
            .search(query)
            .debounce(id: SearchBookId.self, for: 0.3, scheduler: environment.mainQueue)
            .catchToEffect(SearchAction.searchResponse)

    case .searchResponse(.failure):
        state.books = []
        state.count = 0
        return .none

    case let .searchResponse(.success(response)):
        state.books = response.items
        state.count = response.totalItems
        return .none

    case let .searchResultTapped(book):
        return .none

    }
}
