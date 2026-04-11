import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class BatchAndFixedTests: XCTestCase {

    func testStructWithLoremFixedGeneration() {
        assertMacro(
            """
            @LoremSwiftify
            struct Profile {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            struct Profile {
                let name: String
                let age: Int
            }

            extension Profile: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Profile(
                        name: .lorem(),
                        age: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    Profile(
                        name: .loremFixed(),
                        age: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testEnumLoremFixedPicksFirstCase() {
        // Use single-case enum to avoid lorem() non-determinism
        assertMacro(
            """
            @LoremSwiftify
            enum Priority {
                case low
            }
            """,
            expandedSource: """
            enum Priority {
                case low
            }

            extension Priority: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Priority.low
                }
                static func loremFixed() -> Self {
                    Priority.low
                }
                #endif
            }
            """
        )
    }

    func testEnumWithAssociatedValueLoremFixed() {
        assertMacro(
            """
            @LoremSwiftify
            enum State {
                case loaded(data: String)
            }
            """,
            expandedSource: """
            enum State {
                case loaded(data: String)
            }

            extension State: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    State.loaded(data: .lorem())
                }
                static func loremFixed() -> Self {
                    State.loaded(data: .loremFixed())
                }
                #endif
            }
            """
        )
    }

    func testLoremFixedIgnoresLoremKindAnnotation() {
        assertMacro(
            """
            @LoremSwiftify
            struct Contact {
                @Lorem(.string(.email))
                let email: String

                @Lorem(.int(.range(min: 0, max: 100)))
                let score: Int
            }
            """,
            expandedSource: """
            struct Contact {
                let email: String
                let score: Int
            }

            extension Contact: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Contact(
                        email: .lorem(.string(.email)),
                        score: .lorem(.int(.range(min: 0, max: 100)))
                    )
                }
                static func loremFixed() -> Self {
                    Contact(
                        email: .loremFixed(),
                        score: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }
}

#endif
