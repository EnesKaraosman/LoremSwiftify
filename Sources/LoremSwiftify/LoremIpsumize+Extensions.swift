//
//  LoremIpsumize+Extensions.swift
//
//
//  Created by Enes Karaosman on 25.03.2024.
//

import Fakery
import SwiftUI

private let faker = Faker()

public protocol LoremIpsumize {
    static func lorem() -> Self
}
extension Optional: LoremIpsumize {
    public static func lorem() -> Optional<Wrapped> {
        .none
    }
}

extension Dictionary: LoremIpsumize where Key: LoremIpsumize, Value: LoremIpsumize {
    public static func lorem() -> Dictionary<Key, Value> {
        let count = Int.random(in: 2...10)

        return (0..<count).reduce(into: [:]) { result, _ in
            result[Key.lorem()] = Value.lorem()
        }
    }
}

extension Array: LoremIpsumize where Element: LoremIpsumize {
    public static func lorem() -> Array<Element> {
        let count = Int.random(in: 2...10)
        
        return (1...count).indices.map { _ in
            Element.lorem()
        }
    }
}

extension UUID: LoremIpsumize {
    public static func lorem() -> UUID {
        UUID()
    }
}

extension String: LoremIpsumize {
    public static func lorem() -> String {
        faker.lorem.word()
    }
}

// MARK: - Int Extensions

extension Int: LoremIpsumize {
    public static func lorem() -> Int {
        faker.number.randomInt()
    }
}

extension Int8: LoremIpsumize {
    public static func lorem() -> Int8 {
        Int8.max
    }
}

extension Int16: LoremIpsumize {
    public static func lorem() -> Int16 {
        Int16.max
    }
}

extension Int32: LoremIpsumize {
    public static func lorem() -> Int32 {
        Int32.max
    }
}

extension Int64: LoremIpsumize {
    public static func lorem() -> Int64 {
        Int64.max
    }
}

// -------------------------

// MARK: - UInt Extensions

extension UInt: LoremIpsumize {
    public static func lorem() -> UInt {
        UInt.max
    }
}

extension UInt8: LoremIpsumize {
    public static func lorem() -> UInt8 {
        UInt8.max
    }
}

extension UInt16: LoremIpsumize {
    public static func lorem() -> UInt16 {
        UInt16.max
    }
}

extension UInt32: LoremIpsumize {
    public static func lorem() -> UInt32 {
        UInt32.max
    }
}

extension UInt64: LoremIpsumize {
    public static func lorem() -> UInt64 {
        UInt64.max
    }
}

// -------------------------

extension Double: LoremIpsumize {
    public static func lorem() -> Double {
        faker.number.randomDouble()
    }
}

extension Float: LoremIpsumize {
    public static func lorem() -> Float {
        faker.number.randomFloat()
    }
}

extension Bool: LoremIpsumize {
    public static func lorem() -> Bool {
        Bool.random()
    }
}

extension Date: LoremIpsumize {
    public static func lorem() -> Date {
        if #available(iOS 15, *) {
            return Date.now
        } else {
            return Date()
        }
    }
}

extension URL: LoremIpsumize {
    public static func lorem() -> URL {
        URL(string: "https://picsum.photos/300") ?? URL(string: faker.internet.url())!
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
}
