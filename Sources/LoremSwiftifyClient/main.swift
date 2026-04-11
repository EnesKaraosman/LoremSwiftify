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

print("--- Book ---")
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
        let image: URL?

        @LoremSwiftify
        enum Capacity: Int {
            case one = 1
            case two = 2
            case three = 3
            case four = 4
        }
    }
}

print("\n--- Hotel ---")
print(Hotel.lorem())

// MARK: - New Features Showcase

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

    @Lorem(.string(.jobTitle))
    let jobTitle: String

    @Lorem(.string(.address))
    let address: String

    @Lorem(.string(.city))
    let city: String

    @Lorem(.string(.country))
    let country: String

    @Lorem(.string(.username))
    let username: String

    @Lorem(.int(.range(min: 18, max: 65)))
    let age: Int

    @Lorem(.double(.range(min: 30000.0, max: 150000.0)))
    let salary: Double

    @Lorem(.url(.avatar))
    let avatarURL: URL

    let tags: Set<String>
}

print("\n--- Employee ---")
let employee = Employee.lorem()
print("Name: \(employee.firstName) \(employee.lastName)")
print("Email: \(employee.email)")
print("Company: \(employee.company)")
print("Job: \(employee.jobTitle)")
print("Location: \(employee.address), \(employee.city), \(employee.country)")
print("Username: \(employee.username)")
print("Age: \(employee.age)")
print("Salary: \(String(format: "%.2f", employee.salary))")
print("Avatar: \(employee.avatarURL)")
print("Tags: \(employee.tags)")

@LoremSwiftify
struct Article {
    @Lorem(.string(.sentence))
    let title: String

    @Lorem(.string(.paragraph))
    let body: String

    let metadata: Data
}

print("\n--- Article ---")
let article = Article.lorem()
print("Title: \(article.title)")
print("Body: \(article.body.prefix(80))...")
print("Metadata size: \(article.metadata.count) bytes")

// MARK: - Batch Generation

print("\n--- Batch Generation (3 employees) ---")
let employees = Employee.lorem(count: 3)
for (i, emp) in employees.enumerated() {
    print("  [\(i + 1)] \(emp.firstName) \(emp.lastName) - \(emp.email)")
}

// MARK: - Deterministic Mode

print("\n--- Deterministic Mode ---")
let fixed1 = Employee.loremFixed()
let fixed2 = Employee.loremFixed()
print("Fixed #1: \(fixed1.firstName) \(fixed1.lastName), age \(fixed1.age), salary \(String(format: "%.2f", fixed1.salary))")
print("Fixed #2: \(fixed2.firstName) \(fixed2.lastName), age \(fixed2.age), salary \(String(format: "%.2f", fixed2.salary))")
print("Identical? \(fixed1.firstName == fixed2.firstName && fixed1.age == fixed2.age)")
