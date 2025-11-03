//
//  Station.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A radio station in the Radio Browser database.
public struct Station: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (same as `stationuuid`).
    public var id: String { stationuuid }
    /// Unique identifier for the station (UUID string).
    public let stationuuid: String
    
    /// Name of the radio station.
    public let name: String
    
    /// Original URL of the station.
    public let url: String
    
    /// Resolved URL (may differ from `url` if redirects occurred).
    public let urlResolved: String?
    
    /// Homepage URL of the station.
    public let homepage: String?
    
    /// Favicon URL of the station.
    public let favicon: String?
    
    /// ISO 3166-1 alpha-2 country code (e.g., "US", "DE").
    public let countrycode: String?
    
    /// State or region name.
    public let state: String?
    
    /// Language(s) spoken on the station (comma-separated).
    public let language: String?
    
    /// Tags describing the station (comma-separated).
    public let tags: String?
    
    /// Audio codec used (e.g., "MP3", "AAC").
    public let codec: String?
    
    /// Bitrate in kbps.
    public let bitrate: Int?
    
    /// Whether the stream uses HLS (HTTP Live Streaming).
    public let hls: Bool?
    
    /// Number of votes for this station.
    public let votes: Int?
    
    /// Whether the last check was successful.
    public let lastcheckok: Bool?
    
    /// Timestamp of the last check (Unix epoch).
    public let lastchecktime: Date?
    
    /// Total number of clicks.
    public let clickcount: Int?
    
    /// Click trend (change in clicks over time).
    public let clicktrend: Int?
    
    /// Geographic latitude.
    public let geoLat: Double?
    
    /// Geographic longitude.
    public let geoLong: Double?
    
    /// Distance from a reference point (when geo searching).
    public let geoDistance: Double?
    
    /// Whether extended info is available.
    public let hasExtendedInfo: Bool?
    
    /// Timestamp when the station was first added.
    public let added: Date?
    
    /// Timestamp when the station was last modified.
    public let lastchangetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case name
        case url
        case urlResolved = "url_resolved"
        case homepage
        case favicon
        case countrycode
        case state
        case language
        case tags
        case codec
        case bitrate
        case hls
        case votes
        case lastcheckok
        case lastchecktime
        case clickcount
        case clicktrend
        case geoLat = "geo_lat"
        case geoLong = "geo_long"
        case geoDistance = "geo_distance"
        case hasExtendedInfo = "has_extended_info"
        case added
        case lastchangetime
    }
    
    /// Custom decoding that handles missing fields gracefully.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stationuuid = try container.decode(String.self, forKey: .stationuuid)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
        urlResolved = try container.decodeIfPresent(String.self, forKey: .urlResolved)
        homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        favicon = try container.decodeIfPresent(String.self, forKey: .favicon)
        countrycode = try container.decodeIfPresent(String.self, forKey: .countrycode)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        codec = try container.decodeIfPresent(String.self, forKey: .codec)
        bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate)
        hls = try container.decodeIfPresent(Bool.self, forKey: .hls)
        votes = try container.decodeIfPresent(Int.self, forKey: .votes)
        lastcheckok = try container.decodeIfPresent(Bool.self, forKey: .lastcheckok)
        
        // Handle Unix timestamp decoding
        if let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .lastchecktime) {
            lastchecktime = Date(timeIntervalSince1970: timestamp)
        } else {
            lastchecktime = nil
        }
        
        clickcount = try container.decodeIfPresent(Int.self, forKey: .clickcount)
        clicktrend = try container.decodeIfPresent(Int.self, forKey: .clicktrend)
        geoLat = try container.decodeIfPresent(Double.self, forKey: .geoLat)
        geoLong = try container.decodeIfPresent(Double.self, forKey: .geoLong)
        geoDistance = try container.decodeIfPresent(Double.self, forKey: .geoDistance)
        hasExtendedInfo = try container.decodeIfPresent(Bool.self, forKey: .hasExtendedInfo)
        
        if let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .added) {
            added = Date(timeIntervalSince1970: timestamp)
        } else {
            added = nil
        }
        
        if let timestamp = try container.decodeIfPresent(TimeInterval.self, forKey: .lastchangetime) {
            lastchangetime = Date(timeIntervalSince1970: timestamp)
        } else {
            lastchangetime = nil
        }
    }
}

