import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class LoremKindTests: XCTestCase {

    func testStringLoremKind() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                @Lorem(.string(.email))
                let email: String
            }
            """,
            expandedSource: """
            struct User {
                let email: String
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        email: .lorem(.string(.email))
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        email: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testURLLoremKind() {
        assertMacro(
            """
            @LoremSwiftify
            struct Website {
                @Lorem(.url(.website))
                let link: URL
            }
            """,
            expandedSource: """
            struct Website {
                let link: URL
            }

            extension Website: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Website(
                        link: .lorem(.url(.website))
                    )
                }
                static func loremFixed() -> Self {
                    Website(
                        link: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testIntRangeLoremKind() {
        assertMacro(
            """
            @LoremSwiftify
            struct Config {
                @Lorem(.int(.range(min: 0, max: 100)))
                let count: Int
            }
            """,
            expandedSource: """
            struct Config {
                let count: Int
            }

            extension Config: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Config(
                        count: .lorem(.int(.range(min: 0, max: 100)))
                    )
                }
                static func loremFixed() -> Self {
                    Config(
                        count: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testNewStringCategories() {
        assertMacro(
            """
            @LoremSwiftify
            struct BankInfo {
                @Lorem(.string(.iban))
                let iban: String

                @Lorem(.string(.ipV4Address))
                let ip: String

                @Lorem(.string(.productName))
                let product: String
            }
            """,
            expandedSource: """
            struct BankInfo {
                let iban: String
                let ip: String
                let product: String
            }

            extension BankInfo: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    BankInfo(
                        iban: .lorem(.string(.iban)),
                        ip: .lorem(.string(.ipV4Address)),
                        product: .lorem(.string(.productName))
                    )
                }
                static func loremFixed() -> Self {
                    BankInfo(
                        iban: .loremFixed(),
                        ip: .loremFixed(),
                        product: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testDoublePriceLoremKind() {
        assertMacro(
            """
            @LoremSwiftify
            struct Product {
                @Lorem(.double(.price))
                let price: Double
            }
            """,
            expandedSource: """
            struct Product {
                let price: Double
            }

            extension Product: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Product(
                        price: .lorem(.double(.price))
                    )
                }
                static func loremFixed() -> Self {
                    Product(
                        price: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testDoubleRangeLoremKind() {
        assertMacro(
            """
            @LoremSwiftify
            struct Measurement {
                @Lorem(.double(.range(min: 0.0, max: 1.0)))
                let value: Double
            }
            """,
            expandedSource: """
            struct Measurement {
                let value: Double
            }

            extension Measurement: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Measurement(
                        value: .lorem(.double(.range(min: 0.0, max: 1.0)))
                    )
                }
                static func loremFixed() -> Self {
                    Measurement(
                        value: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }
}

#endif
