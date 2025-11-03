# RadioBrowserKit

A modern, production-ready Swift Package for interacting with the Radio Browser API.

## Overview

RadioBrowserKit provides a type-safe, async/await-based interface to the Radio Browser API, making it easy to search for internet radio stations, get station metadata, and interact with the API from your Swift applications.

## Topics

### Getting Started

- <doc:GettingStarted>
- <doc:BasicUsage>

### Core Concepts

- ``RadioBrowser``
- ``Station``
- ``StationSearchQuery``

### API Categories

#### Lists
- ``RadioBrowser/countries()``
- ``RadioBrowser/languages()``
- ``RadioBrowser/tags()``
- ``RadioBrowser/states(country:filter:order:reverse:offset:limit:)``
- ``RadioBrowser/codecs()``

#### Stations
- ``RadioBrowser/stations(order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByName(_:exact:order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByCountry(_:exact:order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByCountryCode(_:order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByLanguage(_:exact:order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByTag(_:exact:order:reverse:offset:limit:hidebroken:)``
- ``RadioBrowser/stationsByUUID(_:)``
- ``RadioBrowser/stationsByURL(_:)``

#### Rankings
- ``RadioBrowser/topClick(_:)``
- ``RadioBrowser/topVote(_:)``
- ``RadioBrowser/lastClick(_:)``
- ``RadioBrowser/lastChange(_:)``
- ``RadioBrowser/broken(_:)``

#### Advanced Search
- ``RadioBrowser/search(_:usePOST:)``
- ``StationSearchQuery``

#### Interactions
- ``RadioBrowser/click(stationUUID:)``
- ``RadioBrowser/vote(stationUUID:)``
- ``RadioBrowser/addStation(_:)``

#### Diagnostics
- ``RadioBrowser/clicks(stationUUID:seconds:lastClickUUID:)``
- ``RadioBrowser/stats()``
- ``RadioBrowser/servers()``
- ``RadioBrowser/config()``

### Models

- ``Station``
- ``NamedCount``
- ``StateCount``
- ``ServerStats``
- ``ServerConfig``
- ``StreamingServerMirror``
- ``StationClick``
- ``ClickResponse``
- ``VoteResponse``
- ``AddStationRequest``
- ``AddStationResponse``
- ``StationSearchQuery``

### Error Handling

- ``RadioBrowserError``

### Configuration

- ``RadioBrowserKit``
- ``RadioBrowserConfig``
- ``LogConfiguration``

