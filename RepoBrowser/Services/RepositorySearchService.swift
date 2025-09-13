//
//  RepositoriesService.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

enum RepositoryServiceError: Error, LocalizedError {
    case invalidURL
    case networkFailure(Error)
    case decodingFailure(Error)
    case forbidden(String?)
    
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
}

protocol RepositoryServiceProtocol {
    func fetchRepositories(filters: [AnyFilterOption],
                           perPage: UInt,
                           page: UInt) async throws -> [Repository]
}

class RepositoryService: RepositoryServiceProtocol {
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func fetchRepositories(filters: [AnyFilterOption],
                           perPage: UInt,
                           page: UInt) async throws -> [Repository] {
        guard var url = URL(string: "https://api.github.com/search/repositories") else {
            throw RepositoryServiceError.invalidURL
        }
        
        // Compose the `q` parameter
        let qParameter = filters
            .compactMap { $0.queryFragment }
            .joined(separator: " ")
        
        // Append all query parameters
        url.append(queryItems: [
                URLQueryItem(name: "q", value: qParameter),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
        ])
        
        // Perform the request
        let responseData: Data
        let urlResponse: URLResponse
        do {
            let request = URLRequest(url: url)
            (responseData, urlResponse) = try await urlSession.data(for: request)
            print(String(data: responseData, encoding: .utf8) ?? "")
        } catch {
            throw RepositoryServiceError.networkFailure(error)
        }
        
        if let httpResponse = urlResponse as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 403:
                let message = try? JSONDecoder().decode(RepositoryFailureResponse.self, from: responseData).message
                throw RepositoryServiceError.forbidden(message)
            case 200...299:
                break
            default:
                throw RepositoryServiceError.networkFailure(
                    NSError(domain: "RepositoryService", code: httpResponse.statusCode)
                )
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(RepositoryResponse.self, from: responseData)
            return response.items
        } catch {
            throw RepositoryServiceError.decodingFailure(error)
        }
    }
}
