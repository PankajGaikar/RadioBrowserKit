//
//  StreamingServerMirror.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A streaming server mirror for the Radio Browser API.
public struct StreamingServerMirror: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses URL or name).
    public var id: String { url ?? name }
    
    /// Name of the mirror server.
    public let name: String
    
    /// URL of the mirror server (may be in different field names).
    public let url: String?
    
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        // Try URL field first
        url = try container.decodeIfPresent(String.self, forKey: .url)
        
        ip = try container.decodeIfPresent(String.self, forKey: .ip)
        location = try container.decodeIfPresent(String.self, forKey: .location)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(ip, forKey: .ip)
        try container.encodeIfPresent(location, forKey: .location)
    }
}

