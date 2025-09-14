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
    let mockSession = MockURLSession(result: .success((Data(), URLResponse())))
    
    @Test func composeQParamter() {
        let service = RepositoryService(urlSession: mockSession)
        let qParameter = service.composeQParameter(filters: [
            AnyFilterOption(StarsOption.new),
            AnyFilterOption(LicenseOption.mit)
        ])
        #expect(qParameter == "stars:0..50 license:mit")
    }
    
    @Test("Fetching repositories - happy path") func fetchResponse() async throws {
        let responseData = try #require(testData(fileName: "RepositoryResponse", extension: "json"))
        let service = RepositoryService(urlSession: mockSession)
        mockSession.result = .success((responseData, URLResponse()))
        mockSession.onRequest { request in
            #expect(request.url?.query() == "q=stars:0..1000000&page=1&per_page=10")
        }
        _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
    }
    
    @Test("Fetching repositories - network error") func fetchResponseWithNetworkError() async throws {
        let service = RepositoryService(urlSession: mockSession)
        let error = NSError(domain: "", code: 0)
        mockSession.result = .failure(error)
        
        await #expect(throws: RepositoryError.networkFailure(error), performing: {
            try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
        
        mockSession.result = .success((try #require(testData(fileName: "RepositoryResponse", extension: "json")),
                                       HTTPURLResponse(url: URL(string: "https://some/random/url")!,
                                                                    statusCode: 500,
                                                                    httpVersion: "",
                                                                    headerFields: [:])!
                                      ))
        
        await #expect(throws: RepositoryError.networkFailure(NSError(domain: "RepositoryService", code: 500)), performing: {
            try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
    }
    
    @Test("Fetching repositories - forbidden") func fetchResponseWithForbiddenError() async throws {
        let service = RepositoryService(urlSession: mockSession)
        mockSession.result = .success((try #require(testData(fileName: "RepositoryFailureResponse", extension: "json")),
                                       HTTPURLResponse(url: URL(string: "https://some/random/url")!,
                                                                    statusCode: 403,
                                                                    httpVersion: "",
                                                                    headerFields: [:])!
                                      ))
        
        let expectedErrorMessage = "API rate limit exceeded for 222.152.219.153. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)"
        await #expect(throws: RepositoryError.forbidden(expectedErrorMessage), performing: {
            try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
    }
    
    @Test("Fetching repositories - decoding failure") func fetchResponseWithDecodingError() async throws {
        let service = RepositoryService(urlSession: mockSession)
        mockSession.result = .success((try #require("incorrect json data".data(using: .utf8)), URLResponse()))
        
        do {
            _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
            #expect(Bool(false), "RepositoryError.decodingFailure expected")
        } catch {
            #expect(error.localizedDescription.hasPrefix("Failed to decode the server response:"))
        }
    }
    
    @Test("Fetching repositories - invalid URL") func fetchResponseWithInvalidURL() async throws {
        let service = RepositoryService(urlSession: mockSession, repositoryEndpoint: "ht!tp://not an url")
        mockSession.result = .success((Data(), URLResponse()))
        
        await #expect(throws: RepositoryError.invalidURL, performing: {
            _ = try await service.fetchRepositories(filters: [AnyFilterOption(StarsOption.all)], page: 1, perPage: 10)
        })
    }
}
