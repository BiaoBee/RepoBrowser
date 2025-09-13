//
//  ContentView.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    private let modelContainer = try! ModelContainer(for: RepositoryBookmark.self)

    var body: some View {
        TabView {
            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass.circle")
            }
            NavigationStack {
                BookmarksView()
            }.tabItem {
                Label("Bookmark", systemImage: "bookmark.circle")
            }
        }
        .modelContainer(modelContainer)
    }
}

#Preview {
    ContentView()
}

