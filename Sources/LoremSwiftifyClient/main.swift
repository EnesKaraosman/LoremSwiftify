import Foundation
import LoremSwiftify

@LoremSwiftify
struct Person {
    let name: String
    let surname: String
    var title: String = "DefaultTitle"
    let age: Int
    var isAdult = true
}

@LoremSwiftify
struct Book {
    let name: String
    let published: Date
    let author: Author

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
}

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

print(Person.lorem())
print(Author.lorem())
print(Book.lorem())
print(User.lorem())
