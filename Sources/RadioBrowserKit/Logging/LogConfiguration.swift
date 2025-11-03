//
//  LogConfiguration.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Configuration for logging behavior.
public struct LogConfiguration: Sendable {
    /// Categories that are enabled for logging.
    public var enabled: Set<LogCategory>
    
    /// Minimum log level to emit (only logs at or above this level are emitted).
    public var minLevel: LogLevel
    
    /// Whether to redact potentially sensitive information (PII).
    public var redactPII: Bool
    
    /// Whether to emit cURL commands in debug logs.
    public var emitCURL: Bool
    
    /// Default logging configuration.
    public static let `default` = LogConfiguration(
        enabled: [.network, .mirrors, .api],
        minLevel: .info,
        redactPII: true,
        emitCURL: false
    )
    
    /// Initialize a logging configuration.
    /// - Parameters:
    ///   - enabled: Categories that are enabled (default: network, mirrors, api).
    ///   - minLevel: Minimum log level (default: .info).
    ///   - redactPII: Whether to redact PII (default: true).
    ///   - emitCURL: Whether to emit cURL commands (default: false).
    public init(
        enabled: Set<LogCategory> = [.network, .mirrors, .api],
        minLevel: LogLevel = .info,
        redactPII: Bool = true,
        emitCURL: Bool = false
    ) {
        self.enabled = enabled
        self.minLevel = minLevel
        self.redactPII = redactPII
        self.emitCURL = emitCURL
    }
}

