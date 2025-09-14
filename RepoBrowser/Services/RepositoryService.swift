//
//  RepositoriesService.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Errors you might run into when fetching repositories from GitHub.
enum RepositoryError: Error, LocalizedError, Equatable {
    /// The GitHub API URL is invalid.
    case invalidURL
    /// Something went wrong with the network.
    case networkFailure(Error)
    /// Couldn't decode the server's response.
    case decodingFailure(Error)
    /// Access was denied (like hitting a rate limit).
    case forbidden(String?)
    
    /// A user-friendly description of the error.
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The GitHub API URL is invalid."
        case .networkFailure(let underlyingError):
            return "Network error: \(underlyingError.localizedDescription)"
        case .decodingFailure(let underlyingError):
            return "Failed to decode the server response: \(underlyingError.localizedDescription)"
        case .forbidden(let message):
            return message ?? "Access forbidden (403)"
        }
    }
    
    static func == (lhs: RepositoryError, rhs: RepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.networkFailure(e1), .networkFailure(e2)):
            return e1.localizedDescription == e2.localizedDescription
        case let (.decodingFailure(e1), .decodingFailure(e2)):
            return e1.localizedDescription == e2.localizedDescription
        case let (.forbidden(m1), .forbidden(m2)):
            return m1 == m2
        default:
            return false
        }
    }
}

/// A protocol for anything that fetches repositories.
protocol RepositoryServiceProtocol {
    /// Fetch repositories from GitHub using filters and pagination.
    /// - Parameters:
    ///   - filters: Filter options for the search.
    ///   - page: Which page of results to get.
    ///   - perPage: How many results per page.
    /// - Returns: An array of repositories.
    /// - Throws: A `RepositoryError` if something goes wrong.
    func fetchRepositories(filters: [AnyFilterOption],
                           page: UInt,
                           perPage: UInt) async throws -> [Repository]
}

/// The service that talks to GitHub to fetch repositories.
class RepositoryService: RepositoryServiceProtocol {
    /// The session used for network requests (can be swapped out for testing).
    var urlSession: URLSessionProtocol = URLSession.shared
    /// The GitHub API endpoint for searching repositories.
    var repositoryEndpoint: String = "https://api.github.com/search/repositories"
    
    /// Make a new RepositoryService. You can pass in your own session or endpoint if you want.
    init(urlSession: URLSessionProtocol? = nil, repositoryEndpoint: String? = nil) {
        if let urlSession {
            self.urlSession = urlSession
        }
        if let repositoryEndpoint {
            self.repositoryEndpoint = repositoryEndpoint
        }
    }
    
    /// Fetch repositories from GitHub using the given filters and pagination.
    func fetchRepositories(filters: [AnyFilterOption],
                           page: UInt,
                           perPage: UInt) async throws -> [Repository] {
        guard var url = URL(string: repositoryEndpoint) else {
            throw RepositoryError.invalidURL
        }
        
        // Add all the query parameters
        url.append(queryItems: [
            URLQueryItem(name: "q", value: composeQParameter(filters: filters)),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ])
        
        // Make the network request
        let responseData: Data
        let urlResponse: URLResponse
        do {
            let request = URLRequest(url: url)
            (responseData, urlResponse) = try await urlSession.data(for: request)
        } catch {
            throw RepositoryError.networkFailure(error)
        }
        
        // Check the HTTP response
        if let httpResponse = urlResponse as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 403:
                let message = try? JSONDecoder().decode(RepositoryFailureResponse.self, from: responseData).message
                throw RepositoryError.forbidden(message)
            case 200...299:
                break
            default:
                throw RepositoryError.networkFailure(
                    NSError(domain: "RepositoryService", code: httpResponse.statusCode)
                )
            }
        }
        
        // Try to decode the response
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(RepositoryResponse.self, from: responseData)
            return response.items
        } catch {
            throw RepositoryError.decodingFailure(error)
        }
    }
    
    /// Build the `q` parameter for the GitHub search API from the filters.
    func composeQParameter(filters: [AnyFilterOption]) -> String {
        filters
            .compactMap { $0.queryFragment }
            .joined(separator: " ")
    }
}
