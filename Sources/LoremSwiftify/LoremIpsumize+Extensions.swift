//
//  LoremIpsumize+Extensions.swift
//
//
//  Created by Enes Karaosman on 25.03.2024.
//

import CoreGraphics
import Fakery
import Foundation
import SwiftUI

private let faker = Faker()

public protocol LoremIpsumize {
    static func lorem() -> Self

    static func lorem(_ kind: LoremKind?) -> Self

    /// Returns a deterministic, predictable mock value. Always returns the same data
    /// for the same type, making it ideal for snapshot tests and stable previews.
    static func loremFixed() -> Self
}

extension LoremIpsumize {
    public static func lorem(_ kind: LoremKind? = nil) -> Self {
        lorem()
    }

    /// Generate an array of `count` random mock instances.
    public static func lorem(count: Int) -> [Self] {
        (0..<count).map { _ in lorem() }
    }

    /// Generate an array of `count` deterministic mock instances.
    /// All elements are identical since `loremFixed()` is deterministic.
    public static func loremFixed(count: Int) -> [Self] {
        (0..<count).map { _ in loremFixed() }
    }

    #if !DEBUG
    public static func lorem() -> Self {
        fatalError("lorem() is only available in DEBUG builds")
    }

    public static func loremFixed() -> Self {
        fatalError("loremFixed() is only available in DEBUG builds")
    }
    #endif
}

extension Optional: LoremIpsumize where Wrapped: LoremIpsumize {
    public static func lorem() -> Optional<Wrapped> {
        Bool.random() ? .some(Wrapped.lorem()) : .none
    }

    public static func loremFixed() -> Optional<Wrapped> {
        .some(Wrapped.loremFixed())
    }
}

extension Dictionary: LoremIpsumize where Key: LoremIpsumize, Value: LoremIpsumize {
    public static func lorem() -> Dictionary<Key, Value> {
        let count = Int.random(in: 2...10)

        return (0..<count).reduce(into: [:]) { result, _ in
            result[Key.lorem()] = Value.lorem()
        }
    }

    public static func loremFixed() -> Dictionary<Key, Value> {
        [Key.loremFixed(): Value.loremFixed()]
    }
}

extension Array: LoremIpsumize where Element: LoremIpsumize {
    public static func lorem() -> Array<Element> {
        let count = Int.random(in: 2...10)

        return (1...count).indices.map { _ in
            Element.lorem()
        }
    }

    public static func loremFixed() -> Array<Element> {
        [Element.loremFixed()]
    }
}

extension UUID: LoremIpsumize {
    public static func lorem() -> UUID {
        UUID()
    }

    public static func loremFixed() -> UUID {
        UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    }
}

extension String: LoremIpsumize {
    public static func lorem(_ kind: LoremKind?) -> String {
        switch kind {
        // Name
        case .string(.name): faker.name.name()
        case .string(.firstName): faker.name.firstName()
        case .string(.lastName): faker.name.lastName()
        case .string(.namePrefix): faker.name.prefix()
        case .string(.nameSuffix): faker.name.suffix()
        // Contact
        case .string(.email): faker.internet.email()
        case .string(.phoneNumber): faker.phoneNumber.phoneNumber()
        case .string(.cellPhone): faker.phoneNumber.cellPhone()
        // Address
        case .string(.address): faker.address.streetAddress()
        case .string(.city): faker.address.city()
        case .string(.state): faker.address.state()
        case .string(.stateAbbreviation): faker.address.stateAbbreviation()
        case .string(.zipCode): faker.address.postcode()
        case .string(.country): faker.address.country()
        case .string(.countryCode): faker.address.countryCode()
        case .string(.county): faker.address.county()
        case .string(.timeZone): faker.address.timeZone()
        case .string(.latitude): "\(faker.address.latitude())"
        case .string(.longitude): "\(faker.address.longitude())"
        // Business
        case .string(.company): faker.company.name()
        case .string(.companySuffix): faker.company.suffix()
        case .string(.catchPhrase): faker.company.catchPhrase()
        case .string(.jobTitle): faker.name.title()
        case .string(.creditCard): faker.business.creditCardNumber()
        case .string(.creditCardType): faker.business.creditCardType()
        // Internet
        case .string(.username): faker.internet.username()
        case .string(.password): faker.internet.password()
        case .string(.domainName): faker.internet.domainName()
        case .string(.domainSuffix): faker.internet.domainSuffix()
        case .string(.ipV4Address): faker.internet.ipV4Address()
        case .string(.ipV6Address): faker.internet.ipV6Address()
        case .string(.hashtag): faker.internet.hashtag()
        case .string(.hexColor): Color.randomHexColor()
        // Text
        case .string(.paragraph): faker.lorem.paragraph()
        case .string(.sentence): faker.lorem.sentence()
        case .string(.words): faker.lorem.words()
        // Banking
        case .string(.bankName): faker.bank.name()
        case .string(.iban): faker.bank.iban()
        case .string(.swiftBic): faker.bank.swiftBic()
        // Commerce
        case .string(.productName): faker.commerce.productName()
        case .string(.department): faker.commerce.department()
        case .string(.colorName): faker.commerce.color()
        // App
        case .string(.appName): faker.app.name()
        case .string(.appVersion): faker.app.version()
        // Misc
        case .string(.gender): faker.gender.type()
        case .string(.carBrand): faker.car.brand()
        case .string(.programmingLanguage): faker.programmingLanguage.name()
        default:
            lorem()
        }
    }

    public static func lorem() -> String {
        faker.lorem.word()
    }

    public static func loremFixed() -> String {
        "Lorem ipsum"
    }
}

// MARK: - Int Extensions

extension Int: LoremIpsumize {
    public static func lorem(_ kind: LoremKind?) -> Int {
        switch kind {
        case .int(.range(let min, let max)):
            Int.random(in: min...max)
        default:
            lorem()
        }
    }

    public static func lorem() -> Int {
        faker.number.randomInt()
    }

    public static func loremFixed() -> Int { 42 }
}

extension Int8: LoremIpsumize {
    public static func lorem() -> Int8 {
        Int8.random(in: Int8.min...Int8.max)
    }
    public static func loremFixed() -> Int8 { 42 }
}

extension Int16: LoremIpsumize {
    public static func lorem() -> Int16 {
        Int16.random(in: Int16.min...Int16.max)
    }
    public static func loremFixed() -> Int16 { 42 }
}

extension Int32: LoremIpsumize {
    public static func lorem() -> Int32 {
        Int32.random(in: Int32.min...Int32.max)
    }
    public static func loremFixed() -> Int32 { 42 }
}

extension Int64: LoremIpsumize {
    public static func lorem() -> Int64 {
        Int64.random(in: Int64.min...Int64.max)
    }
    public static func loremFixed() -> Int64 { 42 }
}

// -------------------------

// MARK: - UInt Extensions

extension UInt: LoremIpsumize {
    public static func lorem() -> UInt {
        UInt.random(in: 0...UInt(Int.max))
    }
    public static func loremFixed() -> UInt { 42 }
}

extension UInt8: LoremIpsumize {
    public static func lorem() -> UInt8 {
        UInt8.random(in: 0...UInt8.max)
    }
    public static func loremFixed() -> UInt8 { 42 }
}

extension UInt16: LoremIpsumize {
    public static func lorem() -> UInt16 {
        UInt16.random(in: 0...UInt16.max)
    }
    public static func loremFixed() -> UInt16 { 42 }
}

extension UInt32: LoremIpsumize {
    public static func lorem() -> UInt32 {
        UInt32.random(in: 0...UInt32.max)
    }
    public static func loremFixed() -> UInt32 { 42 }
}

extension UInt64: LoremIpsumize {
    public static func lorem() -> UInt64 {
        UInt64.random(in: 0...UInt64(Int64.max))
    }
    public static func loremFixed() -> UInt64 { 42 }
}

// -------------------------

extension Double: LoremIpsumize {
    public static func lorem(_ kind: LoremKind?) -> Double {
        switch kind {
        case .double(.range(let min, let max)):
            Double.random(in: min...max)
        case .double(.price):
            faker.commerce.price()
        default:
            lorem()
        }
    }

    public static func lorem() -> Double {
        faker.number.randomDouble()
    }

    public static func loremFixed() -> Double { 3.14 }
}

extension Float: LoremIpsumize {
    public static func lorem() -> Float {
        faker.number.randomFloat()
    }
    public static func loremFixed() -> Float { 3.14 }
}

extension Bool: LoremIpsumize {
    public static func lorem() -> Bool {
        Bool.random()
    }
    public static func loremFixed() -> Bool { true }
}

extension Date: LoremIpsumize {
    public static func lorem() -> Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }

    public static func loremFixed() -> Date {
        Date(timeIntervalSince1970: 0)
    }
}

extension URL: LoremIpsumize {
    public static func lorem() -> URL {
        URL(string: "https://picsum.photos/300") ?? URL(string: faker.internet.url())!
    }

    public static func lorem(_ kind: LoremKind?) -> URL {
        switch kind {
        case .url(.website):
            URL(string: faker.internet.url()) ?? lorem()
        case .url(.image):
            URL(string: "https://picsum.photos/400") ?? lorem()
        case .url(.avatar):
            URL(string: "https://robohash.org/\(UUID().uuidString).png") ?? lorem()
        case .url(.companyLogo):
            URL(string: faker.company.logo()) ?? lorem()
        default:
            lorem()
        }
    }

    public static func loremFixed() -> URL {
        URL(string: "https://example.com")!
    }
}

extension Color: LoremIpsumize {
    public static func lorem() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: 1
        )
    }

    public static func loremFixed() -> Color {
        Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1)
    }

    static func randomHexColor() -> String {
        let letters = "0123456789ABCDEF"
        var colorString = "#"

        for _ in 0..<6 {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            colorString.append(randomCharacter)
        }

        return colorString
    }
}

// MARK: - Set

extension Set: LoremIpsumize where Element: LoremIpsumize {
    public static func lorem() -> Set<Element> {
        let count = Int.random(in: 2...10)
        return Set((0..<count).map { _ in Element.lorem() })
    }

    public static func loremFixed() -> Set<Element> {
        [Element.loremFixed()]
    }
}

// MARK: - CoreGraphics Types

extension CGFloat: LoremIpsumize {
    public static func lorem() -> CGFloat {
        CGFloat.random(in: 0...1000)
    }
    public static func loremFixed() -> CGFloat { 100.0 }
}

extension CGPoint: LoremIpsumize {
    public static func lorem() -> CGPoint {
        CGPoint(x: CGFloat.lorem(), y: CGFloat.lorem())
    }
    public static func loremFixed() -> CGPoint {
        CGPoint(x: 0, y: 0)
    }
}

extension CGSize: LoremIpsumize {
    public static func lorem() -> CGSize {
        CGSize(width: CGFloat.random(in: 1...500), height: CGFloat.random(in: 1...500))
    }
    public static func loremFixed() -> CGSize {
        CGSize(width: 100, height: 100)
    }
}

extension CGRect: LoremIpsumize {
    public static func lorem() -> CGRect {
        CGRect(origin: CGPoint.lorem(), size: CGSize.lorem())
    }
    public static func loremFixed() -> CGRect {
        CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
    }
}

// MARK: - Data

extension Data: LoremIpsumize {
    public static func lorem() -> Data {
        let count = Int.random(in: 16...256)
        return Data((0..<count).map { _ in UInt8.random(in: 0...255) })
    }
    public static func loremFixed() -> Data {
        Data([0x4C, 0x6F, 0x72, 0x65, 0x6D]) // "Lorem" in UTF-8
    }
}

// MARK: - Character

extension Character: LoremIpsumize {
    public static func lorem() -> Character {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return letters.randomElement()!
    }
    public static func loremFixed() -> Character { "A" }
}
