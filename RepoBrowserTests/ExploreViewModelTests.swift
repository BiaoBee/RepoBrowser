//
//  ExploreViewModelTests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation
import Testing
@testable import RepoBrowser

@MainActor
struct ExploreViewModelTests {
    let mockService = MockRepositoryService()

    @Test("Filter configurations") func filters() throws {
        // the test subject
        let viewModel = ExploreViewModel(service: mockService)
        #expect(
            viewModel.filters == [
                FilterCategory(name: "Stars", options: StarsOption.allCases, defaultOption: .all),
                FilterCategory(name: "Language", options: LanguageOption.allCases, defaultOption: .all),
                FilterCategory(name: "License", options: LicenseOption.allCases, defaultOption: .all)
            ]
        )
    }
    
    @Test("Check applied filters") func isFilterApplied() throws {
        let viewModel = ExploreViewModel(service: mockService)
        #expect(viewModel.isFilterApplied == false)
    
        let firstFilterCategory = try #require(viewModel.filters.first)
        firstFilterCategory.selectedOption = firstFilterCategory.options.first {
            $0.id != firstFilterCategory.selectedOption.id
        }!
        #expect(viewModel.isFilterApplied == true)
        
        firstFilterCategory.selectedOption = firstFilterCategory.defaultOption
        #expect(viewModel.isFilterApplied == false)
    }
    
    @Test("Reloading") func reload() async throws {
        let viewModel = ExploreViewModel(service: mockService)
        
        let owner = Owner(login: "login", avatarUrl: URL(string: "https://avatarurl")!)
        let license = License(spdxId: "MIT")
        mockService.result = .success([
            Repository(id: 1,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license),
            Repository(id: 2,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license)
        ])
        viewModel.reload()
        try await Task.sleep(for: .milliseconds(1))
        #expect(viewModel.repositories.count == 2)
        #expect(viewModel.isReloading == false)
        #expect(viewModel.currentPage == 1)
    }
    
    @Test("Loading more") func loadMore() async throws {
        let viewModel = ExploreViewModel(service: mockService)
        
        let owner = Owner(login: "login", avatarUrl: URL(string: "https://avatarurl")!)
        let license = License(spdxId: "MIT")
        mockService.result = .success([
            Repository(id: 1,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license),
            Repository(id: 2,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license)
        ])
        viewModel.reload()
        try await Task.sleep(for: .milliseconds(1))
        mockService.result = .success([
            Repository(id: 3,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license),
            Repository(id: 4,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license)
        ])
        viewModel.loadMore()
        try await Task.sleep(for: .milliseconds(1))
        #expect(viewModel.repositories.count == 4)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.currentPage == 2)
    }
    
    @Test("Fetching repositories") func fetch() async throws {
        let viewModel = ExploreViewModel(service: mockService)
        let owner = Owner(login: "login", avatarUrl: URL(string: "https://avatarurl")!)
        let license = License(spdxId: "MIT")
        mockService.result = .success([
            Repository(id: 1,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license),
            Repository(id: 2,
                       name: "name",
                       fullName: "fullName",
                       description: "description",
                       stargazersCount: 1,
                       language: "language",
                       topics: ["t1", "t2"],
                       owner: owner,
                       license: license)
        ])
        
        await viewModel.fetchRepositories(page: 1)
        #expect(viewModel.repositories.count == 2)
        #expect(viewModel.currentPage == 1)

        await viewModel.fetchRepositories(page: 100)
        #expect(viewModel.repositories.count == 4)
        #expect(viewModel.currentPage == 100)        
    }
}
