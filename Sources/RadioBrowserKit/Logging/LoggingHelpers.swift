//
//  LoggingHelpers.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

internal enum LoggingHelpers {
    /// Generate a cURL command string from a URLRequest (with header redaction).
    static func cURLCommand(from request: URLRequest, redactHeaders: Bool = true) -> String {
        var components: [String] = ["curl"]
        
        // Method
        if let method = request.httpMethod, method != "GET" {
            components.append("-X \(method)")
        }
        
        // Headers (with redaction)
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers.sorted(by: { $0.key < $1.key }) {
                let redactedValue = (redactHeaders && shouldRedactHeader(key)) ? "[REDACTED]" : value
                components.append("-H '\(key): \(redactedValue)'")
            }
        }
        
        // Body
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            components.append("-d '\(bodyString)'")
        }
        
        // URL
        if let url = request.url {
            components.append("'\(url.absoluteString)'")
        }
        
        return components.joined(separator: " \\\n  ")
    }
    
    /// Check if a header should be redacted.
    private static func shouldRedactHeader(_ header: String) -> Bool {
        let lowercased = header.lowercased()
        return lowercased == "authorization" || lowercased == "cookie"
    }
    
    /// Redact or hash sensitive query parameters.
    static func redactQuery(_ query: String, redactPII: Bool) -> String {
        guard redactPII else { return query }
        
        // Simple approach: if query contains coordinates or sensitive terms, hash them
        // In a production system, you might want more sophisticated redaction
        if query.contains("geo_lat") || query.contains("geo_long") {
            return "[REDACTED]"
        }
        return query
    }
    
    /// Truncate geographic coordinates to 2 decimal places if redaction is enabled.
    static func truncateGeo(_ value: Double?, redactPII: Bool) -> String {
        guard let value = value else { return "nil" }
        if redactPII {
            return String(format: "%.2f", value)
        }
        return String(value)
    }
}

