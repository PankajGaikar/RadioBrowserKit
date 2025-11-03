//
//  OSLogger.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation
#if canImport(os)
import os
#endif

/// Logger implementation using Apple's Unified Logging (os.Logger).
public struct OSLogger: LoggerProtocol, Sendable {
    #if canImport(os)
    private let subsystem: String
    
    public init(subsystem: String = "com.radiobrowserkit.RadioBrowserKit") {
        self.subsystem = subsystem
    }
    #else
    public init(subsystem: String = "com.radiobrowserkit.RadioBrowserKit") {
        // Fallback for non-Apple platforms
    }
    #endif
    
    public func log(_ level: LogLevel, _ category: LogCategory, _ message: @autoclosure () -> String) {
        #if canImport(os)
        let categoryLogger = os.Logger(subsystem: subsystem, category: category.rawValue)
        let logMessage = message()
        
        switch level {
        case .trace, .debug:
            categoryLogger.debug("\(logMessage)")
        case .info:
            categoryLogger.info("\(logMessage)")
        case .notice:
            categoryLogger.notice("\(logMessage)")
        case .warn:
            categoryLogger.warning("\(logMessage)")
        case .error:
            categoryLogger.error("\(logMessage)")
        }
        #else
        // Fallback to print for non-Apple platforms
        print("[\(level)] [\(category.rawValue)] \(message())")
        #endif
    }
}

