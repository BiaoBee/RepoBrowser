//
//  MockRepositoryService.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
@testable import RepoBrowser

class MockRepositoryService: RepositoryServiceProtocol {
    var result: Result<[Repository], Error> = .success([])
//    var onRequestHanlder: ((URLRequest) -> Void)?
    
    func fetchRepositories(filters: [RepoBrowser.AnyFilterOption], page: UInt, perPage: UInt) async throws -> [RepoBrowser.Repository] {
        try result.get()
    }
}
