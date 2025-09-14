//
//  Bundle+Tests.swift
//  RepoBrowserTests
//
//  Created by Biao Luo on 14/09/2025.
//

import Foundation

extension Bundle {
    class TestBundle { }
    
    class var tests: Bundle {
        Bundle(for: TestBundle.self)
    }
}

func testData(fileName: String, extension: String) -> Data? {
    guard let url = Bundle.tests.url(forResource: fileName, withExtension: "json") else {
        return nil
    }
    return try? Data(contentsOf: url)
}
