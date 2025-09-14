//
//  RepositoryResponseTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

class RepositoryResponseTests {
    @Test("Decoding RepositoryResponse") func decodeRepositoryResponse() throws {
        let responseData = try #require(testData(fileName: "RepositoryResponse", extension: "json"))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try decoder.decode(RepositoryResponse.self, from: responseData)
        #expect(decodedResponse.items.count == 5)
    }
    
    @Test("Decoding RepositoryFailureResponse") func decodeRepositoryFailureResponse() throws {
        let responseData = try #require(testData(fileName: "RepositoryFailureResponse", extension: "json"))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedResponse = try decoder.decode(RepositoryFailureResponse.self, from: responseData)
        #expect(
            decodedResponse.message ==
            "API rate limit exceeded for 222.152.219.153. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)"
        )
    }
    
    // TODO: failure case
}
