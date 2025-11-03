//
//  ServerStats.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Statistics about the Radio Browser service.
public struct ServerStats: Codable, Sendable {
    /// Total number of stations.
    public let supportedStations: Int?
    
    /// Total number of broken stations.
    public let brokenStations: Int?
    
    /// Total number of countries.
    public let supportedCountries: Int?
    
    /// Total number of clicks.
    public let supportedClicks: Int?
    
    /// Timestamp of last update.
    public let lastUpdate: Date?
    
    enum CodingKeys: String, CodingKey {
        case supportedStations = "supported_stations"
        case brokenStations = "broken_stations"
        case supportedCountries = "supported_countries"
        case supportedClicks = "supported_clicks"
        case lastUpdate = "last_update"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        supportedStations = try container.decodeIfPresent(Int.self, forKey: .supportedStations)
        brokenStations = try container.decodeIfPresent(Int.self, forKey: .brokenStations)
        supportedCountries = try container.decodeIfPresent(Int.self, forKey: .supportedCountries)
        supportedClicks = try container.decodeIfPresent(Int.self, forKey: .supportedClicks)
        
        // Handle timestamp as TimeInterval (number) or String
        if let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .lastUpdate) {
            lastUpdate = Date(timeIntervalSince1970: timestamp)
        } else if let timestampString = try container.decodeIfPresent(String.self, forKey: .lastUpdate),
                  let timestamp = TimeInterval(timestampString) {
            lastUpdate = Date(timeIntervalSince1970: timestamp)
        } else {
            lastUpdate = nil
        }
    }
}

