//
//  Repository.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Represents a GitHub repository.
struct Repository: Codable, Identifiable, Equatable {
    /// The unique identifier of the repository.
    let id: Int
    /// The short name of the repository.
    let name: String
    /// The full name of the repository, including the owner (e.g., "owner/repo").
    let fullName: String
    /// The description of the repository.
    let description: String?
    /// The number of stargazers (stars) the repository has.
    let stargazersCount: Int
    /// The primary programming language used in the repository.
    let language: String?
    /// The list of topics associated with the repository.
    let topics: [String]
    /// The owner of the repository.
    let owner: Owner
    /// The license information for the repository.
    let license: License?
}

/// Represents the owner of a GitHub repository.
struct Owner: Codable, Equatable {
    /// The username of the owner.
    let login: String
    /// The URL to the owner's avatar image.
    let avatarUrl: URL
}

/// Represents the license of a GitHub repository.
struct License: Codable, Equatable {
    /// The SPDX identifier of the license (e.g., "MIT", "Apache-2.0").
    let spdxId: String

    /// Initializes a License with an optional SPDX identifier.
    /// - Parameter spdxId: The SPDX identifier string. Returns nil if spdxId is nil.
    init?(spdxId: String?) {
        guard let spdxId else {
            return nil
        }
        self.spdxId = spdxId
    }
}
