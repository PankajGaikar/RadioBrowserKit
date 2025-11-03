//
//  VoteResponse.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Response from voting on a station.
public struct VoteResponse: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses stationuuid).
    public var id: String { stationuuid }
    /// UUID of the station that was voted on.
    public let stationuuid: String
    
    /// New vote count for the station.
    public let votes: Int
    
    /// Whether the operation was successful.
    public let ok: Bool
    
    /// Optional message.
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case stationuuid
        case votes
        case ok
        case message
    }
    
    /// Initialize a VoteResponse.
    public init(stationuuid: String, votes: Int, ok: Bool, message: String? = nil) {
        self.stationuuid = stationuuid
        self.votes = votes
        self.ok = ok
        self.message = message
    }
}

