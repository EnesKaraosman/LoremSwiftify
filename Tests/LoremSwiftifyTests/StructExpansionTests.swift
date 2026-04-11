import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class StructExpansionTests: XCTestCase {

    func testBasicStruct() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let age: Int
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        age: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        age: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testPublicStruct() {
        assertMacro(
            """
            @LoremSwiftify
            public struct User {
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            public struct User {
                let name: String
                let age: Int
            }

            extension User: LoremIpsumize {
                #if DEBUG
                public static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        age: .lorem()
                    )
                }
                public static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        age: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testStructWithLoremAnnotation() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                @Lorem(.string(.name))
                let name: String
                let age: Int
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let age: Int
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(.string(.name)),
                        age: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        age: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testStructWithDefaultValue() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                let name: String
                let age: Int = 25
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let age: Int = 25
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testStructWithCustomInit() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                let name: String
                let age: Int

                init(name: String, age: Int = 25) {
                    self.name = name
                    self.age = age
                }
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let age: Int

                init(name: String, age: Int = 25) {
                    self.name = name
                    self.age = age
                }
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        age: 25
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        age: 25
                    )
                }
                #endif
            }
            """
        )
    }

    func testStructWithOptionalProperty() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                let name: String
                let nickname: String?
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let nickname: String?
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        nickname: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        nickname: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testStructWithArrayProperty() {
        assertMacro(
            """
            @LoremSwiftify
            struct User {
                let name: String
                let tags: [String]
            }
            """,
            expandedSource: """
            struct User {
                let name: String
                let tags: [String]
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        tags: .lorem()
                    )
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        tags: .loremFixed()
                    )
                }
                #endif
            }
            """
        )
    }

    func testEmptyStructDiagnostic() {
        assertMacro(
            """
            @LoremSwiftify
            struct Empty {
            }
            """,
            expandedSource: """
            struct Empty {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "There is no member to lorem",
                    line: 1,
                    column: 1
                )
            ]
        )
    }
}

#endif
