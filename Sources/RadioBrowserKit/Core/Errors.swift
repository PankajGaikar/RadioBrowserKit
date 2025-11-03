//
//  Errors.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Errors that can occur when interacting with the Radio Browser API.
public enum RadioBrowserError: Error {
    /// Network transport error (e.g., connection timeout, DNS failure).
    case transport(Error)
    /// JSON decoding error.
    case decoding(Error)
    /// API returned an error response.
    case apiResponse(String)
    /// Rate limit exceeded.
    case rateLimited
    /// Invalid request parameters.
    case invalidRequest(String)
    /// Resource not found (404).
    case notFound
    /// Server unavailable or error (5xx).
    case serverUnavailable
}

