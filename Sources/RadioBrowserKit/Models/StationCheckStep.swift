//
//  StationCheckStep.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// A single step in a station check process.
public struct StationCheckStep: Codable, Sendable, Identifiable {
    /// Unique identifier for SwiftUI (uses the step name).
    public var id: String { name }
    /// Name or description of the check step.
    public let name: String
    
    /// Whether this step passed.
    public let ok: Bool
    
    /// Optional message or details about the step.
    public let message: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case ok
        case message
    }
}

