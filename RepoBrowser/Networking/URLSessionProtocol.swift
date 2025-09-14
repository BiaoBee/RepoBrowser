//
//  URLSessionProtocol.swift
//  RepoBrowser
//
//  Created by Biao Luo on 12/09/2025.
//

import Foundation

/// A protocol that abstracts URLSession for easier testing and dependency injection.
protocol URLSessionProtocol {
    /// Fetches data for the specified URLRequest asynchronously.
    /// - Parameter request: The URLRequest to perform.
    /// - Returns: A tuple containing the response data and URLResponse.
    /// - Throws: An error if the request fails.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

/// Makes URLSession conform to `URLSessionProtocol` for production use.
extension URLSession: URLSessionProtocol { }
