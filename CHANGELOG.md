# Changelog

## [1.0.1] - 2026-04-11

### Improvements
- Add CI, Swift version, platforms, and license badges to README
- Fix installation version in README
- Add `.spi.yml` for Swift Package Index compatibility
- Add bug report and feature request issue templates
- Add pull request template
- Update repo description and topics for discoverability
- Enable GitHub Discussions

## [1.0.0] - 2026-04-11

### Breaking Changes
- `Optional` conformance is now conditional (`where Wrapped: LoremIpsumize`) and randomly returns `.some` or `.none` instead of always `.none`
- `Int8`, `Int16`, `Int32`, `Int64` now return random values instead of `.max`
- `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64` now return random values instead of `.max`
- Generated `lorem()` is now wrapped in `#if DEBUG` — requires debug builds
- Generated `lorem()` access level now matches the type's access level (was always `public`)
- Test directory renamed from `LoremSwiftsumizeTests` to `LoremSwiftifyTests`

### New Features
- **Deterministic mode**: `.loremFixed()` returns the same predictable data every time — ideal for snapshot tests and stable previews
- **Batch generation**: `.lorem(count: N)` and `.loremFixed(count: N)` generate arrays of mock instances
- **50+ `@Lorem` string categories** covering name, contact, address, business, internet, text, banking, commerce, app, and more
- **Numeric ranges**: `@Lorem(.int(.range(min:max:)))` and `@Lorem(.double(.range(min:max:))))`
- **Price generation**: `@Lorem(.double(.price))` for realistic product prices
- **URL categories**: `.avatar` (robohash) and `.companyLogo`

### New Type Support
- `Set<T>` (2-10 random elements)
- `CGFloat`, `CGPoint`, `CGSize`, `CGRect`
- `Data` (random bytes)
- `Character`

### Improvements
- Simplified `@Lorem` attribute parsing — now supports complex expressions like `.int(.range(min: 0, max: 100))`
- Added `CLAUDE.md` with project guidelines
- Comprehensive README rewrite with full API documentation

### Tests
- Added 26 macro expansion tests (from 0) across 6 test files
- Fixed test infrastructure: macro registration keys, `MacroSpec` with conformances
