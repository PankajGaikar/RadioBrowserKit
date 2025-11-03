//
//  ErrorHandlingTests.swift
//  RadioBrowserKitTests
//
//  Created as part of RadioBrowserKit.
//

import XCTest
@testable import RadioBrowserKit

final class ErrorHandlingTests: XCTestCase {
    
    func testAddStationRequestValidation() {
        // Empty name
        let request1 = AddStationRequest(name: "", url: "http://example.com")
        XCTAssertThrowsError(try request1.validate()) { error in
            if case RadioBrowserError.invalidRequest(let message) = error {
                XCTAssertTrue(message.contains("name"))
            } else {
                XCTFail("Expected invalidRequest error")
            }
        }
        
        // Empty URL
        let request2 = AddStationRequest(name: "Test Station", url: "")
        XCTAssertThrowsError(try request2.validate()) { error in
            if case RadioBrowserError.invalidRequest(let message) = error {
                XCTAssertTrue(message.contains("URL"))
            } else {
                XCTFail("Expected invalidRequest error")
            }
        }
        
        // Valid request
        let request3 = AddStationRequest(name: "Test Station", url: "http://example.com")
        XCTAssertNoThrow(try request3.validate())
    }
    
    func testRadioBrowserErrorTypes() {
        let transportError = NSError(domain: "Test", code: -1)
        let error1 = RadioBrowserError.transport(transportError)
        
        if case .transport(let error) = error1 {
            XCTAssertEqual((error as NSError).code, -1)
        } else {
            XCTFail("Expected transport error")
        }
        
        let error2 = RadioBrowserError.notFound
        if case .notFound = error2 {
            // Correct
        } else {
            XCTFail("Expected notFound error")
        }
        
        let error3 = RadioBrowserError.rateLimited
        if case .rateLimited = error3 {
            // Correct
        } else {
            XCTFail("Expected rateLimited error")
        }
        
        let error4 = RadioBrowserError.invalidRequest("Test message")
        if case .invalidRequest(let message) = error4 {
            XCTAssertEqual(message, "Test message")
        } else {
            XCTFail("Expected invalidRequest error")
        }
    }
}

