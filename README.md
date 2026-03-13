# Rick & Morty

## How to Run

1. Open `Rick and Morty.xcodeproj`
2. Select any iOS 16+ simulator or device.
3. Hit **Run** (⌘R).
4. To run tests: ⌘U.

---

## Architecture

**MVVM** separates the application into three distinct layers:

- **Model** — Data (e.g. `Character`)
- **ViewModel** — Transforms model data for the view, handles state and user actions
- **View** — Renders UI and forwards user interactions to the ViewModel

### Reasoning

- **Separation of Concerns**: Keeps views free of business and presentation logic, making each layer easier to reason about.
- **Testability**: ViewModels can be tested independently without any UI dependencies.
- **Scalability**: Loosely coupled components make it straightforward to add features without affecting unrelated layers.
---

## Dependency Injection

Every dependency is injected via **constructor injection**:

```
AppContainer
  └── ConsoleLogger              → injected into NetworkClient
  └── URLSessionNetworkClient    → injected into CharacterRepository
  └── CharacterRepository        → injected into Use Cases
  └── Use Cases                  → injected into ViewModels (via factory methods)
```

There are **no singletons** for core dependencies. `AppContainer` itself is created once at the app level and passed down via factory methods.

---

## Testing

### ViewModel Tests (`CharacterListViewModelTests`)
| # | What | Why |
|---|------|-----|
| 1 | Successful load → `.loaded` state + correct character count | Core happy path |
| 2 | Filter change resets to page 1 | Pagination correctness requirement |
| 3 | Network error → `.error` state | Error handling |
| 4 | Empty result → `.empty` state | No-results path |

### Network / Decoding Tests (`NetworkClientTests`)
| # | What | Why |
|---|------|-----|
| 5 | Valid JSON decodes directly into `Character` | Serialisation correctness |
| 6 | Invalid JSON throws `DecodingError` | Failure handling |

All tests use **mock objects** (`MockFetchCharactersUseCase`, `MockNetworkClient`)

---

## Observability & Security

- **Logging**: `LoggerProtocol` + `ConsoleLogger` — Log level (`debug/info/warning/error`) is included on every message.
- **Transport Security**: NSAppTransportSecurity — all requests use HTTPS.
- **No third-party libraries**: Zero external dependencies; fully auditable.

---

## What I'd Add Next

- **Episode detail screen**: Currently shows episode count; a dedicated fetch + details view would be a nice touch.
- **Snapshot tests**: Add ViewInspector or SwiftUI snapshot tests for visual regression coverage.
- **Offline support**: Cache last successful page to disk (`Codable` + `FileManager`) and show stale data with a banner.
- **Accessibility**: Add `accessibilityLabel` and `accessibilityValue` to the status badge and row cells.
- **Localisation**: Externalise all user-facing strings into `Localizable.strings`.
