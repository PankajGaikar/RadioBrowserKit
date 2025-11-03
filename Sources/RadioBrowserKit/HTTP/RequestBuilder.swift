//
//  RequestBuilder.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Sorting order options.
public enum SortOrder: String, Codable, Sendable {
    case name
    case url
    case homepage
    case favicon
    case tags
    case country
    case state
    case language
    case votes
    case codec
    case bitrate
    case lastcheckok
    case lastchecktime
    case clickcount
    case clicktrend
    case random
}

/// Builder for constructing Radio Browser API requests with common query parameters.
internal struct RequestBuilder {
    /// Builds a URL request with common query parameters.
    /// - Parameters:
    ///   - baseURL: The base URL of the API.
    ///   - path: The API endpoint path.
    ///   - order: Optional sort order.
    ///   - reverse: Whether to reverse the sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations.
    ///   - additionalParams: Additional query parameters.
    /// - Returns: A configured URL request.
    static func build(
        baseURL: String,
        path: String,
        order: SortOrder? = nil,
        reverse: Bool? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool? = nil,
        additionalParams: [String: String] = [:]
    ) throws -> URLRequest {
        guard let baseURL = URL(string: baseURL) else {
            throw RadioBrowserError.invalidRequest("Invalid base URL")
        }
        
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        var queryItems: [URLQueryItem] = []
        
        if let order = order {
            queryItems.append(URLQueryItem(name: "order", value: order.rawValue))
        }
        
        if let reverse = reverse {
            queryItems.append(URLQueryItem(name: "reverse", value: reverse ? "true" : "false"))
        }
        
        if let offset = offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        if let hidebroken = hidebroken {
            queryItems.append(URLQueryItem(name: "hidebroken", value: hidebroken ? "true" : "false"))
        }
        
        // Add additional parameters
        for (key, value) in additionalParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw RadioBrowserError.invalidRequest("Failed to construct URL")
        }
        
        var request = URLRequest(url: url)
        request.setValue("RadioBrowserKit/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
