//
//  RepositoryTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

struct RepositoryTests {
    @Test("Decoding Repository") func decode() throws {
        let jsonData = """
            {
              "id": 156018,
              "name": "redis",
              "full_name": "redis/redis",
              "owner": {
                "login": "redis",
                "avatar_url": "https://avatars.githubusercontent.com/u/1529926?v=4"
              },
              "description": "Some random description",
              "license": {
                "spdx_id": "NOASSERTION"
              },
              "stargazers_count": 100,
              "is_template": false,
              "web_commit_signoff_required": false,
              "topics": [
                "cache",
                "caching",
                "database"
              ],
              "language": "C"
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repo = try decoder.decode(Repository.self, from: jsonData)
        
        #expect(repo.id == 156018)
        #expect(repo.name == "redis")
        #expect(repo.fullName == "redis/redis")
        #expect(repo.owner.login == "redis")
        #expect(repo.owner.avatarUrl.absoluteString == "https://avatars.githubusercontent.com/u/1529926?v=4")
        #expect(repo.description == "Some random description")
        #expect(repo.license?.spdxId == "NOASSERTION")
        #expect(repo.stargazersCount == 100)
        #expect(repo.language == "C")
        #expect(repo.topics == ["cache", "caching", "database"])
    }
    
    @Test("License initialization") func initLicense() throws {
        let license = License(spdxId: "spdxId")
        #expect(license != nil)
        #expect(license?.spdxId == "spdxId")
        
        #expect(License(spdxId: nil) == nil)
    }
}
