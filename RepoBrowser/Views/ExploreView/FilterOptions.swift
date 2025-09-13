//
//  FilterOptions.swift
//  RepoBrowser
//
//  Created by Biao Luo on 11/09/2025.
//

import Foundation

protocol FilterOption: RawRepresentable where RawValue == String {
    var name: String { get }
    var queryFragment: String? { get }
}

extension FilterOption {
    var name: String {
        rawValue
    }
}

enum StarsOption: String, FilterOption, CaseIterable {
    case all = "All"
    case new = "New(⭐0–50)"
    case small = "Small(⭐51–500)"
    case popular = "Popular(⭐501–5,000)"
    case trending = "Trending(⭐ 5,000+)"
    
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

enum LanguageOption: String, FilterOption, CaseIterable {
    case all = "All"
    case javaScript = "JavaScript"
    case typeScript = "TypeScript"
    case python = "Python"
    case go = "Go"
    case java = "Java"
    case swift = "Swift"
    
    var queryFragment: String? {
        if self == .all {
            return nil
        }
        return "language:\(name)"
    }
}

enum LicenseOption: String, FilterOption, CaseIterable {
    case all = "All"
    case mit = "MIT"
    case apache2_0 = "Apache-2.0"
    case gpl3_0 = "GPL-3.0"
    case bsd3clause = "BSD-3-Clause"
    case mpl2_0 = "MPL-2.0"
    
    var queryFragment: String? {
        if self == .all {
            return nil
        }
        return "license:\(name.lowercased())"
    }
}
