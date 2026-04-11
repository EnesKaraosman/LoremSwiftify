# LoremSwiftify

A Swift macro that automatically generates mock/lorem ipsum data for your types. Annotate any `struct`, `class`, or `enum` with `@LoremSwiftify` and get a `lorem()` static method for free.

## Installation

Add LoremSwiftify as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/EnesKaraosman/LoremSwiftify", from: "0.1.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["LoremSwiftify"]
)
```

## Usage

Annotate any struct, class, or enum with `@LoremSwiftify`, then call `.lorem()` to get mock data:

```swift
@LoremSwiftify
struct Developer: Identifiable {
    let id: String = UUID().uuidString

    @Lorem(.string(.name))
    let name: String

    @Lorem(.string(.email))
    let email: String

    @Lorem(.string(.phoneNumber))
    let phoneNumber: String

    @Lorem(.url(.image))
    let imageURL: URL

    @Lorem(.url(.website))
    let profileURL: URL
}

// Use in SwiftUI previews
#Preview {
    DeveloperView(developer: .lorem())
}
```

## Features

- [X] Support class (nesting is supported as well)
- [X] Support struct (nesting is supported as well)
- [X] Support enum (nesting is supported as well)
- [X] Custom types supported if annotated with macro or conforms to `LoremIpsumize` protocol
- [X] Create Example SwiftUI project to demonstrate package usage for previews
- [X] Customize lorem with `@Lorem` for different categories
- [X] Comprehensive unit tests
- [X] Add `#if DEBUG` support — generated `lorem()` is wrapped in `#if DEBUG`
- [X] Access control matching — generated `lorem()` matches the type's access level
- [X] Batch generation — `.lorem(count: N)` to generate arrays of mock data
- [X] Deterministic mode — `.loremFixed()` for snapshot tests and stable previews

## Supported Types

| Type | Default Behavior |
|------|-----------------|
| `String` | Random lorem ipsum word |
| `Int` | Random integer |
| `Int8`, `Int16`, `Int32`, `Int64` | Random value in type range |
| `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64` | Random value in type range |
| `Double` | Random double |
| `Float` | Random float |
| `Bool` | Random boolean |
| `Date` | Current date |
| `UUID` | New UUID |
| `URL` | Placeholder image URL |
| `Color` | Random RGB color |
| `Character` | Random alphanumeric character |
| `Data` | Random bytes (16-256 length) |
| `CGFloat` | Random value 0-1000 |
| `CGPoint` | Random point |
| `CGSize` | Random size |
| `CGRect` | Random rect |
| `Array<T>` | 2-10 random elements |
| `Set<T>` | 2-10 random elements |
| `Dictionary<K, V>` | 2-10 random key-value pairs |
| `Optional<T>` | Randomly `.some` or `.none` |

## `@Lorem` Customization

Use the `@Lorem` attribute on properties to control the generated data:

### String Categories

**Name & Contact**
```swift
@Lorem(.string(.name))            // Full name
@Lorem(.string(.firstName))       // First name
@Lorem(.string(.lastName))        // Last name
@Lorem(.string(.namePrefix))      // Mr., Mrs., etc.
@Lorem(.string(.nameSuffix))      // Jr., Sr., PhD, etc.
@Lorem(.string(.email))           // Email address
@Lorem(.string(.phoneNumber))     // Phone number
@Lorem(.string(.cellPhone))       // Cell phone number
```

**Address & Location**
```swift
@Lorem(.string(.address))            // Street address
@Lorem(.string(.city))               // City name
@Lorem(.string(.state))              // State name
@Lorem(.string(.stateAbbreviation))  // State abbreviation (CA, NY)
@Lorem(.string(.zipCode))            // Postal code
@Lorem(.string(.country))            // Country name
@Lorem(.string(.countryCode))        // Country code (US, GB)
@Lorem(.string(.county))             // County name
@Lorem(.string(.timeZone))           // Time zone
@Lorem(.string(.latitude))           // Latitude as string
@Lorem(.string(.longitude))          // Longitude as string
```

**Business & Commerce**
```swift
@Lorem(.string(.company))         // Company name
@Lorem(.string(.companySuffix))   // Inc., LLC, etc.
@Lorem(.string(.catchPhrase))     // Company catch phrase
@Lorem(.string(.jobTitle))        // Job title
@Lorem(.string(.creditCard))      // Credit card number
@Lorem(.string(.creditCardType))  // Visa, MasterCard, etc.
@Lorem(.string(.productName))     // Product name
@Lorem(.string(.department))      // Department name
@Lorem(.string(.colorName))       // Color name
```

**Internet**
```swift
@Lorem(.string(.username))      // Username
@Lorem(.string(.password))      // Password
@Lorem(.string(.domainName))    // Domain name
@Lorem(.string(.domainSuffix))  // .com, .org, etc.
@Lorem(.string(.ipV4Address))   // IPv4 address
@Lorem(.string(.ipV6Address))   // IPv6 address
@Lorem(.string(.hashtag))       // Hashtag
@Lorem(.string(.hexColor))      // Hex color (#A1B2C3)
```

**Text**
```swift
@Lorem(.string(.paragraph))   // Full paragraph
@Lorem(.string(.sentence))    // Single sentence
@Lorem(.string(.words))       // Multiple words
```

**Banking**
```swift
@Lorem(.string(.bankName))   // Bank name
@Lorem(.string(.iban))       // IBAN number
@Lorem(.string(.swiftBic))   // SWIFT/BIC code
```

**Misc**
```swift
@Lorem(.string(.appName))              // App name
@Lorem(.string(.appVersion))           // App version
@Lorem(.string(.gender))               // Gender
@Lorem(.string(.carBrand))             // Car brand
@Lorem(.string(.programmingLanguage))  // Programming language
```

### URL Categories

```swift
@Lorem(.url(.image))        // Placeholder image (picsum.photos)
@Lorem(.url(.website))      // Random website URL
@Lorem(.url(.avatar))       // Avatar image (robohash)
@Lorem(.url(.companyLogo))  // Company logo URL
```

### Numeric

```swift
@Lorem(.int(.range(min: 18, max: 65)))          // Int in range
@Lorem(.double(.range(min: 0.0, max: 100.0)))   // Double in range
@Lorem(.double(.price))                          // Random product price
```

## Full Example

```swift
@LoremSwiftify
struct Employee {
    @Lorem(.string(.firstName))
    let firstName: String

    @Lorem(.string(.lastName))
    let lastName: String

    @Lorem(.string(.email))
    let email: String

    @Lorem(.string(.company))
    let company: String

    @Lorem(.int(.range(min: 18, max: 65)))
    let age: Int

    @Lorem(.double(.range(min: 30000.0, max: 150000.0)))
    let salary: Double

    @Lorem(.url(.avatar))
    let avatarURL: URL

    let tags: Set<String>
}

let employee = Employee.lorem()
// Employee with realistic fake data!
```

## Batch Generation

Generate multiple mock instances at once — perfect for SwiftUI `List` previews:

```swift
let employees = Employee.lorem(count: 10)

#Preview {
    List(employees, id: \.username) { emp in
        Text("\(emp.firstName) \(emp.lastName)")
    }
}
```

## Deterministic Mode

Use `.loremFixed()` for snapshot tests and stable previews — always returns the same data:

```swift
// Always identical
let user1 = Employee.loremFixed()
let user2 = Employee.loremFixed()
// user1.firstName == user2.firstName  ✓

// Batch fixed data
let fixedList = Employee.loremFixed(count: 5)
```

| Type | `.loremFixed()` value |
|------|----------------------|
| `String` | `"Lorem ipsum"` |
| `Int` / `Int8-64` / `UInt` / `UInt8-64` | `42` |
| `Double` / `Float` | `3.14` |
| `Bool` | `true` |
| `Date` | `1970-01-01 00:00:00 UTC` |
| `UUID` | `00000000-0000-0000-0000-000000000000` |
| `URL` | `https://example.com` |
| `Optional<T>` | `.some(T.loremFixed())` |
| `Array<T>` / `Set<T>` | Single element |
| `Dictionary<K,V>` | Single key-value pair |

See the [Example project](Example/Example) for a SwiftUI demo.

## License

MIT License - see [LICENSE](LICENSE) for details.
