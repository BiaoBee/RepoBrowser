//
//  MockHTTPClient.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 15/09/2025.
//

import Foundation
@testable import RepoBrowser

/// A mock HTTP client for testing RepositoryService.
class MockHTTPClient: HTTPClientProtocol {
    /// The result to return when sendRequest is called.
    var result: Result<Data, Error>
    /// Optional handler to inspect the request.
    var onRequestHandler: ((URLRequest) -> Void)?

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func onRequest(handler: @escaping (URLRequest) -> Void) {
        self.onRequestHandler = handler
    }

    func sendRequest(_ urlRequest: URLRequest) async throws -> Data {
        onRequestHandler?(urlRequest)
        return try result.get()
    }
}
