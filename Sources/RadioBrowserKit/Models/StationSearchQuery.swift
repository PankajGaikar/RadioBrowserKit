//
//  StationSearchQuery.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Query builder for advanced station search with multiple filters.
public struct StationSearchQuery: Sendable {
    /// Station name filter (partial match).
    public var name: String?
    
    /// Station name filter (exact match).
    public var nameExact: String?
    
    /// Country name filter (partial match).
    public var country: String?
    
    /// Country name filter (exact match).
    public var countryExact: String?
    
    /// Country code filter (ISO 3166-1 alpha-2, exact match).
    public var countrycode: String?
    
    /// State name filter (partial match).
    public var state: String?
    
    /// State name filter (exact match).
    public var stateExact: String?
    
    /// Language name filter (partial match).
    public var language: String?
    
    /// Language name filter (exact match).
    public var languageExact: String?
    
    /// Tag filter (partial match).
    public var tag: String?
    
    /// Tag filter (exact match).
    public var tagExact: String?
    
    /// Tag list (AND logic - station must have all tags).
    public var tagList: [String]?
    
    /// Codec filter (e.g., "MP3", "AAC").
    public var codec: String?
    
    /// Minimum bitrate in kbps.
    public var bitrateMin: Int?
    
    /// Maximum bitrate in kbps.
    public var bitrateMax: Int?
    
    /// Whether to filter for HTTPS streams only.
    public var isHTTPS: Bool?
    
    /// Whether to filter for stations with geo information.
    public var hasGeoInfo: Bool?
    
    /// Whether to filter for stations with extended info.
    public var hasExtendedInfo: Bool?
    
    /// Geographic latitude for distance search.
    public var geoLat: Double?
    
    /// Geographic longitude for distance search.
    public var geoLong: Double?
    
    /// Maximum distance in kilometers from geo coordinates.
    public var geoDistance: Double?
    
    /// Sort order.
    public var order: SortOrder?
    
    /// Whether to reverse sort order.
    public var reverse: Bool?
    
    /// Pagination offset.
    public var offset: Int?
    
    /// Pagination limit.
    public var limit: Int?
    
    /// Whether to hide broken stations (default: true).
    public var hidebroken: Bool?
    
    /// Initialize an empty search query.
    public init() {}
    
    /// Convert query to URL query parameters dictionary (for GET requests).
    /// - Returns: Dictionary of query parameters.
    func toQueryParams() -> [String: String] {
        var params: [String: String] = [:]
        
        if let name = name { params["name"] = name }
        if let nameExact = nameExact { params["nameExact"] = nameExact }
        if let country = country { params["country"] = country }
        if let countryExact = countryExact { params["countryExact"] = countryExact }
        if let countrycode = countrycode { params["countrycode"] = countrycode }
        if let state = state { params["state"] = state }
        if let stateExact = stateExact { params["stateExact"] = stateExact }
        if let language = language { params["language"] = language }
        if let languageExact = languageExact { params["languageExact"] = languageExact }
        if let tag = tag { params["tag"] = tag }
        if let tagExact = tagExact { params["tagExact"] = tagExact }
        if let codec = codec { params["codec"] = codec }
        if let bitrateMin = bitrateMin { params["bitrateMin"] = String(bitrateMin) }
        if let bitrateMax = bitrateMax { params["bitrateMax"] = String(bitrateMax) }
        if let isHTTPS = isHTTPS { params["is_https"] = isHTTPS ? "true" : "false" }
        if let hasGeoInfo = hasGeoInfo { params["has_geo_info"] = hasGeoInfo ? "true" : "false" }
        if let hasExtendedInfo = hasExtendedInfo { params["has_extended_info"] = hasExtendedInfo ? "true" : "false" }
        if let geoLat = geoLat { params["geo_lat"] = String(geoLat) }
        if let geoLong = geoLong { params["geo_long"] = String(geoLong) }
        if let geoDistance = geoDistance { params["geo_distance"] = String(geoDistance) }
        if let order = order { params["order"] = order.rawValue }
        if let reverse = reverse { params["reverse"] = reverse ? "true" : "false" }
        if let offset = offset { params["offset"] = String(offset) }
        if let limit = limit { params["limit"] = String(limit) }
        if let hidebroken = hidebroken { params["hidebroken"] = hidebroken ? "true" : "false" }
        
        return params
    }
    
    /// Convert query to POST JSON body (includes tagList support).
    /// - Returns: Dictionary suitable for JSON encoding.
    func toPostBody() -> [String: Any] {
        var body: [String: Any] = [:]
        
        if let name = name { body["name"] = name }
        if let nameExact = nameExact { body["nameExact"] = nameExact }
        if let country = country { body["country"] = country }
        if let countryExact = countryExact { body["countryExact"] = countryExact }
        if let countrycode = countrycode { body["countrycode"] = countrycode }
        if let state = state { body["state"] = state }
        if let stateExact = stateExact { body["stateExact"] = stateExact }
        if let language = language { body["language"] = language }
        if let languageExact = languageExact { body["languageExact"] = languageExact }
        if let tag = tag { body["tag"] = tag }
        if let tagExact = tagExact { body["tagExact"] = tagExact }
        if let tagList = tagList { body["tagList"] = tagList }
        if let codec = codec { body["codec"] = codec }
        if let bitrateMin = bitrateMin { body["bitrateMin"] = bitrateMin }
        if let bitrateMax = bitrateMax { body["bitrateMax"] = bitrateMax }
        if let isHTTPS = isHTTPS { body["is_https"] = isHTTPS }
        if let hasGeoInfo = hasGeoInfo { body["has_geo_info"] = hasGeoInfo }
        if let hasExtendedInfo = hasExtendedInfo { body["has_extended_info"] = hasExtendedInfo }
        if let geoLat = geoLat { body["geo_lat"] = geoLat }
        if let geoLong = geoLong { body["geo_long"] = geoLong }
        if let geoDistance = geoDistance { body["geo_distance"] = geoDistance }
        if let order = order { body["order"] = order.rawValue }
        if let reverse = reverse { body["reverse"] = reverse }
        if let offset = offset { body["offset"] = offset }
        if let limit = limit { body["limit"] = limit }
        if let hidebroken = hidebroken { body["hidebroken"] = hidebroken }
        
        return body
    }
}

// MARK: - Codable for POST requests

extension StationSearchQuery: Codable {
    enum CodingKeys: String, CodingKey {
        case name, nameExact
        case country, countryExact, countrycode
        case state, stateExact
        case language, languageExact
        case tag, tagExact, tagList
        case codec
        case bitrateMin, bitrateMax
        case isHTTPS = "is_https"
        case hasGeoInfo = "has_geo_info"
        case hasExtendedInfo = "has_extended_info"
        case geoLat = "geo_lat"
        case geoLong = "geo_long"
        case geoDistance = "geo_distance"
        case order, reverse, offset, limit, hidebroken
    }
}

