//
//  LoremKind.swift
//
//
//  Created by Enes Karaosman on 28.03.2024.
//

import Foundation

public enum LoremKind {
    case string(StringLorem)

    public init?(_ kind: String) {
        let array = kind.components(separatedBy: ".")
        let parentKind = array.first ?? ""
        let childKind = array.last ?? ""
        
        switch parentKind {
        case "string":
            self = .string(.init(childKind))
        default:
            return nil
        }
    }
}

public extension LoremKind {
    enum StringLorem: String, RawRepresentable {
        case name
        case email
        case phoneNumber
        case creditCard
        case hexColor
        case `default`

        public init(_ kind: String) {
            self = StringLorem(rawValue: kind) ?? .default
        }
    }
}
