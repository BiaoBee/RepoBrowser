//
//  RepositoryResponse.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Represents a successful response.
struct RepositoryResponse: Codable {
    /// The repositories.
    let items: [Repository]
}

/// Represents an error response.
struct RepositoryFailureResponse: Codable {
    /// The error message.
    let message: String
}
