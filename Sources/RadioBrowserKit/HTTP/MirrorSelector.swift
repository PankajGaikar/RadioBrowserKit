//
//  MirrorSelector.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// Selects and manages Radio Browser API mirrors with fallback support.
internal actor MirrorSelector {
    /// The fallback base URL for discovering mirrors.
    static let fallbackBaseURL = "https://all.api.radio-browser.info"
    
    /// The currently selected mirror base URL.
    private var currentMirror: String?
    
    /// The preferred mirror URL (if set by user).
    private let preferredMirror: String?
    
    /// Whether we've attempted to discover mirrors.
    private var hasDiscoveredMirrors = false
    
    /// Initialize a mirror selector.
    /// - Parameter preferredMirror: Optional preferred mirror URL to use.
    init(preferredMirror: String? = nil) {
        self.preferredMirror = preferredMirror
        
        // Check for environment variable override (for tests)
        if let envOverride = ProcessInfo.processInfo.environment["RADIO_BROWSER_BASE_URL"] {
            self.currentMirror = envOverride
            self.hasDiscoveredMirrors = true
        } else if let preferredMirror = preferredMirror {
            self.currentMirror = preferredMirror
            self.hasDiscoveredMirrors = true
        }
    }
    
    /// Gets the current mirror URL, discovering one if necessary.
    /// - Returns: The base URL of the selected mirror.
    func getBaseURL() async throws -> String {
        // Use preferred mirror or env override if available
        if let mirror = currentMirror {
            return mirror
        }
        
        // Discover mirrors if not already done
        if !hasDiscoveredMirrors {
            try await discoverMirror()
            hasDiscoveredMirrors = true
        }
        
        guard let mirror = currentMirror else {
            throw RadioBrowserError.serverUnavailable
        }
        
        return mirror
    }
    
    /// Discovers an available mirror by querying the servers endpoint.
    private func discoverMirror() async throws {
        let serversURL = URL(string: "\(Self.fallbackBaseURL)/json/servers")!
        
        let (data, response) = try await URLSession.shared.data(from: serversURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // If discovery fails, fall back to the default
            currentMirror = Self.fallbackBaseURL
            return
        }
        
        do {
            let mirrors = try JSONDecoder().decode([StreamingServerMirror].self, from: data)
            
            // Pick a random mirror if available
            if let randomMirror = mirrors.randomElement() {
                currentMirror = randomMirror.url
            } else {
                // Fall back to default if no mirrors found
                currentMirror = Self.fallbackBaseURL
            }
        } catch {
            // If decoding fails, fall back to default
            currentMirror = Self.fallbackBaseURL
        }
    }
    
    /// Forces re-discovery of mirrors (useful for retry scenarios).
    func reset() {
        hasDiscoveredMirrors = false
        if preferredMirror == nil && ProcessInfo.processInfo.environment["RADIO_BROWSER_BASE_URL"] == nil {
            currentMirror = nil
        }
    }
}
