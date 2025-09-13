//
//  RepositoryResponse.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

struct RepositoryResponse: Codable {
    let items: [Repository]
}

struct RepositoryFailureResponse: Codable {
    let message: String
}
