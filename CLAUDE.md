# CLAUDE.md

## Project Overview

LoremSwiftify is a Swift macro library that generates mock/lorem ipsum data for Swift types (struct, class, enum).

## Build & Test

```bash
swift build    # Build all targets
swift test     # Run macro expansion tests
swift run LoremSwiftifyClient  # Run example client
```

## Architecture

- **LoremSwiftify** (library target) — Public API: macros, `LoremIpsumize` protocol, type extensions
- **LoremSwiftifyMacros** (macro target) — Compiler plugin: macro expansion logic using SwiftSyntax
- **LoremSwiftifyClient** (executable) — Example demonstrating library usage
- **LoremSwiftifyTests** (test target) — Macro expansion tests using SwiftSyntaxMacrosTestSupport

## Key Conventions

- Type extensions for `LoremIpsumize` go in `Sources/LoremSwiftify/LoremIpsumize+Extensions.swift`
- `@Lorem` customization kinds go in `Sources/LoremSwiftify/LoremKind.swift`
- Macro type handlers go in `Sources/LoremSwiftifyMacros/SupportedTypes/`
- Diagnostics go in `Sources/LoremSwiftifyMacros/Diagnostic.swift`
- Tests use `assertMacro()` helper from `Tests/LoremSwiftifyTests/TestUtils/MacroTestCase.swift`

## Dependencies

- **swift-syntax** (603.0.0+) — SwiftSyntax for macro implementation
- **Fakery** (5.1.0+) — Fake data generation (names, emails, addresses, etc.)

## Platforms

macOS 12+, iOS 13+, tvOS 13+, watchOS 6+, macCatalyst 13+
