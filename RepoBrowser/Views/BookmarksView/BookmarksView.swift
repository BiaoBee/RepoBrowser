//
//  BookmarksView.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Query(sort: \RepositoryBookmark.createdAt) var bookmarks: [RepositoryBookmark]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(bookmarks) { bookmark in
                VStack {
                    ExploreListItem(repository: .constant(Repository(bookmark)))
                }

                Button {
                    modelContext.delete(bookmark)
                } label: {
                    Text("Unbookmark")
                }

            }
        }
    }
}

#Preview {
    BookmarksView()
}
