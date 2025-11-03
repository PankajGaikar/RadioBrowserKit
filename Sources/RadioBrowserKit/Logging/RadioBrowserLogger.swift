//
//  RadioBrowserLogger.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Global logger for RadioBrowserKit.
public enum RadioBrowserLogger {
    /// The shared logger instance.
    private static let _lock = NSLock()
    private static var _shared: LoggerProtocol = OSLogger()
    
    /// Current logging configuration.
    public static var configuration: LogConfiguration = .default
    
    /// The shared logger instance.
    public static var shared: LoggerProtocol {
        get {
            _lock.lock()
            defer { _lock.unlock() }
            return _shared
        }
        set {
            _lock.lock()
            defer { _lock.unlock() }
            _shared = newValue
        }
    }
    
    /// Set a custom logger implementation.
    /// - Parameter logger: The logger to use.
    public static func setLogger(_ logger: LoggerProtocol) {
        shared = logger
    }
    
    /// Log a message (internal helper that checks configuration).
    internal static func log(
        _ level: LogLevel,
        _ category: LogCategory,
        _ message: @autoclosure () -> String
    ) {
        // Check if category is enabled and level is sufficient
        guard configuration.enabled.contains(category),
              level >= configuration.minLevel else {
            return
        }
        
        shared.log(level, category, message())
    }
}

