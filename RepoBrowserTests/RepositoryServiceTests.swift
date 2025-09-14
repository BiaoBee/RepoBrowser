//
//  RepositoryServiceTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

struct RepositoryServiceTests {
    let mockHTTPClient = MockHTTPClient(result: .success(Data()))
    
    @Test func composeQParamter() {
        let service = RepositoryService(httpClient: mockHTTPClient)
        let qParameter = service.composeQParameter(filters: [
            AnyFilterOption(StarsOption.new),
            AnyFilterOption(LicenseOption.mit)
        ])
        #expect(qParameter == "stars:0..50 license:mit")
    }
    
    @Test("Fetching repositories - happy path") func fetchResponse() async throws {
        let responseData = try #require(testData(fileName: "RepositoryResponse", extension: "json"))
        let service = RepositoryService(httpClient: mockHTTPClient)
        mockHTTPClient.result = .success(responseData)
        mockHTTPClient.onRequest { request in
            #expect(request.url?.query() == "q=stars:0..1000000&page=1&per_page=10")
        }
        _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
    }
    
    @Test("Fetching repositories - unable to fetch repositories") func fetchResponseWithNetworkError() async throws {
        let service = RepositoryService(httpClient: mockHTTPClient)
        let error = NSError(domain: "", code: 0)
        mockHTTPClient.result = .failure(error)
        
        await #expect(throws: RepositoryError.unableToFetchRepositories(error.localizedDescription), performing: {
            try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
    }
    
    @Test("Fetching repositories - decoding failure") func fetchResponseWithDecodingError() async throws {
        let service = RepositoryService(httpClient: mockHTTPClient)
        mockHTTPClient.result = .success(try #require("incorrect json data".data(using: .utf8)))
        
        do {
            _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
            #expect(Bool(false), "RepositoryError.decodingFailure expected")
        } catch {
            #expect(error.localizedDescription.hasPrefix("Failed to decode the server response:"))
        }
    }
    
    @Test("Fetching repositories - invalid URL") func fetchResponseWithInvalidURL() async throws {
        let service = RepositoryService(httpClient: mockHTTPClient, repositoryEndpoint: "ht!tp://not an url")
        mockHTTPClient.result = .success(Data())
        
        await #expect(throws: RepositoryError.invalidURL, performing: {
            _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
    }
}
