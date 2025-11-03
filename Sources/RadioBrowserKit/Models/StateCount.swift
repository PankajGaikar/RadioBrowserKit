//
//  StateCount.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A model representing state-level station counts.
public struct StateCount: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (combines country and state name).
    public var id: String { "\(country)-\(name)" }
    /// Name of the state or region.
    public let name: String
    
    /// Country code where this state is located.
    public let country: String
    
    /// Number of stations in this state.
    public let stationcount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case stationcount
    }
}

