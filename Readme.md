# LoremSwiftify

### Features
- [X] Support class (nesting is supported as well)
- [X] Support struct (nesting is supported as well)
- [X] Support enum (nesting is supported as well)
- [X] Support commonly used types
    - [X] String
    - [X] Int, Int8, Int16, Int32, Int64
    - [X] UInt, UInt8, UInt16, UInt32, UInt64
    - [X] Double, Float
    - [X] Bool
    - [X] Array
    - [X] Dictionary
    - [X] Optional
    - [X] Date
    - [X] URL
    - [X] Color
- [X] Custom types supported if it's annotated with macro or confirms `LoremIpsumize` protocol
- [ ] Add #if DEBUG
- [X] Create Example SwiftUI project to demonstrate package usage for previews
- [X] Provide a way to customize lorem in different categories (like creditCard, phoneNumber, name, price etc..) (works for auto generated init)
- [ ] Provide a way to customize loreming for the supported built-in types (to completely determine what to receive for the lorem data)
- [ ] Implement unit test

---

See example project

[Example](Example/Example)

---

- Annotate any struct, class or enum with `@LoremSwiftify`

Then use `StructName.lorem()` or `ClassName.lorem()` or `EnumName.lorem()`. Basically `.lorem()` everywhere :)


```swift
extension ContentView {
    @LoremSwiftify
    struct Display {
        let developers: [Developer]

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
    }
}

#Preview {
    ContentView(display: .lorem())
}
```
