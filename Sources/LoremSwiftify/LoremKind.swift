//
//  LoremKind.swift
//
//
//  Created by Enes Karaosman on 28.03.2024.
//

import Foundation

public enum LoremKind {
    case string(StringLorem)
}

public extension LoremKind {
    enum StringLorem: String, RawRepresentable {
        case name
        case email
        case phoneNumber
        case creditCard
        case hexColor
        case `default`
    }
}
