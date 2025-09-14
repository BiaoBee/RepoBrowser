//
//  RepositoryBookmarkTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 13/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

class RepositoryBookmarkTests {
    let owner = Owner(login: "login", avatarUrl: URL(string: "https://avatarurl")!)
    let license = License(spdxId: "MIT")
    lazy var repo: Repository = Repository(id: 1,
                                           name: "name",
                                           fullName: "fullName",
                                           description: "description",
                                           stargazersCount: 1,
                                           language: "language",
                                           topics: ["t1", "t2"],
                                           owner: owner,
                                           license: license)
    
    @Test("Initialize RepositoryBookmark") func initialize() {
        let bookmark = RepositoryBookmark(repo: repo)
        #expect(bookmark.id == repo.id)
        #expect(bookmark.name == repo.name)
        #expect(bookmark.fullName == repo.fullName)
        #expect(bookmark.desc == repo.description)
        #expect(bookmark.stargazersCount == repo.stargazersCount)
        #expect(bookmark.language == repo.language)
        #expect(bookmark.topics == repo.topics.map { RepositoryTopic($0)})
        #expect(bookmark.owner == RepositoryOwner(repo.owner))
        #expect(bookmark.license == repo.license?.spdxId)
    }
    
    @Test("Convert RepositoryBookmark to Repository") func toRepository() throws {
        let bookmark = RepositoryBookmark(repo: repo)
        let repository = Repository(bookmark)
        #expect(repository == self.repo)
    }
}
