# Basic Usage

Learn how to use RadioBrowserKit in common scenarios.

## Search for Stations

```swift
let radioBrowser = RadioBrowser()

// Simple search
let query = StationSearchQuery(name: "BBC", limit: 10)
let stations = try await radioBrowser.search(query)

// Advanced search with filters
let advancedQuery = StationSearchQuery(
    name: "jazz",
    countrycode: "US",
    language: "english",
    codec: "MP3",
    bitrateMin: 128,
    hidebroken: true,
    limit: 50
)
let stations = try await radioBrowser.search(advancedQuery)
```

## Get Lists

```swift
let radioBrowser = RadioBrowser()

// Get countries
let countries = try await radioBrowser.countries(limit: 10)

// Get languages
let languages = try await radioBrowser.languages()

// Get tags
let tags = try await radioBrowser.tags(order: .stationcount, reverse: true)
```

## Get Stations by Criteria

```swift
let radioBrowser = RadioBrowser()

// By country code
let usStations = try await radioBrowser.stationsByCountryCode("US", limit: 50)

// By tag
let jazzStations = try await radioBrowser.stationsByTag("jazz", limit: 20)

// By language
let germanStations = try await radioBrowser.stationsByLanguage("german", limit: 30)
```

## Handle Errors

```swift
do {
    let stations = try await radioBrowser.search(query)
} catch RadioBrowserError.rateLimited {
    print("Rate limited - wait before retrying")
} catch RadioBrowserError.notFound {
    print("Not found")
} catch {
    print("Error: \(error)")
}
```

