import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class ClassExpansionTests: XCTestCase {

    func testBasicClassWithInit() {
        assertMacro(
            """
            @LoremSwiftify
            class User {
                let name: String
                let age: Int

                init(name: String, age: Int) {
                    self.name = name
                    self.age = age
                }
            }
            """,
            expandedSource: """
            class User {
                let name: String
                let age: Int

                init(name: String, age: Int) {
                    self.name = name
                    self.age = age
                }
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: .lorem(),
                        age: .lorem()
                    ) as! Self
                }
                static func loremFixed() -> Self {
                    User(
                        name: .loremFixed(),
                        age: .loremFixed()
                    ) as! Self
                }
                #endif
            }
            """
        )
    }

    func testClassWithDefaultInit() {
        assertMacro(
            """
            @LoremSwiftify
            class User {
                let name: String

                init(name: String = "default") {
                    self.name = name
                }
            }
            """,
            expandedSource: """
            class User {
                let name: String

                init(name: String = "default") {
                    self.name = name
                }
            }

            extension User: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    User(
                        name: "default"
                    ) as! Self
                }
                static func loremFixed() -> Self {
                    User(
                        name: "default"
                    ) as! Self
                }
                #endif
            }
            """
        )
    }

    func testEmptyClassDiagnostic() {
        assertMacro(
            """
            @LoremSwiftify
            class Empty {
            }
            """,
            expandedSource: """
            class Empty {
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
