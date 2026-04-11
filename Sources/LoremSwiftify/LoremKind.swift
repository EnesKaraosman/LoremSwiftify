//
//  LoremKind.swift
//
//
//  Created by Enes Karaosman on 28.03.2024.
//

import Foundation

public enum LoremKind {
    case string(StringLorem)
    case url(URLLorem)
    case int(IntLorem)
    case double(DoubleLorem)
}

public extension LoremKind {
    enum StringLorem: String {
        // Name
        case name
        case firstName
        case lastName
        case namePrefix
        case nameSuffix
        // Contact
        case email
        case phoneNumber
        case cellPhone
        // Address
        case address
        case city
        case state
        case stateAbbreviation
        case zipCode
        case country
        case countryCode
        case county
        case timeZone
        case latitude
        case longitude
        // Business
        case company
        case companySuffix
        case catchPhrase
        case jobTitle
        case creditCard
        case creditCardType
        // Internet
        case username
        case password
        case domainName
        case domainSuffix
        case ipV4Address
        case ipV6Address
        case hashtag
        case hexColor
        // Text
        case paragraph
        case sentence
        case words
        // Banking
        case bankName
        case iban
        case swiftBic
        // Commerce
        case productName
        case department
        case colorName
        // App
        case appName
        case appVersion
        // Misc
        case gender
        case carBrand
        case programmingLanguage
        case `default`
    }
}

public extension LoremKind {
    enum URLLorem: String {
        case image
        case website
        case avatar
        case companyLogo
    }
}

public extension LoremKind {
    enum IntLorem {
        case range(min: Int, max: Int)
    }
}

public extension LoremKind {
    enum DoubleLorem {
        case range(min: Double, max: Double)
        case price
    }
}
