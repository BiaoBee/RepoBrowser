//
//  RepositoryBookmark.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation
import SwiftData

@Model
class RepositoryOwner: Equatable {
    @Attribute(.unique)
    var login: String
    var avatarUrl: URL
    
    init(_ owner: Owner) {
        self.login = owner.login
        self.avatarUrl = owner.avatarUrl
    }
    
    static func == (lhs: RepositoryOwner, rhs: RepositoryOwner) -> Bool {
        lhs.login == rhs.login &&
        lhs.avatarUrl == rhs.avatarUrl
    }
}

@Model
class RepositoryTopic: Equatable  {
    @Attribute(.unique)
    var topic: String
    
    init(_ topic: String) {
        self.topic = topic
    }
    
    static func == (lhs: RepositoryTopic, rhs: RepositoryTopic) -> Bool {
        lhs.topic == rhs.topic
    }
}

@Model
class RepositoryBookmark {
    @Attribute(.unique)
    var id: Int
    var name: String
    var fullName: String
    var desc: String?
    var stargazersCount: Int
    var language: String?
    var topics: [RepositoryTopic]
    
    var owner: RepositoryOwner
    var license: String?
    
    var createdAt: Date
    
    init(repo: Repository) {
        self.id = repo.id
        self.name = repo.name
        self.fullName = repo.fullName
        self.desc = repo.description
        self.stargazersCount = repo.stargazersCount
        self.language = repo.language
        self.topics = repo.topics.map { RepositoryTopic($0) }
        self.owner = RepositoryOwner(repo.owner)
        self.license = repo.license?.spdxId
        self.createdAt = Date()
    }
}

extension Repository {
    init(_ bookmark: RepositoryBookmark) {
        self.init(id: bookmark.id,
                  name: bookmark.name,
                  fullName: bookmark.fullName,
                  description: bookmark.desc,
                  stargazersCount: bookmark.stargazersCount,
                  language: bookmark.language,
                  topics: bookmark.topics.map { $0.topic },
                  owner: Owner(login: bookmark.owner.login,
                               avatarUrl: bookmark.owner.avatarUrl),
                  license: License(spdxId: bookmark.license)
        )
    }
}
