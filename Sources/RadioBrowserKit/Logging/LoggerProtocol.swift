//
//  LoggerProtocol.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Protocol for loggers that can handle log messages.
public protocol LoggerProtocol: Sendable {
    /// Log a message at a specific level and category.
    /// - Parameters:
    ///   - level: The log level.
    ///   - category: The log category.
    ///   - message: The message to log (evaluated lazily via autoclosure).
    func log(_ level: LogLevel, _ category: LogCategory, _ message: @autoclosure () -> String)
}

