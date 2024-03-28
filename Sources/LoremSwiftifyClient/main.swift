import Foundation
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
}

print(Book.lorem())

@LoremSwiftify
struct Hotel {
    @Lorem(.string(.name))
    let name: String

    @Lorem(.string(.phoneNumber))
    let phoneNumber: String

    let rooms: [Room]

    @LoremSwiftify
    struct Room {
        let id: UUID
        let capacity: Capacity

        @LoremSwiftify
        enum Capacity: Int {
            case one = 1
            case two = 2
            case three = 3
            case four = 4
        }
    }
}

print(Hotel.lorem())
