//
//  HTTPClientTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 15/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

struct HTTPClientTests {
    let validURL = URL(string: "https://api.github.com")!
    let successData = Data("{\"message\":\"ok\"}".utf8)
    let failureData = Data("{\"message\":\"fail\"}".utf8)

    class MockURLSession: URLSessionProtocol {
        var result: Result<(Data, URLResponse), Error>
        var onRequestHandler: ((URLRequest) -> Void)?

        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }

        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            onRequestHandler?(request)
            return try result.get()
        }
    }

    @Test("Successful request returns data") func testSuccess() async throws {
        let response = HTTPURLResponse(url: validURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let mockSession = MockURLSession(result: .success((successData, response)))
        let client = HTTPClient(urlSession: mockSession)
        let data = try await client.sendRequest(URLRequest(url: validURL))
        #expect(data == successData)
    }

    @Test("Client error throws HTTPClientError.clientError") func testClientError() async throws {
        let response = HTTPURLResponse(url: validURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let mockSession = MockURLSession(result: .success((failureData, response)))
        
        let client = HTTPClient(urlSession: mockSession)
        async #expect(throws: HTTPClientError.clientError("fail"), performing: {
            _ = try await client.sendRequest(URLRequest(url: validURL))
        })
    }

    @Test("Server error throws HTTPClientError.serverError") func testServerError() async throws {
        let response = HTTPURLResponse(url: validURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let mockSession = MockURLSession(result: .success((failureData, response)))
        let client = HTTPClient(urlSession: mockSession)
        
        async #expect(throws: HTTPClientError.clientError("fail"), performing: {
            _ = try await client.sendRequest(URLRequest(url: validURL))
        })
    }

    @Test("Network error throws HTTPClientError.networkFailure") func testNetworkFailure() async throws {
        let error = NSError(domain: "Test", code: -1009)
        let mockSession = MockURLSession(result: .failure(error))
        let client = HTTPClient(urlSession: mockSession)
        
        async #expect(throws: HTTPClientError.networkFailure(error.localizedDescription), performing: {
            _ = try await client.sendRequest(URLRequest(url: validURL))
        })
    }
}
