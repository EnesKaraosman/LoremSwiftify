# LoremSwiftify

> This package is created to challange Swift Macros and it's under development. So currently support types are limited

### Todos
- [X] Support class
- [X] Support struct
- [ ] Support nested structs
- [ ] Support nested classes
- [ ] Support more foundation types
- [X] Custom types supported if it's annotated with macro or confirms `LoremIpsumize` protocol
- [ ] Improve diagnostic
- [ ] Implement unit test

---

- Annotate struct with `@LoremSwiftify`

If there's no defined init, macro uses default init. Also macro does not override the fields that has default value

```swift
import LoremSwiftify

@LoremSwiftify
struct Person {
    let name: String
    let surname: String
    var title: String = "DefaultTitle"
    let age: Int
    var isAdult = true
}

// Expands;
extension Person: LoremIpsumize {
    static func lorem() -> Self {
        return Person(
            name: "Jamie",
            surname: "Grady",
            title: "DefaultTitle",
            age: 56,
            isAdult: true
        )
    }
}
```

- Custom struct

```swift
@LoremSwiftify
struct Author {
    let name: String
    let surname: String
    var nickName: String?
    let age: Int

    init(name: String, surname: String, nickName: String? = nil, age: Int) {
        self.name = name
        self.surname = surname
        self.nickName = nickName
        self.age = age
    }
}

@LoremSwiftify
struct Book {
    let name: String
    let published: Date
    let author: Author
}

// Expands
extension Author: LoremIpsumize {
    static func lorem() -> Self {
        return Author(
            name: String.lorem(),
            surname: String.lorem(),
            nickName: nil,
            age: Int.lorem()
        )
    }
}

extension Book: LoremIpsumize {
    static func lorem() -> Self {
        return Book(
            name: String.lorem(),
            published: Date.lorem(),
            author: Author.lorem()
        )
    }
}
```

- inits used if exist

```swift
@LoremSwiftify
struct User {
    let name: String
    let surname: String
    let age: Int
    let isAdult: Bool

    init(name: String, surname: String, age: Int, isAdult: Bool) {
        self.name = name
        self.surname = surname
        self.age = age
        self.isAdult = isAdult
    }
}

// Expands
extension User: LoremIpsumize {
    static func lorem() -> Self {
        return User(
            name: "Lorie",
            surname: "Agnes",
            age: 9,
            isAdult: true
        )
    }
}
```
