//
//  IntegrationTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

/// Live integration tests that hit the actual Radio Browser API.
/// Only runs when RB_LIVE_TESTS=1 environment variable is set.
/// 
/// These tests verify that the client correctly communicates with the real API
/// and that responses are properly decoded. They may be slower and subject to
/// rate limits, so they're disabled by default.
final class IntegrationTests: XCTestCase {
    
    var client: RadioBrowser!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Check if live tests are enabled
        guard ProcessInfo.processInfo.environment["RB_LIVE_TESTS"] == "1" else {
            throw XCTSkip("Live tests disabled. Set RB_LIVE_TESTS=1 to enable.")
        }
        
        client = RadioBrowser()
    }
    
    // MARK: - Service Info Tests
    
    func testServers() async throws {
        let mirrors = try await client.servers()
        XCTAssertFalse(mirrors.isEmpty, "Should discover at least one mirror")
        XCTAssertFalse(mirrors[0].name.isEmpty)
        XCTAssertFalse(mirrors[0].url.isEmpty)
    }
    
    func testStats() async throws {
        let stats = try await client.stats()
        XCTAssertGreaterThan(stats.supportedStations ?? 0, 0, "Should have supported stations")
        XCTAssertGreaterThan(stats.supportedCountries ?? 0, 0, "Should have supported countries")
    }
    
    func testConfig() async throws {
        let config = try await client.config()
        // Config may or may not have values, just ensure it doesn't crash
        _ = config
    }
    
    // MARK: - List Endpoints Tests
    
    func testCountries() async throws {
        let countries = try await client.countries(limit: 10)
        XCTAssertLessThanOrEqual(countries.count, 10)
        if !countries.isEmpty {
            XCTAssertFalse(countries[0].name.isEmpty)
            XCTAssertGreaterThan(countries[0].stationcount, 0)
        }
        
        // Test with filter
        if let firstCountry = countries.first {
            let filtered = try await client.countries(filter: firstCountry.name, limit: 5)
            XCTAssertLessThanOrEqual(filtered.count, 5)
        }
    }
    
    func testLanguages() async throws {
        let languages = try await client.languages(limit: 10)
        XCTAssertLessThanOrEqual(languages.count, 10)
        if !languages.isEmpty {
            XCTAssertFalse(languages[0].name.isEmpty)
            XCTAssertGreaterThan(languages[0].stationcount, 0)
        }
    }
    
    func testTags() async throws {
        let tags = try await client.tags(limit: 10)
        XCTAssertLessThanOrEqual(tags.count, 10)
        if !tags.isEmpty {
            XCTAssertFalse(tags[0].name.isEmpty)
            XCTAssertGreaterThan(tags[0].stationcount, 0)
        }
    }
    
    func testStates() async throws {
        // Get a country first
        let countries = try await client.countries(limit: 1)
        if let country = countries.first {
            let states = try await client.states(country: country.name, limit: 10)
            XCTAssertLessThanOrEqual(states.count, 10)
            if !states.isEmpty {
                XCTAssertFalse(states[0].name.isEmpty)
                XCTAssertEqual(states[0].country, country.name)
            }
        }
    }
    
    func testCodecs() async throws {
        let codecs = try await client.codecs(limit: 10)
        XCTAssertLessThanOrEqual(codecs.count, 10)
        if !codecs.isEmpty {
            XCTAssertFalse(codecs[0].name.isEmpty)
            XCTAssertGreaterThan(codecs[0].stationcount, 0)
        }
    }
    
    // MARK: - Station Endpoints Tests
    
    func testStationsByCountry() async throws {
        let countries = try await client.countries(limit: 1)
        guard let country = countries.first else {
            XCTSkip("No countries available")
            return
        }
        
        let stations = try await client.stationsByCountry(
            country.name,
            limit: 5,
            hidebroken: true
        )
        XCTAssertLessThanOrEqual(stations.count, 5)
        
        if !stations.isEmpty {
            XCTAssertFalse(stations[0].name.isEmpty)
            XCTAssertEqual(stations[0].countrycode, country.name)
        }
    }
    
    func testStationsByCountryCode() async throws {
        let stations = try await client.stationsByCountryCode(
            "US",
            limit: 5,
            hidebroken: true
        )
        XCTAssertLessThanOrEqual(stations.count, 5)
        
        if !stations.isEmpty {
            XCTAssertEqual(stations[0].countrycode, "US")
        }
    }
    
    func testStationsByName() async throws {
        // Search for a common station name
        let stations = try await client.stationsByName(
            "Radio",
            limit: 5,
            hidebroken: true
        )
        XCTAssertLessThanOrEqual(stations.count, 5)
        
        if !stations.isEmpty {
            XCTAssertTrue(stations[0].name.localizedCaseInsensitiveContains("Radio"))
        }
    }
    
    func testStationsByUUID() async throws {
        // First get a station UUID
        let stations = try await client.stationsByCountryCode("US", limit: 1, hidebroken: true)
        guard let station = stations.first else {
            XCTSkip("No stations available")
            return
        }
        
        // Then fetch by UUID
        let fetchedStations = try await client.stationsByUUID([station.stationuuid])
        XCTAssertFalse(fetchedStations.isEmpty)
        XCTAssertEqual(fetchedStations[0].stationuuid, station.stationuuid)
    }
    
    func testStationsByTag() async throws {
        let tags = try await client.tags(limit: 1)
        guard let tag = tags.first else {
            XCTSkip("No tags available")
            return
        }
        
        let stations = try await client.stationsByTag(
            tag.name,
            limit: 5,
            hidebroken: true
        )
        XCTAssertLessThanOrEqual(stations.count, 5)
    }
    
    func testStationsByLanguage() async throws {
        let languages = try await client.languages(limit: 1)
        guard let language = languages.first else {
            XCTSkip("No languages available")
            return
        }
        
        let stations = try await client.stationsByLanguage(
            language.name,
            limit: 5,
            hidebroken: true
        )
        XCTAssertLessThanOrEqual(stations.count, 5)
    }
    
    // MARK: - Ranking Endpoints Tests
    
    func testTopClick() async throws {
        let stations = try await client.topClick(10)
        XCTAssertLessThanOrEqual(stations.count, 10)
        
        if stations.count >= 2 {
            // Top clicked should have higher clickcount
            XCTAssertGreaterThanOrEqual(stations[0].clickcount ?? 0, stations[1].clickcount ?? 0)
        }
    }
    
    func testTopVote() async throws {
        let stations = try await client.topVote(10)
        XCTAssertLessThanOrEqual(stations.count, 10)
        
        if stations.count >= 2 {
            // Top voted should have higher votes
            XCTAssertGreaterThanOrEqual(stations[0].votes ?? 0, stations[1].votes ?? 0)
        }
    }
    
    func testLastClick() async throws {
        let stations = try await client.lastClick(10)
        XCTAssertLessThanOrEqual(stations.count, 10)
    }
    
    func testLastChange() async throws {
        let stations = try await client.lastChange(10)
        XCTAssertLessThanOrEqual(stations.count, 10)
    }
    
    func testBroken() async throws {
        let stations = try await client.broken(10)
        XCTAssertLessThanOrEqual(stations.count, 10)
        
        // Broken stations should have lastcheckok = false
        for station in stations {
            XCTAssertEqual(station.lastcheckok, false, "Broken stations should have lastcheckok = false")
        }
    }
    
    // MARK: - Advanced Search Tests
    
    func testAdvancedSearch() async throws {
        var query = StationSearchQuery()
        query.countrycode = "US"
        query.bitrateMin = 128
        query.isHTTPS = false
        query.hidebroken = true
        query.limit = 5
        
        let stations = try await client.search(query)
        XCTAssertLessThanOrEqual(stations.count, 5)
        
        // Verify filters applied
        for station in stations {
            XCTAssertEqual(station.countrycode, "US")
            if let bitrate = station.bitrate {
                XCTAssertGreaterThanOrEqual(bitrate, 128)
            }
        }
    }
    
    func testAdvancedSearchWithTagList() async throws {
        var query = StationSearchQuery()
        query.tagList = ["rock", "pop"]
        query.countrycode = "US"
        query.limit = 5
        
        // Use POST for tagList
        let stations = try await client.search(query, usePOST: true)
        XCTAssertLessThanOrEqual(stations.count, 5)
    }
    
    // MARK: - Interactions Tests
    
    func testClick() async throws {
        // Get a station first
        let stations = try await client.stationsByCountryCode("US", limit: 1, hidebroken: true)
        guard let station = stations.first else {
            XCTSkip("No stations available")
            return
        }
        
        do {
            let response = try await client.click(stationUUID: station.stationuuid)
            XCTAssertEqual(response.stationuuid, station.stationuuid)
            XCTAssertTrue(response.ok)
            XCTAssertFalse(response.url.isEmpty)
        } catch RadioBrowserError.rateLimited {
            // Expected if already clicked today - this is fine, means API works
        }
    }
    
    func testVote() async throws {
        // Get a station first
        let stations = try await client.stationsByCountryCode("US", limit: 1, hidebroken: true)
        guard let station = stations.first else {
            XCTSkip("No stations available")
            return
        }
        
        do {
            let response = try await client.vote(stationUUID: station.stationuuid)
            XCTAssertEqual(response.stationuuid, station.stationuuid)
            XCTAssertTrue(response.ok)
            XCTAssertGreaterThanOrEqual(response.votes, 0)
        } catch RadioBrowserError.rateLimited {
            // Expected if voted in last 10 minutes - this is fine, means API works
        }
    }
    
    // Note: We skip addStation test to avoid polluting the database
    
    // MARK: - Diagnostics Tests
    
    func testClicks() async throws {
        // Get global clicks (limited)
        let clicks = try await client.clicks(seconds: 3600, lastClickUUID: nil)
        XCTAssertGreaterThanOrEqual(clicks.count, 0)
        
        // Get clicks for a specific station
        let stations = try await client.stationsByCountryCode("US", limit: 1, hidebroken: true)
        if let station = stations.first {
            let stationClicks = try await client.clicks(
                stationUUID: station.stationuuid,
                seconds: 3600,
                lastClickUUID: nil
            )
            XCTAssertGreaterThanOrEqual(stationClicks.count, 0)
            
            // Test pagination if we have clicks
            if !stationClicks.isEmpty {
                let nextPage = try await client.clicks(
                    stationUUID: station.stationuuid,
                    seconds: 3600,
                    lastClickUUID: stationClicks.last?.stationuuid
                )
                // May be empty or have results
                XCTAssertGreaterThanOrEqual(nextPage.count, 0)
            }
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testNotFound() async throws {
        // Try to get station with invalid UUID
        do {
            let _ = try await client.stationsByUUID(["invalid-uuid-12345"])
            // API might return empty array instead of 404, which is fine
        } catch RadioBrowserError.notFound {
            // Expected for invalid UUIDs
        }
    }
    
    func testInvalidURL() async throws {
        // Try to get station by invalid URL
        do {
            let _ = try await client.stationsByURL("not-a-valid-url")
            // API might return empty array, which is fine
        } catch {
            // Any error is acceptable for invalid URL
        }
    }
}
