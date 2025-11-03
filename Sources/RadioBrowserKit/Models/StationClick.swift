//
//  StationClick.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A record of a station click event.
public struct StationClick: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (combines stationuuid and timestamp for uniqueness).
    public var id: String {
        if let timestamp = clickTimestamp {
            return "\(stationuuid)-\(timestamp.timeIntervalSince1970)"
        }
        return stationuuid
    }
    
    /// UUID of the station that was clicked.
    public let stationuuid: String
    
    /// Timestamp when the click occurred (optional, as API may not always include it).
    public let clickTimestamp: Date?
    
    /// IP address that performed the click.
    public let ip: String?
    
    /// User agent string (if available).
    public let userAgent: String?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case clickTimestamp = "click_timestamp"
        case ip
        case userAgent = "user_agent"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stationuuid = try container.decode(String.self, forKey: .stationuuid)
        
        // Handle timestamp as TimeInterval (number) or String, or optional
        if let timestamp = try? container.decode(TimeInterval.self, forKey: .clickTimestamp) {
            clickTimestamp = Date(timeIntervalSince1970: timestamp)
        } else if let timestampString = try? container.decode(String.self, forKey: .clickTimestamp),
                  let timestamp = TimeInterval(timestampString) {
            clickTimestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            clickTimestamp = nil
        }
        
        ip = try container.decodeIfPresent(String.self, forKey: .ip)
        userAgent = try container.decodeIfPresent(String.self, forKey: .userAgent)
    }
}

