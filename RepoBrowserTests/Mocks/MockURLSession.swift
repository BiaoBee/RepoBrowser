//
//  MockURLSession.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
@testable import RepoBrowser

class MockURLSession: URLSessionProtocol {
    var result: Result<(Data, URLResponse), Error>
    var onRequestHanlder: ((URLRequest) -> Void)?
    
    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }
    
    func onRequest(handler: @escaping (URLRequest) -> Void) {
        self.onRequestHanlder = handler
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.onRequestHanlder?(request)
        return try result.get()
    }
}
