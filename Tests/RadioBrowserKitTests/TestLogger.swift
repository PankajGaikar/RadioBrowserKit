//
//  TestLogger.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import Foundation
@testable import RadioBrowserKit

/// Test logger that captures log messages for verification.
public final class TestLogger: LoggerProtocol, @unchecked Sendable {
    /// Captured log entries.
    public private(set) var logs: [LogEntry] = []
    
    /// Lock for thread-safety.
    private let lock = NSLock()
    
    /// A log entry.
    public struct LogEntry: Sendable {
        public let level: LogLevel
        public let category: LogCategory
        public let message: String
        public let timestamp: Date
    }
    
    public init() {}
    
    public func log(_ level: LogLevel, _ category: LogCategory, _ message: @autoclosure () -> String) {
        lock.lock()
        defer { lock.unlock() }
        
        logs.append(LogEntry(
            level: level,
            category: category,
            message: message(),
            timestamp: Date()
        ))
    }
    
    /// Clear all captured logs.
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        logs.removeAll()
    }
    
    /// Get logs for a specific category.
    public func logs(for category: LogCategory) -> [LogEntry] {
        lock.lock()
        defer { lock.unlock() }
        return logs.filter { $0.category == category }
    }
    
    /// Get logs at or above a specific level.
    public func logs(atOrAbove level: LogLevel) -> [LogEntry] {
        lock.lock()
        defer { lock.unlock() }
        return logs.filter { $0.level >= level }
    }
}

