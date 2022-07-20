//
//  BookkBookkApp.swift
//  BookkBookk
//
//  Created by chanju Jeon on 2022/07/17.
//

import SwiftUI
import ComposableArchitecture

@main
struct BookkBookkApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(
                    initialState: SearchState(),
                    reducer: searchReducer.debug(),
                    environment: SearchEnvironment(
                        bookClient: BookClient.live,
                        mainQueue: .main
                    )
                )
            )
        }
    }
}
