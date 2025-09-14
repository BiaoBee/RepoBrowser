//
//  RepositoriesService.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// Errors when fetching repositories.
enum RepositoryError: Error, LocalizedError, Equatable {
    /// The URL is invalid.
    case invalidURL
    /// Unable to fetch repositories, with an associated error message.
    case unableToFetchRepositories(String)
    /// Failed to decode the response.
    case decodingFailure(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The GitHub API URL is invalid."
        case .unableToFetchRepositories(let message):
            return "Unable to fetch repositories: \(message)"
        case .decodingFailure(let error):
            return "Failed to decode the server response: \(error.localizedDescription)"
        }
    }

    static func == (lhs: RepositoryError, rhs: RepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case let (.unableToFetchRepositories(m1), .unableToFetchRepositories(m2)):
            return m1 == m2
        case let (.decodingFailure(e1), .decodingFailure(e2)):
            return e1.localizedDescription == e2.localizedDescription
        default:
            return false
        }
    }
}

/// Abstraction layer of the repository service.
protocol RepositoryServiceProtocol {
    /// Fetch repositories from server .
    /// - Parameters:
    ///   - filters: Filter options for the search.
    ///   - page: Which page of results to get.
    ///   - perPage: How many results per page.
    /// - Returns: An list of repositories.
    /// - Throws: A `RepositoryError`.
    func fetchRepositories(filters: [AnyFilterOption],
                           page: UInt,
                           perPage: UInt) async throws -> [Repository]
}

/// The repository service.
class RepositoryService: RepositoryServiceProtocol {
    /// The session used for network requests.
    var httpClient: HTTPClientProtocol = HTTPClient(urlSession: URLSession.shared)
    /// The API endpoint for searching repositories.
    var repositoryEndpoint: String = "https://api.github.com/search/repositories"

    init(httpClient: HTTPClientProtocol? = nil, repositoryEndpoint: String? = nil) {
        if let httpClient {
            self.httpClient = httpClient
        }
        if let repositoryEndpoint {
            self.repositoryEndpoint = repositoryEndpoint
        }
    }
    
    /// Fetch repositories from server with the given filters and pagination.
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
        
        // Perform the network request
        let responseData: Data
        do {
            let request = URLRequest(url: url)
            responseData = try await httpClient.sendRequest(request)
        } catch {
            throw RepositoryError.unableToFetchRepositories(error.localizedDescription)
        }
        
        
        // Decode response
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
