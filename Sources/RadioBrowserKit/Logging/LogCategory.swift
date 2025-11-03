//
//  LogCategory.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Logging categories for different components.
public enum LogCategory: String, Hashable, Sendable {
    case network = "Network"
    case mirrors = "Mirrors"
    case decode = "Decode"
    case api = "API"
    case general = "General"
}

