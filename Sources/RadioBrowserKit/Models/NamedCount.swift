//
//  NamedCount.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A generic model representing a named item with a station count.
/// Used for countries, languages, tags, and codecs.
public struct NamedCount: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses the name).
    public var id: String { name }
    /// Name of the item (e.g., country name, language name, tag).
    public let name: String
    
    /// Number of stations associated with this item.
    public let stationcount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case stationcount
    }
}

