//
//  ServerConfig.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Server configuration information.
public struct ServerConfig: Codable, Sendable {
    /// Check interval for stations (in seconds).
    public let checkInterval: Int?
    
    /// Click interval (minimum time between clicks, in seconds).
    public let clickInterval: Int?
    
    /// Vote interval (minimum time between votes, in seconds).
    public let voteInterval: Int?
    
    /// Number of threads used for checking.
    public let checkThreads: Int?
    
    /// Whether to check stations.
    public let checkEnabled: Bool?
    
    enum CodingKeys: String, CodingKey {
        case checkInterval = "check_interval"
        case clickInterval = "click_interval"
        case voteInterval = "vote_interval"
        case checkThreads = "check_threads"
        case checkEnabled = "check_enabled"
    }
}

