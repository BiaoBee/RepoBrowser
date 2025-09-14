//
//  ExploreViewModel.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import Foundation
import SwiftUI

/// Type-erased filter option to be used as view model.
final class AnyFilterOption: Hashable, Identifiable, Equatable {
    /// The display name of the filter option.
    let name: String
    /// The query fragment to use in the API request.
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

/// Represents a filter category (like Stars, Language, or License) with its options and selection state.
@Observable
final class FilterCategory: Identifiable, Equatable {
    /// The name of the filter category.
    let name: String
    /// All available options for this category.
    let options: [AnyFilterOption]
    /// The currently selected option.
    var selectedOption: AnyFilterOption
    /// The default option for this category.
    let defaultOption: AnyFilterOption
    
    var id: String {
        name
    }
    
    /// Creates a new filter category.
    /// - Parameters:
    ///   - name: The category name.
    ///   - options: All possible options.
    ///   - defaultOption: The default option.
    init<T: FilterOption>(name: String, options: [T], defaultOption: T) {
        self.name = name
        self.options = options.map {
            AnyFilterOption($0)
        }
        self.selectedOption = AnyFilterOption(defaultOption)
        self.defaultOption = AnyFilterOption(defaultOption)
    }
    
    /// Resets the selected option to the default.
    func resetToDefault() {
        selectedOption = defaultOption
    }
    
    static func == (lhs: FilterCategory, rhs: FilterCategory) -> Bool {
        lhs.name == rhs.name &&
        lhs.options == rhs.options &&
        lhs.selectedOption == rhs.selectedOption &&
        lhs.defaultOption == rhs.defaultOption
    }
}

/// The main view model for the Explore screen.
@Observable
@MainActor
final class ExploreViewModel {
    let service: any RepositoryServiceProtocol
    
    init(service: any RepositoryServiceProtocol) {
        self.service = service
    }
    
    /// The current error message to display.
    var errorMessage: String? = nil
    
    /// The list of filter options.
    var filters: [FilterCategory] = [
        FilterCategory(name: "Stars", options: StarsOption.allCases, defaultOption: .all),
        FilterCategory(name: "Language", options: LanguageOption.allCases, defaultOption: .all),
        FilterCategory(name: "License", options: LicenseOption.allCases, defaultOption: .all)
    ]
    
    /// Whether the filter view is currently shown.
    var showFilterView: Bool = false
    
    /// Whether any filter is applied (not all are at their default).
    var isFilterApplied: Bool {
        !filters.allSatisfy {
            $0.defaultOption == $0.selectedOption
        }
    }
    
    /// The currently selected filter options.
    var appliedFilterOptions: [AnyFilterOption] {
        filters.map { $0.selectedOption }
    }
    
    /// The current page of results.
    var currentPage: UInt = 0
    
    var repositories: [Repository] = []
    
    /// Whether a reload is in progress.
    var isReloading: Bool = false

    /// Reloads repositories from the first page, clearing previous results.
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
    
    /// Whether a "load more" request is in progress.
    var isLoadingMore: Bool = false
    
    /// Loads the next page of repositories and appends them to the list.
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

    /// Fetches repositories for a given page, updating the repositories list and error state.
    /// - Parameter page: The page number to fetch.
    func fetchRepositories(page: UInt) async {
        do {
            let newRepositories = try await service.fetchRepositories(filters: appliedFilterOptions,
                                                                      page: page,
                                                                      perPage: 10)
            repositories.append(contentsOf: newRepositories)
            currentPage = page
            errorMessage = nil
        } catch {
            errorMessage = "❗️" + error.localizedDescription
        }
    }
}
