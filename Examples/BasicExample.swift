//
//  BasicExample.swift
//  RadioBrowserKit Examples
//
//  Basic usage examples for RadioBrowserKit
//

import Foundation
import RadioBrowserKit

@main
struct BasicExample {
    static func main() async {
        let radioBrowser = RadioBrowser()
        
        do {
            // Example 1: Simple search
            print("=== Searching for Jazz Stations ===")
            let query = StationSearchQuery(name: "jazz", limit: 5)
            let stations = try await radioBrowser.search(query)
            
            for station in stations {
                print("- \(station.name) - \(station.countrycode ?? "Unknown")")
            }
            
            // Example 2: Get countries
            print("\n=== Top 10 Countries ===")
            let countries = try await radioBrowser.countries(limit: 10)
            for country in countries {
                print("- \(country.name): \(country.stationcount) stations")
            }
            
            // Example 3: Get top clicked stations
            print("\n=== Top 10 Clicked Stations ===")
            let topStations = try await radioBrowser.topClick(count: 10)
            for station in topStations {
                print("- \(station.name) (\(station.clickcount ?? 0) clicks)")
            }
            
            // Example 4: Get stations by country code
            print("\n=== US Stations ===")
            let usStations = try await radioBrowser.stationsByCountryCode("US", limit: 5)
            for station in usStations {
                print("- \(station.name)")
            }
            
        } catch RadioBrowserError.rateLimited {
            print("Rate limited - please wait before retrying")
        } catch RadioBrowserError.serverUnavailable {
            print("Server unavailable - trying different mirror...")
        } catch {
            print("Error: \(error)")
        }
    }
}

