//
//  IntegrationTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

final class IntegrationTests: XCTestCase {
    
    /// Live integration test that hits the actual Radio Browser API.
    /// Only runs when RB_LIVE_TESTS=1 environment variable is set.
    func testLiveAPI() async throws {
        // Check if live tests are enabled
        guard ProcessInfo.processInfo.environment["RB_LIVE_TESTS"] == "1" else {
            throw XCTSkip("Live tests disabled. Set RB_LIVE_TESTS=1 to enable.")
        }
        
        let client = RadioBrowser()
        
        // Test mirror discovery
        let mirrors = try await client.servers()
        XCTAssertFalse(mirrors.isEmpty, "Should discover at least one mirror")
        
        // Test stats endpoint
        let stats = try await client.stats()
        XCTAssertGreaterThan(stats.supportedStations ?? 0, 0, "Should have supported stations")
        
        // Test countries endpoint (small response)
        let countries = try await client.countries(limit: 5)
        XCTAssertLessThanOrEqual(countries.count, 5)
        if !countries.isEmpty {
            XCTAssertFalse(countries[0].name.isEmpty)
            XCTAssertGreaterThan(countries[0].stationcount, 0)
        }
        
        // Test search (if we have stations)
        if let firstCountry = countries.first {
            let stations = try await client.stationsByCountry(
                firstCountry.name,
                limit: 3,
                hidebroken: true
            )
            // May be empty, but shouldn't crash
            XCTAssertGreaterThanOrEqual(stations.count, 0)
            
            if !stations.isEmpty {
                // Test click endpoint (should work but may be rate-limited)
                do {
                    let clickResponse = try await client.click(stationUUID: stations[0].stationuuid)
                    XCTAssertEqual(clickResponse.stationuuid, stations[0].stationuuid)
                    XCTAssertTrue(clickResponse.ok)
                } catch RadioBrowserError.rateLimited {
                    // Expected if already clicked today
                    // This is fine, means the API is working
                }
            }
        }
    }
}

