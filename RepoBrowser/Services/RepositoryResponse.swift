//
//  RepositoryResponse.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Represents a successful response from the GitHub repositories search API.
struct RepositoryResponse: Codable {
    /// The list of repositories returned by the API.
    let items: [Repository]
}

/// Represents an error response from the GitHub API.
struct RepositoryFailureResponse: Codable {
    /// The error message returned by the API.
    let message: String
}
