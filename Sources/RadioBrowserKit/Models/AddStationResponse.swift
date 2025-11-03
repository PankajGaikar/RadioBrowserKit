//
//  AddStationResponse.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Response from adding a new station.
public struct AddStationResponse: Codable, Sendable {
    /// UUID of the newly created station.
    public let stationuuid: String
    
    /// Whether the operation was successful.
    public let ok: Bool
    
    /// Optional message or error description.
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case ok
        case message
    }
}

