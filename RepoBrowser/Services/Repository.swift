//
//  Repository.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let topics: [String]
    let owner: Owner
    let license: License?
}

struct Owner: Codable {
    let login: String
    let avatarUrl: URL
}

struct License: Codable {
    let spdxId: String
    
    init?(spdxId: String?) {
        guard let spdxId else {
            return nil
        }
        self.spdxId = spdxId
    }
}
