//
//  SearchView.swift
//  BookkBookk
//
//  Created by chanju Jeon on 2022/07/18.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            NavigationView {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Results (\(viewStore.count))")
                        .padding([.leading, .trailing])
                    List {
                        ForEach(viewStore.books) { book in
                            BookRow(book: book)
                        }
                        //.listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationBarTitle(Text("📚BookFinder"))
                    .searchable(text: viewStore.binding(
                        get: \.searchQuery,
                        send: SearchAction.searchQueryChanged
                    ))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
            }
        }
    }
}

struct BookRow: View {
    let book: Book
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(
                url: URL(string: book.volumeInfo.imageLinks?.smallThumbnail ?? ""),
                content: { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                },
                placeholder: {
                    Image(systemName: "book.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(book.volumeInfo.title)
                    .bold()
                Text(book.volumeInfo.authors?.joined(separator: ",") ?? "Unknown")
                    .lineLimit(2)
                Text(book.volumeInfo.publishedDate ?? "some time ago")
                    .italic()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                bookClient: .mock,
                mainQueue: .main
            )
        )
        
        return Group {
            SearchView(store: store)
            
            SearchView(store: store)
                .environment(\.colorScheme, .dark)
        }
    }
}
