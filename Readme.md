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
- [ ] Improve diagnostic
- [ ] Implement unit test

---

- Annotate any struct, class or enum with `@LoremSwiftify`

Then use `StructName.lorem()` or `ClassName.lorem()` or `EnumName.lorem()`. Basically `.lorem()` everywhere :)


```swift
import LoremSwiftify

@LoremSwiftify
class Book {
    let name: String
    let published: Date
    let author: Author

    init(name: String, published: Date, author: Author) {
        self.name = name
        self.published = published
        self.author = author
    }

    @LoremSwiftify
    class Author {
        let name: String
        let surname: String
        var nickName: String?
        let age: Int

        init(_ name: String, surname: String, nickName: String? = nil, age: Int) {
            self.name = name
            self.surname = surname
            self.nickName = nickName
            self.age = age
        }
    }
    // Expands
    extension Book.Author: LoremIpsumize {
        public static func lorem() -> Self {
            Book.Author(
                _: .lorem(),
                surname: .lorem(),
                nickName: nil,
                age: .lorem()
            ) as! Self
        }
    }
}
// Expands
extension Book: LoremIpsumize {
    public static func lorem() -> Self {
        Book(
            name: .lorem(),
            published: .lorem(),
            author: .lorem()
        ) as! Self
    }
}

print(Book.lorem())

@LoremSwiftify
struct Hotel {
    @Lorem(.string(.name))
    let name: String

    @Lorem(.string(.phoneNumber))
    let phoneNumber: String

    @Lorem(.url(.website))
    let website: URL

    let rooms: [Room]

    @LoremSwiftify
    struct Room {
        let id: UUID
        let capacity: Capacity

        @Lorem(.url(.image))
        let image: URL

        @LoremSwiftify
        enum Capacity: Int {
            case one = 1
            case two = 2
            case three = 3
            case four = 4
        }
        // Expands
        extension Hotel.Room.Capacity: LoremIpsumize {
            public static func lorem() -> Self {
                Hotel.Room.Capacity.one
            }
        }
    }
    // Expands
    extension Hotel.Room: LoremIpsumize {
        public static func lorem() -> Self {
            Hotel.Room(
                id: .lorem(),
                capacity: .lorem(),
                image: .lorem(.url(.image))
            )
        }
    }
}
// Expands
extension Hotel: LoremIpsumize {
    public static func lorem() -> Self {
        Hotel(
            name: .lorem(.string(.name)),
            phoneNumber: .lorem(.string(.phoneNumber)),
            website: .lorem(.url(.website)),
            rooms: .lorem()
        )
    }
}

print(Hotel.lorem())
```
