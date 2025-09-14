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
        do {
            _ = try await client.sendRequest(URLRequest(url: validURL))
            #expect(false, "Expected HTTPClientError.clientError")
        } catch let error as HTTPClientError {
            switch error {
            case .clientError(let message):
                #expect(message == "fail")
            default:
                #expect(false, "Expected clientError, got \(error)")
            }
        }
    }

    @Test("Server error throws HTTPClientError.serverError") func testServerError() async throws {
        let response = HTTPURLResponse(url: validURL, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let mockSession = MockURLSession(result: .success((failureData, response)))
        let client = HTTPClient(urlSession: mockSession as! URLSession)
        do {
            _ = try await client.sendRequest(URLRequest(url: validURL))
            #expect(false, "Expected HTTPClientError.serverError")
        } catch let error as HTTPClientError {
            switch error {
            case .serverError(let message):
                #expect(message == "fail")
            default:
                #expect(false, "Expected serverError, got \(error)")
            }
        }
    }

    @Test("Network error throws HTTPClientError.networkFailure") func testNetworkFailure() async throws {
        let mockSession = MockURLSession(result: .failure(NSError(domain: "Test", code: -1009)))
        let client = HTTPClient(urlSession: mockSession as! URLSession)
        do {
            _ = try await client.sendRequest(URLRequest(url: validURL))
            #expect(false, "Expected HTTPClientError.networkFailure")
        } catch let error as HTTPClientError {
            switch error {
            case .networkFailure:
                #expect(true)
            default:
                #expect(false, "Expected networkFailure, got \(error)")
            }
        }
    }
}
