//
//  RadioBrowserTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

final class RadioBrowserTests: XCTestCase {
    
    func testRadioBrowserInitialization() {
        let client = RadioBrowser()
        // Basic smoke test
        XCTAssertNotNil(client)
    }
}

