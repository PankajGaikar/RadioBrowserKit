//
//  ClickResponse.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Response from clicking a station (incrementing its click count).
public struct ClickResponse: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses stationuuid).
    public var id: String { stationuuid }
    /// UUID of the station that was clicked.
    public let stationuuid: String
    
    /// Resolved URL of the station.
    public let url: String
    
    /// Whether the operation was successful.
    public let ok: Bool
    
    /// Optional message.
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case url
        case ok
        case message
    }
    
    /// Initialize a ClickResponse.
    public init(stationuuid: String, url: String, ok: Bool, message: String? = nil) {
        self.stationuuid = stationuuid
        self.url = url
        self.ok = ok
        self.message = message
    }
}

