//
//  LoremIpsumize+Extensions.swift
//
//
//  Created by Enes Karaosman on 25.03.2024.
//

import Fakery
import SwiftUI

private let faker = Faker()

extension String: LoremIpsumize {
    public static func lorem() -> String {
        faker.lorem.word()
    }
}

extension Int: LoremIpsumize {
    public static func lorem() -> Int {
        faker.number.randomInt()
    }
}

extension Bool: LoremIpsumize {
    public static func lorem() -> Bool {
        Bool.random()
    }
}

extension Date: LoremIpsumize {
    public static func lorem() -> Date {
        Date.now
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
