//
//  RadioBrowserTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

final class RadioBrowserTests: XCTestCase {
    
    func testRadioBrowserInitialization() async {
        let client = RadioBrowser()
        // Basic smoke test - RadioBrowser is an actor
        let _ = await client
        XCTAssertTrue(true) // If we get here, initialization worked
    }
}

