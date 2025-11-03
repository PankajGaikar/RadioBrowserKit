//
//  AddStationRequest.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Request to add a new station to the Radio Browser database.
public struct AddStationRequest: Codable, Sendable {
    /// Name of the station (required).
    public let name: String
    
    /// Stream URL of the station (required).
    public let url: String
    
    /// Homepage URL (optional).
    public let homepage: String?
    
    /// Favicon URL (optional).
    public let favicon: String?
    
    /// Country code (optional, ISO 3166-1 alpha-2).
    public let countrycode: String?
    
    /// State or region (optional).
    public let state: String?
    
    /// Language(s) (optional, comma-separated).
    public let language: String?
    
    /// Tags (optional, comma-separated).
    public let tags: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case homepage
        case favicon
        case countrycode
        case state
        case language
        case tags
    }
    
    /// Initialize an AddStationRequest.
    /// - Parameters:
    ///   - name: Station name (required).
    ///   - url: Stream URL (required).
    ///   - homepage: Homepage URL (optional).
    ///   - favicon: Favicon URL (optional).
    ///   - countrycode: Country code (optional).
    ///   - state: State or region (optional).
    ///   - language: Language(s) (optional).
    ///   - tags: Tags (optional).
    public init(
        name: String,
        url: String,
        homepage: String? = nil,
        favicon: String? = nil,
        countrycode: String? = nil,
        state: String? = nil,
        language: String? = nil,
        tags: String? = nil
    ) {
        self.name = name
        self.url = url
        self.homepage = homepage
        self.favicon = favicon
        self.countrycode = countrycode
        self.state = state
        self.language = language
        self.tags = tags
    }
    
    /// Validates that required fields are present.
    public func validate() throws {
        guard !name.isEmpty else {
            throw RadioBrowserError.invalidRequest("Station name is required")
        }
        guard !url.isEmpty else {
            throw RadioBrowserError.invalidRequest("Station URL is required")
        }
    }
}

