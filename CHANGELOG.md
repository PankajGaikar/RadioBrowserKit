# Changelog

All notable changes to RadioBrowserKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-11-03

### Added
- Initial release of RadioBrowserKit
- Full API coverage for Radio Browser API
- Swift Concurrency support (async/await)
- Type-safe models with Codable conformance
- SwiftUI support (all models are Identifiable)
- Automatic mirror selection with fallback
- Structured logging with Unified Logging support
- Comprehensive error handling
- Unit tests with fixtures
- Live integration tests
- Documentation (README, DocC)
- Example code

### Features
- **List Endpoints**: countries, languages, tags, states, codecs
- **Station Endpoints**: search by name, country, language, tag, UUID, URL
- **Ranking Endpoints**: top click, top vote, last click, last change, broken
- **Advanced Search**: Multi-criteria search with StationSearchQuery
- **Interactions**: click, vote, add station
- **Diagnostics**: clicks history, stats, servers, config

### Platform Support
- iOS 15.0+
- macOS 12.0+
- watchOS 8.0+
- tvOS 15.0+

[Unreleased]: https://github.com/yourusername/RadioBrowserKit/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/RadioBrowserKit/releases/tag/v1.0.0

