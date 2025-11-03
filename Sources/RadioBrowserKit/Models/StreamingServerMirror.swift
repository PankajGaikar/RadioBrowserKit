//
//  StreamingServerMirror.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A streaming server mirror for the Radio Browser API.
public struct StreamingServerMirror: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses the URL).
    public var id: String { url }
    /// Name of the mirror server.
    public let name: String
    
    /// URL of the mirror server.
    public let url: String
    
    /// IP address of the mirror.
    public let ip: String?
    
    /// Geographic location or region of the mirror.
    public let location: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case ip
        case location
    }
}

