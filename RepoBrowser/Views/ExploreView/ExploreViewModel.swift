//
//  ExploreViewModel.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import Foundation
import SwiftUI

final class AnyFilterOption: Hashable, Identifiable {
    let name: String
    let queryFragment: String?

    init(_ option: any FilterOption) {
        self.name = option.name
        self.queryFragment = option.queryFragment
    }

    static func == (lhs: AnyFilterOption, rhs: AnyFilterOption) -> Bool {
        lhs.name == rhs.name
    }
    
    var id: String {
        name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

@Observable
final class FilterCategory: Identifiable {
    let name: String
    let options: [AnyFilterOption]
    var selectedOption: AnyFilterOption
    let defaultOption: AnyFilterOption
    
    var id: String {
        name
    }
    
    init<T: FilterOption>(name: String, options: [T], defaultOption: T) {
        self.name = name
        self.options = options.map {
            AnyFilterOption($0)
        }
        self.selectedOption = AnyFilterOption(defaultOption)
        self.defaultOption = AnyFilterOption(defaultOption)
    }
    
    func resetToDefault() {
        selectedOption = defaultOption
    }
}


@Observable
@MainActor
final class ExploreViewModel {
    let service: any RepositoryServiceProtocol
    
    init(service: any RepositoryServiceProtocol) {
        self.service = service
    }
    
    var errorMessage: String? = nil
    
    var filters: [FilterCategory] = [
        FilterCategory(name: "Stars", options: StarsOption.allCases, defaultOption: .all),
        FilterCategory(name: "Language", options: LanguageOption.allCases, defaultOption: .all),
        FilterCategory(name: "License", options: LicenseOption.allCases, defaultOption: .all)
    ]
    
    var showFilterView: Bool = false
    
    var isFilterApplied: Bool {
        !filters.allSatisfy {
            $0.defaultOption == $0.selectedOption
        }
    }
    
    var appliedFilterOptions: [AnyFilterOption] {
        filters.map { $0.selectedOption }
    }
    
    var currentPage: UInt = 0
    var repositories: [Repository] = []
    
    var isReloading: Bool = false

    func reload() {
        guard !isReloading else {
            return
        }
        Task { @MainActor in
            isReloading = true
            currentPage = 0
            repositories = []
            await fetchRepositories(page: 1)
            isReloading = false
        }
    }
    
    var isLoadingMore: Bool = false
    
    func loadMore() {
        guard !isLoadingMore else {
            return
        }

        Task { @MainActor in
            isLoadingMore = true
            await fetchRepositories(page: currentPage + 1)
            isLoadingMore = false
        }
    }

    func fetchRepositories(page: UInt) async {
        do {
            let newRepositories = try await service.fetchRepositories(filters: appliedFilterOptions,
                                                                      perPage: 10,
                                                                      page: page)
            repositories.append(contentsOf: newRepositories)
            currentPage = page
            errorMessage = nil
        } catch {
            errorMessage = "❗️:" + error.localizedDescription
        }
    }
}
