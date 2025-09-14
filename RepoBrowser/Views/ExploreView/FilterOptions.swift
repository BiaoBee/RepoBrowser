//
//  FilterOptions.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import Foundation

/// A protocol for filter options used in repository search.
protocol FilterOption: RawRepresentable where RawValue == String {
    /// The display name of the filter option.
    var name: String { get }
    /// The query fragment to use in the GitHub API request.
    var queryFragment: String? { get }
}

extension FilterOption {
    /// By default, the name is just the raw value, to enable enum-based options.
    var name: String {
        rawValue
    }
}

/// Filter options for the number of stars a repository has.
enum StarsOption: String, FilterOption, CaseIterable {
    case all = "All"
    case new = "New(⭐0–50)"
    case small = "Small(⭐51–500)"
    case popular = "Popular(⭐501–5,000)"
    case trending = "Trending(⭐ 5,000+)"
    
    /// The query fragment for the stars filter.
    var queryFragment: String? {
        switch self {
        case .new: 
            "stars:0..50"
        case .small:
            "stars:51..500"
        case .popular: 
            "stars:501..5000"
        case .trending: 
            "stars:>5000"
        case .all:
            "stars:0..1000000"
        }
    }
}

/// Filter options for the programming language of a repository.
enum LanguageOption: String, FilterOption, CaseIterable {
    case all = "All"
    case javaScript = "JavaScript"
    case typeScript = "TypeScript"
    case python = "Python"
    case go = "Go"
    case java = "Java"
    case swift = "Swift"
    
    /// The query fragment for the language filter.
    var queryFragment: String? {
        if self == .all {
            return nil
        }
        return "language:\(name)"
    }
}

/// Filter options for the license of a repository.
enum LicenseOption: String, FilterOption, CaseIterable {
    case all = "All"
    case mit = "MIT"
    case apache2_0 = "Apache-2.0"
    case gpl3_0 = "GPL-3.0"
    case bsd3clause = "BSD-3-Clause"
    case mpl2_0 = "MPL-2.0"
    
    /// The query fragment for the license filter.
    var queryFragment: String? {
        if self == .all {
            return nil
        }
        return "license:\(name.lowercased())"
    }
}
