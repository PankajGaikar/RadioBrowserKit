//
//  ModelDecodingTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

final class ModelDecodingTests: XCTestCase {
    
    // MARK: - Helper
    
    func loadFixture(_ filename: String) throws -> Data {
        // Try multiple approaches to find the fixture
        let bundle = Bundle(for: type(of: self))
        
        // Try with subdirectory first
        if let url = bundle.url(forResource: filename, withExtension: "json", subdirectory: "Fixtures") {
            return try Data(contentsOf: url)
        }
        
        // Try without subdirectory
        if let url = bundle.url(forResource: filename, withExtension: "json") {
            return try Data(contentsOf: url)
        }
        
        // Try with module bundle (Swift Package Manager)
        #if canImport(RadioBrowserKitTests)
        if let moduleURL = Bundle.module.url(forResource: filename, withExtension: "json", subdirectory: "Fixtures") {
            return try Data(contentsOf: moduleURL)
        }
        #endif
        
        // Fallback: try relative to test file
        let testFileURL = URL(fileURLWithPath: #file)
        let testDir = testFileURL.deletingLastPathComponent()
        let fixtureURL = testDir.appendingPathComponent("Fixtures").appendingPathComponent("\(filename).json")
        
        if FileManager.default.fileExists(atPath: fixtureURL.path) {
            return try Data(contentsOf: fixtureURL)
        }
        
        throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fixture not found: \(filename).json"])
    }
    
    // MARK: - Station Tests
    
    func testStationDecoding() throws {
        let data = try loadFixture("station")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let station = try decoder.decode(Station.self, from: data)
        
        XCTAssertEqual(station.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c81")
        XCTAssertEqual(station.name, "Radio Paradise")
        XCTAssertEqual(station.url, "http://stream.radioparadise.com/mp3-192")
        XCTAssertEqual(station.urlResolved, "http://stream.radioparadise.com/mp3-192")
        XCTAssertEqual(station.homepage, "https://radioparadise.com/")
        XCTAssertEqual(station.favicon, "https://radioparadise.com/favicon.ico")
        XCTAssertEqual(station.countrycode, "US")
        XCTAssertEqual(station.state, "California")
        XCTAssertEqual(station.language, "English")
        XCTAssertEqual(station.tags, "rock,pop,eclectic")
        XCTAssertEqual(station.codec, "MP3")
        XCTAssertEqual(station.bitrate, 192)
        XCTAssertEqual(station.votes, 1234)
        XCTAssertEqual(station.clickcount, 5678)
        XCTAssertEqual(station.clicktrend, 12)
        XCTAssertEqual(station.hls, false)
        XCTAssertEqual(station.lastcheckok, true)
        XCTAssertEqual(station.hasExtendedInfo, true)
        XCTAssertNotNil(station.geoLat)
        XCTAssertNotNil(station.geoLong)
        XCTAssertNotNil(station.added)
        XCTAssertNotNil(station.lastchangetime)
        
        // Test Identifiable
        XCTAssertEqual(station.id, station.stationuuid)
    }
    
    func testStationDecodingWithMissingOptionals() throws {
        // Create minimal station JSON
        let minimalJSON = """
        {
          "stationuuid": "960e29ac-0601-11e8-ae97-52543be04c81",
          "name": "Test Station",
          "url": "http://example.com/stream"
        }
        """
        let data = minimalJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let station = try decoder.decode(Station.self, from: data)
        
        XCTAssertEqual(station.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c81")
        XCTAssertEqual(station.name, "Test Station")
        XCTAssertNil(station.urlResolved)
        XCTAssertNil(station.homepage)
        XCTAssertNil(station.favicon)
    }
    
    // MARK: - NamedCount Tests
    
    func testNamedCountDecoding() throws {
        let data = try loadFixture("named_count")
        let decoder = JSONDecoder()
        
        let counts = try decoder.decode([NamedCount].self, from: data)
        
        XCTAssertEqual(counts.count, 2)
        XCTAssertEqual(counts[0].name, "United States")
        XCTAssertEqual(counts[0].stationcount, 12345)
        XCTAssertEqual(counts[0].id, "United States") // Identifiable
        XCTAssertEqual(counts[1].name, "Germany")
        XCTAssertEqual(counts[1].stationcount, 8901)
    }
    
    // MARK: - StateCount Tests
    
    func testStateCountDecoding() throws {
        let data = try loadFixture("state_count")
        let decoder = JSONDecoder()
        
        let counts = try decoder.decode([StateCount].self, from: data)
        
        XCTAssertEqual(counts.count, 2)
        XCTAssertEqual(counts[0].name, "California")
        XCTAssertEqual(counts[0].country, "United States")
        XCTAssertEqual(counts[0].stationcount, 1234)
        XCTAssertEqual(counts[0].id, "United States-California") // Identifiable
    }
    
    // MARK: - ServerStats Tests
    
    func testServerStatsDecoding() throws {
        let data = try loadFixture("server_stats")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let stats = try decoder.decode(ServerStats.self, from: data)
        
        XCTAssertEqual(stats.supportedStations, 35000)
        XCTAssertEqual(stats.brokenStations, 1234)
        XCTAssertEqual(stats.supportedCountries, 245)
        XCTAssertEqual(stats.supportedClicks, 1234567)
        XCTAssertNotNil(stats.lastUpdate)
    }
    
    // MARK: - ClickResponse Tests
    
    func testClickResponseDecoding() throws {
        let data = try loadFixture("click_response")
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(ClickResponse.self, from: data)
        
        XCTAssertEqual(response.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c81")
        XCTAssertEqual(response.url, "http://stream.radioparadise.com/mp3-192")
        XCTAssertEqual(response.ok, true)
        XCTAssertEqual(response.message, "OK")
        XCTAssertEqual(response.id, response.stationuuid) // Identifiable
    }
    
    // MARK: - VoteResponse Tests
    
    func testVoteResponseDecoding() throws {
        let data = try loadFixture("vote_response")
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(VoteResponse.self, from: data)
        
        XCTAssertEqual(response.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c81")
        XCTAssertEqual(response.votes, 1235)
        XCTAssertEqual(response.ok, true)
        XCTAssertEqual(response.message, "OK")
        XCTAssertEqual(response.id, response.stationuuid) // Identifiable
    }
    
    // MARK: - StationClick Tests
    
    func testStationClickDecoding() throws {
        let data = try loadFixture("station_click")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let click = try decoder.decode(StationClick.self, from: data)
        
        XCTAssertEqual(click.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c81")
        XCTAssertNotNil(click.clickTimestamp)
        XCTAssertEqual(click.ip, "192.168.1.1")
        XCTAssertEqual(click.userAgent, "RadioBrowserKit/1.0")
        XCTAssertNotNil(click.id) // Identifiable with timestamp
    }
    
    // MARK: - StreamingServerMirror Tests
    
    func testStreamingServerMirrorDecoding() throws {
        let data = try loadFixture("streaming_server_mirror")
        let decoder = JSONDecoder()
        
        let mirrors = try decoder.decode([StreamingServerMirror].self, from: data)
        
        XCTAssertEqual(mirrors.count, 2)
        XCTAssertEqual(mirrors[0].name, "de1.api.radio-browser.info")
        XCTAssertEqual(mirrors[0].url, "https://de1.api.radio-browser.info")
        XCTAssertEqual(mirrors[0].ip, "1.2.3.4")
        XCTAssertEqual(mirrors[0].location, "Germany")
        XCTAssertEqual(mirrors[0].id, mirrors[0].url) // Identifiable
    }
    
    // MARK: - AddStationResponse Tests
    
    func testAddStationResponseDecoding() throws {
        let data = try loadFixture("add_station_response")
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(AddStationResponse.self, from: data)
        
        XCTAssertEqual(response.stationuuid, "960e29ac-0601-11e8-ae97-52543be04c82")
        XCTAssertEqual(response.ok, true)
        XCTAssertEqual(response.message, "Station added successfully")
    }
    
    // MARK: - Empty Array Tests
    
    func testEmptyArrayDecoding() throws {
        let emptyJSON = "[]"
        let data = emptyJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let stations = try decoder.decode([Station].self, from: data)
        XCTAssertEqual(stations.count, 0)
        
        let counts = try decoder.decode([NamedCount].self, from: data)
        XCTAssertEqual(counts.count, 0)
    }
}

