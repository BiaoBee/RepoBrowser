//
//  RepoDetailView.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import SwiftUI
import SwiftData

struct RepoDetailView: View {
    @Query var bookmarks: [RepositoryBookmark]
    @Environment(\.modelContext) private var modelContext

    var currentBookmark: RepositoryBookmark? {
        bookmarks.first {
            $0.id == repository.id
        }
    }

    var repository: Repository
    
    var isBookmarked: Bool {
        get {
            currentBookmark != nil
        }
    }
    
    func toggleBookmark(_ isBookmarked: Bool) {
        if isBookmarked {
            let bookmark = RepositoryBookmark(repo: repository)
            modelContext.insert(bookmark)
        } else {
            if let currentBookmark {
                modelContext.delete(currentBookmark)
            }
        }
    }
    
    var body: some View {
        List {
            HStack {
                AvatarView(url: repository.owner.avatarUrl, size: 25)
                Text(repository.owner.login)
            }
            .font(.subheadline)
            
            HStack {
                Text(repository.name)
            }
            .font(.headline)
             
            if let description = repository.description {
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            if !repository.topics.isEmpty {
                HStack {
                    Text("Topics: " + repository.topics.joined(separator: ","))
                }
            }
                        
            HStack(spacing: 4) {
                Image(systemName: "star")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.yellow)
                Text("\(repository.stargazersCount)")
            }
            
            if let license = repository.license {
                HStack(spacing: 4) {
                    Text("License: " + license.spdxId)
                }
            }
            
            if let language = repository.language {
                HStack {
                    Text("Language: " + language)
                }
            }
        }
        .navigationTitle(repository.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                BookmarkToggle(isSelected: Binding(get: {
                    isBookmarked
                }, set: { newval in
                    toggleBookmark(newval)
                }))
            }
        }
    }
}
