//
//  HTTPClient.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

// Errors when using the HTTP client.
enum HTTPClientError: LocalizedError, Equatable {
    /// A network-level failure occurred (e.g., no internet, timeout).
    case networkFailure(String)
    /// An server error has occurred (5xx).
    case serverError(String?)
    /// Bad request or unauthorized (4xx).
    case clientError(String?)

    var errorDescription: String? {
        switch self {
        case .networkFailure(let message):
            return "Network error - \(message)"
        case .serverError(let message):
            return "Server error - \(message ?? "An unknown server error occurred.")"
        case .clientError(let message):
            return "Client error - \(message ?? "An unknown client error occurred.")"
        }
    }
    
    static func == (lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
        switch (lhs, rhs) {
        case let (.networkFailure(m1), .networkFailure(m2)):
            return m1 == m2
        case let (.serverError(m1), .serverError(m2)):
            return m1 == m2
        case let (.clientError(m1), .clientError(m2)):
            return m1 == m2
        default:
            return false
        }
    }
}

/// The HTTP client abstraction.
protocol HTTPClientProtocol {
    func sendRequest(_ urlRequest: URLRequest) async throws -> Data
}

/// The HTTP client implementation.
final class HTTPClient: HTTPClientProtocol {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func sendRequest(_ request: URLRequest) async throws -> Data {
        let responseData: Data
        let urlResponse: URLResponse
        do {
            (responseData, urlResponse) = try await urlSession.data(for: request)
        } catch {
            throw HTTPClientError.networkFailure(error.localizedDescription)
        }
        
        // Check the HTTP response
        if let httpResponse = urlResponse as? HTTPURLResponse {
            let message = try? JSONDecoder().decode(RepositoryFailureResponse.self, from: responseData).message
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw HTTPClientError.clientError(message)
            case 500...599:
                throw HTTPClientError.serverError(message)
            default:
                throw HTTPClientError.networkFailure(
                    "Unexpected network error (status code: \(httpResponse.statusCode))."
                )
            }
        }
        
        return responseData
    }
}
