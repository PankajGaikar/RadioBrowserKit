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
    
    // MARK: - Advanced Search
    
    /// Performs an advanced search for stations using multiple filters.
    /// - Parameters:
    ///   - query: The search query with filters.
    ///   - usePOST: Whether to use POST request (useful for long tagList arrays, default: false).
    /// - Returns: Array of matching stations.
    /// 
    /// Use POST when you have a large `tagList` array to avoid URL length limits.
    /// GET requests are generally preferred for simpler queries.
    public func search(
        _ query: StationSearchQuery,
        usePOST: Bool = false
    ) async throws -> [Station] {
        if usePOST || query.tagList != nil {
            // Use POST for tagList or when explicitly requested
            return try await client.post(path: "/json/stations/search", body: query)
        } else {
            // Use GET with query parameters
            return try await client.get(
                path: "/json/stations/search",
                order: query.order,
                reverse: query.reverse,
                offset: query.offset,
                limit: query.limit,
                hidebroken: query.hidebroken,
                additionalParams: query.toQueryParams()
            )
        }
    }
    
    // MARK: - Interactions (Write APIs)
    
    /// Records a click for a station (increments click count).
    /// 
    /// Rate limit: Once per day per IP address.
    /// 
    /// Note: The API returns the Station object with updated click information.
    /// This method converts it to ClickResponse format.
    /// - Parameter stationUUID: The UUID of the station.
    /// - Returns: Click response with resolved URL.
    public func click(stationUUID: String) async throws -> ClickResponse {
        // API returns Station array, extract first and convert to ClickResponse
        let stations: [Station] = try await client.get(path: "/json/url/\(stationUUID)")
        guard let station = stations.first else {
            throw RadioBrowserError.apiResponse("Empty response from click endpoint")
        }
        
        return ClickResponse(
            stationuuid: station.stationuuid,
            url: station.urlResolved ?? station.url,
            ok: station.lastcheckok ?? true,
            message: nil
        )
    }
    
    /// Records a vote for a station (increments vote count).
    /// 
    /// Rate limit: Once every 10 minutes per IP address.
    /// 
    /// Note: The API returns the Station object with updated vote information.
    /// This method converts it to VoteResponse format.
    /// - Parameter stationUUID: The UUID of the station.
    /// - Returns: Vote response with updated vote count.
    public func vote(stationUUID: String) async throws -> VoteResponse {
        // API returns Station array, extract first and convert to VoteResponse
        let stations: [Station] = try await client.get(path: "/json/vote/\(stationUUID)")
        guard let station = stations.first else {
            throw RadioBrowserError.apiResponse("Empty response from vote endpoint")
        }
        
        return VoteResponse(
            stationuuid: station.stationuuid,
            votes: station.votes ?? 0,
            ok: station.lastcheckok ?? true,
            message: nil
        )
    }
    
    /// Adds a new station to the Radio Browser database.
    /// 
    /// The request will be validated before sending:
    /// - `name` and `url` are required.
    /// - URLs will be validated and encoded.
    /// - Parameter request: The station information to add.
    /// - Returns: Response with the UUID of the newly created station.
    /// - Throws: `RadioBrowserError.invalidRequest` if validation fails.
    public func addStation(_ request: AddStationRequest) async throws -> AddStationResponse {
        // Validate request before sending
        try request.validate()
        
        // Validate URL format
        guard let url = URL(string: request.url), url.scheme != nil else {
            throw RadioBrowserError.invalidRequest("Invalid URL format: \(request.url)")
        }
        
        return try await client.post(path: "/json/add", body: request)
    }
    
    // MARK: - Diagnostics & History
    
    /// Gets click history records.
    /// - Parameters:
    ///   - stationUUID: Optional station UUID to filter clicks for a specific station. If nil, returns all clicks.
    ///   - seconds: Optional time window in seconds to limit clicks to recent period.
    ///   - lastClickUUID: Optional UUID of the last click received (for pagination). Used to fetch the next page of results.
    /// - Returns: Array of click records.
    /// 
    /// Use `lastClickUUID` for pagination: pass the UUID from the last item of the previous response to get the next page.
    public func clicks(
        stationUUID: String? = nil,
        seconds: Int? = nil,
        lastClickUUID: String? = nil
    ) async throws -> [StationClick] {
        var params: [String: String] = [:]
        
        if let stationUUID = stationUUID {
            params["stationuuid"] = stationUUID
        }
        if let seconds = seconds {
            params["seconds"] = String(seconds)
        }
        if let lastClickUUID = lastClickUUID {
            params["lastclickuuid"] = lastClickUUID
        }
        
        return try await client.get(
            path: "/json/clicks",
            additionalParams: params
        )
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
