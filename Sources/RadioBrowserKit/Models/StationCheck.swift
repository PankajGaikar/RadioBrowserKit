//
//  StationCheck.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Result of a station check operation.
public struct StationCheck: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (combines stationuuid and timestamp for uniqueness).
    public var id: String {
        if let timestamp = timestamp {
            return "\(stationuuid)-\(timestamp.timeIntervalSince1970)"
        }
        return stationuuid
    }
    /// UUID of the checked station.
    public let stationuuid: String
    
    /// Whether the check was successful.
    public let ok: Bool
    
    /// Timestamp of the check.
    public let timestamp: Date?
    
    /// Steps performed during the check.
    public let steps: [StationCheckStep]?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case ok
        case timestamp
        case steps
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stationuuid = try container.decode(String.self, forKey: .stationuuid)
        ok = try container.decode(Bool.self, forKey: .ok)
        
        if let timestampValue = try container.decodeIfPresent(TimeInterval.self, forKey: .timestamp) {
            timestamp = Date(timeIntervalSince1970: timestampValue)
        } else {
            timestamp = nil
        }
        
        steps = try container.decodeIfPresent([StationCheckStep].self, forKey: .steps)
    }
}

