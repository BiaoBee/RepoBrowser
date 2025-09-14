//
//  Repository.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Represents a GitHub repository.
struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let topics: [String]
    let owner: Owner
    let license: License?
}

/// Represents the owner of a GitHub repository.
struct Owner: Codable, Equatable {
    /// The username of the owner.
    let login: String
    let avatarUrl: URL
}

/// Represents the license of a GitHub repository.
struct License: Codable, Equatable {
    /// The SPDX identifier of the license (e.g., "MIT", "Apache-2.0").
    let spdxId: String

    init?(spdxId: String?) {
        guard let spdxId else {
            return nil
        }
        self.spdxId = spdxId
    }
}
