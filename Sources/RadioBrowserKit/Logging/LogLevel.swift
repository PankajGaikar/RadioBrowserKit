//
//  LogLevel.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Log levels in order of severity.
public enum LogLevel: Int, Comparable, Sendable {
    case trace = 0
    case debug = 1
    case info = 2
    case notice = 3
    case warn = 4
    case error = 5
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

