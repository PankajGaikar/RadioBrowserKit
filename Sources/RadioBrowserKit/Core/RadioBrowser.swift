//
//  RadioBrowser.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Main façade for the Radio Browser API client.
public actor RadioBrowser {
    /// The underlying HTTP client.
    private let client: HTTPClient
    
    /// Initialize a new RadioBrowser client.
    /// - Parameters:
    ///   - preferredMirror: Optional preferred mirror URL to use.
    ///   - timeoutInterval: Request timeout in seconds (default: 30).
    public init(preferredMirror: String? = nil, timeoutInterval: TimeInterval = 30.0) {
        self.client = HTTPClient(preferredMirror: preferredMirror, timeoutInterval: timeoutInterval)
    }
    
    // MARK: - List Endpoints
    
    /// Gets the list of countries.
    /// - Parameters:
    ///   - filter: Optional filter term.
    ///   - order: Sort order (default: name).
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    /// - Returns: Array of country names with station counts.
    public func countries(
        filter: String? = nil,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> [NamedCount] {
        let path = filter.map { "/json/countries/\($0)" } ?? "/json/countries"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit
        )
    }
    
    /// Gets the list of languages.
    /// - Parameters:
    ///   - filter: Optional filter term.
    ///   - order: Sort order (default: name).
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    /// - Returns: Array of language names with station counts.
    public func languages(
        filter: String? = nil,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> [NamedCount] {
        let path = filter.map { "/json/languages/\($0)" } ?? "/json/languages"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit
        )
    }
    
    /// Gets the list of tags.
    /// - Parameters:
    ///   - filter: Optional filter term.
    ///   - order: Sort order (default: name).
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    /// - Returns: Array of tag names with station counts.
    public func tags(
        filter: String? = nil,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> [NamedCount] {
        let path = filter.map { "/json/tags/\($0)" } ?? "/json/tags"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit
        )
    }
    
    /// Gets the list of states.
    /// - Parameters:
    ///   - country: Optional country filter.
    ///   - filter: Optional filter term.
    ///   - order: Sort order (default: name).
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    /// - Returns: Array of state names with station counts.
    public func states(
        country: String? = nil,
        filter: String? = nil,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> [StateCount] {
        var path = "/json/states"
        if let country = country {
            path += "/\(country)"
        }
        if let filter = filter {
            path += "/\(filter)"
        }
        
        var params: [String: String] = [:]
        if let country = country {
            params["country"] = country
        }
        
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            additionalParams: params
        )
    }
    
    /// Gets the list of codecs.
    /// - Parameters:
    ///   - filter: Optional filter term.
    ///   - order: Sort order (default: name).
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    /// - Returns: Array of codec names with station counts.
    public func codecs(
        filter: String? = nil,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> [NamedCount] {
        let path = filter.map { "/json/codecs/\($0)" } ?? "/json/codecs"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit
        )
    }
    
    // MARK: - Station Endpoints
    
    /// Gets all stations (use with caution - large response).
    /// - Parameters:
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of stations.
    public func stations(
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        return try await client.get(
            path: "/json/stations",
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by name.
    /// - Parameters:
    ///   - term: Search term.
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByName(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path = exact ? "/json/stations/bynameexact/\(term)" : "/json/stations/byname/\(term)"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by country.
    /// - Parameters:
    ///   - term: Country name or code.
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByCountry(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path: String
        if exact {
            path = "/json/stations/bycountryexact/\(term)"
        } else {
            path = "/json/stations/bycountry/\(term)"
        }
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by country code (ISO 3166-1 alpha-2).
    /// - Parameters:
    ///   - code: Two-letter country code (e.g., "US", "DE").
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByCountryCode(
        _ code: String,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        return try await client.get(
            path: "/json/stations/bycountrycodeexact/\(code)",
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by state.
    /// - Parameters:
    ///   - term: State name.
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByState(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path = exact ? "/json/stations/bystateexact/\(term)" : "/json/stations/bystate/\(term)"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by language.
    /// - Parameters:
    ///   - term: Language name.
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByLanguage(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path = exact ? "/json/stations/bylanguageexact/\(term)" : "/json/stations/bylanguage/\(term)"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by tag.
    /// - Parameters:
    ///   - term: Tag name.
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByTag(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path = exact ? "/json/stations/bytagexact/\(term)" : "/json/stations/bytag/\(term)"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by codec.
    /// - Parameters:
    ///   - term: Codec name (e.g., "MP3", "AAC").
    ///   - exact: Whether to match exactly.
    ///   - order: Sort order.
    ///   - reverse: Whether to reverse sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations (default: true).
    /// - Returns: Array of matching stations.
    public func stationsByCodec(
        _ term: String,
        exact: Bool = false,
        order: SortOrder = .name,
        reverse: Bool = false,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool = true
    ) async throws -> [Station] {
        let path = exact ? "/json/stations/bycodecexact/\(term)" : "/json/stations/bycodec/\(term)"
        return try await client.get(
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken
        )
    }
    
    /// Gets stations by UUIDs.
    /// - Parameters:
    ///   - uuids: Array of station UUIDs.
    /// - Returns: Array of matching stations.
    public func stationsByUUID(_ uuids: [String]) async throws -> [Station] {
        let uuidString = uuids.joined(separator: ",")
        return try await client.get(
            path: "/json/stations/byuuid",
            additionalParams: ["uuids": uuidString]
        )
    }
    
    /// Gets a station by exact URL match.
    /// - Parameters:
    ///   - url: The station URL to search for.
    /// - Returns: Array of matching stations (usually 0 or 1).
    public func stationsByURL(_ url: String) async throws -> [Station] {
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw RadioBrowserError.invalidRequest("Invalid URL encoding")
        }
        return try await client.get(
            path: "/json/stations/byurl",
            additionalParams: ["url": encodedURL]
        )
    }
    
    // MARK: - Ranking Endpoints
    
    /// Gets the top clicked stations.
    /// - Parameter count: Number of stations to return (default: 10).
    /// - Returns: Array of top clicked stations.
    public func topClick(_ count: Int = 10) async throws -> [Station] {
        let path = count > 0 ? "/json/stations/topclick/\(count)" : "/json/stations/topclick"
        return try await client.get(path: path)
    }
    
    /// Gets the top voted stations.
    /// - Parameter count: Number of stations to return (default: 10).
    /// - Returns: Array of top voted stations.
    public func topVote(_ count: Int = 10) async throws -> [Station] {
        let path = count > 0 ? "/json/stations/topvote/\(count)" : "/json/stations/topvote"
        return try await client.get(path: path)
    }
    
    /// Gets the most recently clicked stations.
    /// - Parameter count: Number of stations to return (default: 10).
    /// - Returns: Array of recently clicked stations.
    public func lastClick(_ count: Int = 10) async throws -> [Station] {
        let path = count > 0 ? "/json/stations/lastclick/\(count)" : "/json/stations/lastclick"
        return try await client.get(path: path)
    }
    
    /// Gets the most recently changed stations.
    /// - Parameter count: Number of stations to return (default: 10).
    /// - Returns: Array of recently changed stations.
    public func lastChange(_ count: Int = 10) async throws -> [Station] {
        let path = count > 0 ? "/json/stations/lastchange/\(count)" : "/json/stations/lastchange"
        return try await client.get(path: path)
    }
    
    /// Gets broken stations.
    /// - Parameter count: Number of stations to return (default: 10).
    /// - Returns: Array of broken stations.
    public func broken(_ count: Int = 10) async throws -> [Station] {
        let path = count > 0 ? "/json/stations/broken/\(count)" : "/json/stations/broken"
        return try await client.get(path: path)
    }
    
    // MARK: - Service Info Endpoints
    
    /// Gets server statistics.
    /// - Returns: Server statistics.
    public func stats() async throws -> ServerStats {
        return try await client.get(path: "/json/stats")
    }
    
    /// Gets available server mirrors.
    /// - Returns: Array of available server mirrors.
    public func servers() async throws -> [StreamingServerMirror] {
        return try await client.get(path: "/json/servers")
    }
    
    /// Gets server configuration.
    /// - Returns: Server configuration.
    public func config() async throws -> ServerConfig {
        return try await client.get(path: "/json/config")
    }
}
