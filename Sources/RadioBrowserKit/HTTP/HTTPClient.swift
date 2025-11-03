//
//  HTTPClient.swift
//  RadioBrowserKit
//
//  Created as part of RadioBrowserKit.
//

import Foundation

/// HTTP client for making requests to the Radio Browser API.
internal actor HTTPClient {
    /// The URLSession used for making requests.
    private let session: URLSession
    
    /// The mirror selector for managing API endpoints.
    private let mirrorSelector: MirrorSelector
    
    /// Configuration for request timeout (default: 30 seconds).
    private let timeoutInterval: TimeInterval
    
    /// Initialize an HTTP client.
    /// - Parameters:
    ///   - preferredMirror: Optional preferred mirror URL.
    ///   - timeoutInterval: Request timeout in seconds (default: 30).
    init(preferredMirror: String? = nil, timeoutInterval: TimeInterval = 30.0) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval * 2
        
        self.session = URLSession(configuration: configuration)
        self.mirrorSelector = MirrorSelector(preferredMirror: preferredMirror)
        self.timeoutInterval = timeoutInterval
    }
    
    /// Performs a GET request and decodes the response.
    /// - Parameters:
    ///   - path: The API endpoint path.
    ///   - order: Optional sort order.
    ///   - reverse: Whether to reverse the sort order.
    ///   - offset: Pagination offset.
    ///   - limit: Pagination limit.
    ///   - hidebroken: Whether to hide broken stations.
    ///   - additionalParams: Additional query parameters.
    /// - Returns: Decoded response of type T.
    func get<T: Decodable>(
        path: String,
        order: SortOrder? = nil,
        reverse: Bool? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        hidebroken: Bool? = nil,
        additionalParams: [String: String] = [:]
    ) async throws -> T {
        let baseURL = try await mirrorSelector.getBaseURL()
        var request = try RequestBuilder.build(
            baseURL: baseURL,
            path: path,
            order: order,
            reverse: reverse,
            offset: offset,
            limit: limit,
            hidebroken: hidebroken,
            additionalParams: additionalParams
        )
        
        request.httpMethod = "GET"
        
        return try await perform(request: request)
    }
    
    /// Performs a POST request with JSON body.
    /// - Parameters:
    ///   - path: The API endpoint path.
    ///   - body: The request body to encode as JSON.
    /// - Returns: Decoded response of type T.
    func post<T: Decodable, B: Encodable>(
        path: String,
        body: B
    ) async throws -> T {
        let baseURL = try await mirrorSelector.getBaseURL()
        guard let baseURLObj = URL(string: baseURL) else {
            throw RadioBrowserError.invalidRequest("Invalid base URL")
        }
        
        let url = baseURLObj.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("RadioBrowserKit/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw RadioBrowserError.invalidRequest("Failed to encode request body: \(error.localizedDescription)")
        }
        
        return try await perform(request: request)
    }
    
    /// Performs a URL request and handles the response.
    /// - Parameter request: The URL request to perform.
    /// - Returns: Decoded response of type T.
    private func perform<T: Decodable>(request: URLRequest) async throws -> T {
        let requestID = UUID().uuidString.prefix(8)
        let startTime = Date()
        let method = request.httpMethod ?? "GET"
        let path = request.url?.path ?? "unknown"
        let baseURL = try await mirrorSelector.getBaseURL()
        
        // Log request start
        var requestMsg = "➡️ [\(requestID)] \(method) \(path) on mirror=\(baseURL)"
        if let query = request.url?.query {
            let redacted = LoggingHelpers.redactQuery(query, redactPII: RadioBrowserLogger.configuration.redactPII)
            requestMsg += "?\(redacted)"
        }
        RadioBrowserLogger.log(.debug, .network, requestMsg)
        
        // Log cURL if enabled
        if RadioBrowserLogger.configuration.emitCURL {
            let curlCmd = LoggingHelpers.cURLCommand(from: request, redactHeaders: true)
            RadioBrowserLogger.log(.debug, .network, curlCmd)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            let elapsed = Date().timeIntervalSince(startTime)
            let latencyMs = Int(elapsed * 1000)
            let dataSizeKB = Double(data.count) / 1024.0
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RadioBrowserError.transport(NSError(domain: "RadioBrowserKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"]))
            }
            
            // Handle HTTP status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success - decode the response
                RadioBrowserLogger.log(.info, .network, "✅ [\(requestID)] \(httpResponse.statusCode) in \(latencyMs)ms bytes=\(String(format: "%.1f", dataSizeKB))KB")
                
                do {
                    let decoder = JSONDecoder()
                    // Handle Unix timestamp decoding if needed
                    decoder.dateDecodingStrategy = .secondsSince1970
                    return try decoder.decode(T.self, from: data)
                } catch {
                    RadioBrowserLogger.log(.error, .decode, "❌ [\(requestID)] Decoding error: \(error.localizedDescription)")
                    throw RadioBrowserError.decoding(error)
                }
                
            case 404:
                RadioBrowserLogger.log(.warn, .network, "⚠️ [\(requestID)] \(httpResponse.statusCode) in \(latencyMs)ms: Not Found")
                throw RadioBrowserError.notFound
                
            case 429:
                RadioBrowserLogger.log(.warn, .network, "⚠️ [\(requestID)] \(httpResponse.statusCode) in \(latencyMs)ms: Rate Limited")
                throw RadioBrowserError.rateLimited
                
            case 500...599:
                // Try to reset mirror on server errors
                RadioBrowserLogger.log(.error, .network, "❌ [\(requestID)] \(httpResponse.statusCode) in \(latencyMs)ms: Server Error")
                await mirrorSelector.reset()
                throw RadioBrowserError.serverUnavailable
                
            default:
                // Try to decode error message if available
                let errorMessage = String(data: data, encoding: .utf8) ?? "HTTP \(httpResponse.statusCode)"
                RadioBrowserLogger.log(.error, .network, "❌ [\(requestID)] \(httpResponse.statusCode) in \(latencyMs)ms: \(errorMessage)")
                throw RadioBrowserError.apiResponse(errorMessage)
            }
        } catch let error as RadioBrowserError {
            let elapsed = Date().timeIntervalSince(startTime)
            let latencyMs = Int(elapsed * 1000)
            RadioBrowserLogger.log(.error, .network, "❌ [\(requestID)] Error in \(latencyMs)ms: \(error)")
            throw error
        } catch {
            // Network errors
            let elapsed = Date().timeIntervalSince(startTime)
            let latencyMs = Int(elapsed * 1000)
            RadioBrowserLogger.log(.error, .network, "❌ [\(requestID)] Transport error in \(latencyMs)ms: \(error.localizedDescription)")
            throw RadioBrowserError.transport(error)
        }
    }
}
