# Getting Started

Get started with RadioBrowserKit in your Swift project.

## Installation

### Swift Package Manager

Add RadioBrowserKit to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/RadioBrowserKit.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Packages...
2. Enter the repository URL
3. Select the version

## First Steps

### Import the Module

```swift
import RadioBrowserKit
```

### Create a Client

```swift
let radioBrowser = RadioBrowser()
```

### Make Your First Request

```swift
// Search for stations
let query = StationSearchQuery(name: "jazz", limit: 10)
let stations = try await radioBrowser.search(query)

for station in stations {
    print("\(station.name) - \(station.url)")
}
```

## Next Steps

- Learn about <doc:BasicUsage>
- Explore the <doc:RadioBrowserKit> API reference

