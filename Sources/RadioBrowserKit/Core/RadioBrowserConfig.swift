//
//  RadioBrowserConfig.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Configuration for RadioBrowserKit.
public struct RadioBrowserConfig: Sendable {
    /// Logging configuration.
    public var logging: LogConfiguration
    
    /// Initialize configuration with defaults.
    /// - Parameter logging: Logging configuration (default: .default).
    public init(logging: LogConfiguration = .default) {
        self.logging = logging
    }
}

/// Global configuration for RadioBrowserKit.
public enum RadioBrowserKit {
    /// Current configuration.
    private static let _lock = NSLock()
    private static var _config: RadioBrowserConfig = RadioBrowserConfig()
    
    /// Get or set the current configuration.
    public static var configuration: RadioBrowserConfig {
        get {
            _lock.lock()
            defer { _lock.unlock() }
            return _config
        }
        set {
            _lock.lock()
            defer { _lock.unlock() }
            _config = newValue
            RadioBrowserLogger.configuration = newValue.logging
        }
    }
    
    /// Set a custom logger.
    /// - Parameter logger: The logger to use.
    public static func setLogger(_ logger: LoggerProtocol) {
        RadioBrowserLogger.setLogger(logger)
    }
}

