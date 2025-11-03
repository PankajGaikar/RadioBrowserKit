# RadioBrowserKit

A modern, production-ready Swift Package for interacting with the [Radio Browser API](https://www.radio-browser.info/). Built with Swift Concurrency (async/await) and fully typed with Codable models.

## Features

- ✅ **Full API Coverage** - All read and write endpoints
- ✅ **Swift Concurrency** - Built with async/await for modern Swift
- ✅ **Type-Safe** - Fully typed models with Codable
- ✅ **SwiftUI Ready** - All models conform to Identifiable
- ✅ **Platform Support** - iOS 15+, macOS 12+, watchOS 8+, tvOS 15+
- ✅ **Automatic Mirror Selection** - Handles API mirror discovery and failover
- ✅ **Structured Logging** - Configurable logging with Unified Logging support
- ✅ **Comprehensive Testing** - Unit tests with fixtures + live integration tests
- ✅ **Production Ready** - Error handling, rate limiting, timeouts

## Installation

### Swift Package Manager

Add RadioBrowserKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/RadioBrowserKit.git", from: "1.0.0")
]
```

Or add it in Xcode:
1. File → Add Packages...
2. Enter the repository URL
3. Select the version you want to use

## Quick Start

### Basic Usage

```swift
import RadioBrowserKit

// Create a client
let radioBrowser = RadioBrowser()

// Search for stations
let stations = try await radioBrowser.search(
    StationSearchQuery(name: "jazz", limit: 10)
)

// Get countries
let countries = try await radioBrowser.countries()

// Get top stations
let topStations = try await radioBrowser.topClick(count: 20)
```

### Search Examples

```swift
let radioBrowser = RadioBrowser()

// Simple search by name
let query = StationSearchQuery(name: "BBC", limit: 10)
let stations = try await radioBrowser.search(query)

// Advanced search with multiple filters
let advancedQuery = StationSearchQuery(
    name: "jazz",
    countrycode: "US",
    language: "english",
    codec: "MP3",
    bitrateMin: 128,
    hidebroken: true,
    limit: 50,
    order: .votes,
    reverse: true
)
let jazzStations = try await radioBrowser.search(advancedQuery)

// Search with tag list (uses POST automatically when tagList is present)
let tagQuery = StationSearchQuery(
    tagList: ["jazz", "smooth", "instrumental"],
    limit: 20
)
let taggedStations = try await radioBrowser.search(tagQuery)
```

### Station Interactions

```swift
let radioBrowser = RadioBrowser()

// Get a station
let stations = try await radioBrowser.stationsByUUID("960e29ac-0601-11e8-ae97-52543be04c81")
guard let station = stations.first else { return }

// Record a click (rate limit: once per day per IP)
do {
    let clickResponse = try await radioBrowser.click(stationUUID: station.stationuuid)
    print("Click recorded: \(clickResponse.url)")
} catch RadioBrowserError.rateLimited {
    print("Rate limited - try again tomorrow")
}

// Vote for a station (rate limit: once every 10 minutes per IP)
do {
    let voteResponse = try await radioBrowser.vote(stationUUID: station.stationuuid)
    print("Vote count: \(voteResponse.votes)")
} catch RadioBrowserError.rateLimited {
    print("Rate limited - wait 10 minutes")
}
```

### Lists and Rankings

```swift
let radioBrowser = RadioBrowser()

// Get lists
let countries = try await radioBrowser.countries(limit: 10)
let languages = try await radioBrowser.languages(filter: "english")
let tags = try await radioBrowser.tags(order: .stationcount, reverse: true)

// Get stations by criteria
let usStations = try await radioBrowser.stationsByCountryCode("US", limit: 50)
let jazzStations = try await radioBrowser.stationsByTag("jazz", limit: 20)
let germanStations = try await radioBrowser.stationsByLanguage("german", limit: 30)

// Rankings
let topClicked = try await radioBrowser.topClick(count: 50)
let topVoted = try await radioBrowser.topVote(count: 50)
```

### SwiftUI Example

```swift
import SwiftUI
import RadioBrowserKit

struct StationListView: View {
    @State private var stations: [Station] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    let radioBrowser = RadioBrowser()
    
    var body: some View {
        List(stations) { station in
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.headline)
                Text(station.countrycode ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            await loadStations()
        }
    }
    
    func loadStations() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let query = StationSearchQuery(name: "jazz", limit: 20)
            stations = try await radioBrowser.search(query)
        } catch {
            self.error = error
        }
    }
}
```

## API Overview

### Main Client

- `RadioBrowser` - Main actor for interacting with the API

### List Endpoints

- `countries()` - Get list of countries with station counts
- `languages()` - Get list of languages with station counts
- `tags()` - Get list of tags with station counts
- `states()` - Get list of states/regions with station counts
- `codecs()` - Get list of codecs with station counts

### Station Endpoints

- `stations()` - Get all stations (use with caution)
- `stationsByName(_:exact:...)` - Search stations by name
- `stationsByCountry(_:exact:...)` - Get stations by country name
- `stationsByCountryCode(_:...)` - Get stations by country code
- `stationsByLanguage(_:exact:...)` - Get stations by language
- `stationsByTag(_:exact:...)` - Get stations by tag
- `stationsByUUID(_:)` - Get station by UUID
- `stationsByURL(_:)` - Get station by URL

### Ranking Endpoints

- `topClick(_:)` - Get top clicked stations
- `topVote(_:)` - Get top voted stations
- `lastClick(_:)` - Get recently clicked stations
- `lastChange(_:)` - Get recently changed stations
- `broken(_:)` - Get broken stations

### Advanced Search

- `search(_:usePOST:)` - Advanced search with multiple filters using `StationSearchQuery`

### Interactions (Write APIs)

- `click(stationUUID:)` - Record a click (rate limit: once per day)
- `vote(stationUUID:)` - Record a vote (rate limit: once per 10 minutes)
- `addStation(_:)` - Add a new station to the database

### Diagnostics & History

- `clicks(stationUUID:seconds:lastClickUUID:)` - Get click history
- `stats()` - Get server statistics
- `servers()` - Get available server mirrors
- `config()` - Get server configuration

## Configuration

### Logging

```swift
import RadioBrowserKit

// Configure logging
RadioBrowserKit.configuration.logging = LogConfiguration(
    level: .debug,
    redactPII: false,
    emitCURL: true
)

// Use custom logger
let customLogger = MyCustomLogger()
RadioBrowserKit.setLogger(customLogger)
```

### Mirror Selection

```swift
// Use a preferred mirror
let radioBrowser = RadioBrowser(preferredMirror: "https://at1.api.radio-browser.info")

// Or let it auto-discover (default behavior)
let radioBrowser = RadioBrowser()
```

## Error Handling

RadioBrowserKit provides structured error handling:

```swift
import RadioBrowserKit

do {
    let stations = try await radioBrowser.search(query)
} catch RadioBrowserError.notFound {
    print("Resource not found")
} catch RadioBrowserError.rateLimited {
    print("Rate limited - wait before retrying")
} catch RadioBrowserError.serverUnavailable {
    print("Server unavailable - will retry with different mirror")
} catch RadioBrowserError.invalidRequest(let message) {
    print("Invalid request: \(message)")
} catch RadioBrowserError.decoding(let error) {
    print("Decoding error: \(error)")
} catch RadioBrowserError.transport(let error) {
    print("Network error: \(error)")
} catch RadioBrowserError.apiResponse(let message) {
    print("API error: \(message)")
} catch {
    print("Unknown error: \(error)")
}
```

## Testing

### Unit Tests

Run unit tests (fast, no network required):
```bash
swift test
```

### Integration Tests

Run integration tests against live API (requires network):
```bash
RB_LIVE_TESTS=1 swift test
```

## Requirements

- Swift 5.9+
- iOS 15.0+ / macOS 12.0+ / watchOS 8.0+ / tvOS 15.0+
- Xcode 15.0+ (for building)

## License

[Add your license here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built for the [Radio Browser](https://www.radio-browser.info/) API
- Inspired by the community's need for a modern Swift wrapper

