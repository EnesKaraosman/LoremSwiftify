import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class EnumExpansionTests: XCTestCase {

    func testSimpleEnum() {
        assertMacro(
            """
            @LoremSwiftify
            enum Status {
                case active
            }
            """,
            expandedSource: """
            enum Status {
                case active
            }

            extension Status: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Status.active
                }
                static func loremFixed() -> Self {
                    Status.active
                }
                #endif
            }
            """
        )
    }

    func testEnumWithAssociatedValues() {
        assertMacro(
            """
            @LoremSwiftify
            enum Result {
                case success(value: String)
            }
            """,
            expandedSource: """
            enum Result {
                case success(value: String)
            }

            extension Result: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Result.success(value: .lorem())
                }
                static func loremFixed() -> Self {
                    Result.success(value: .loremFixed())
                }
                #endif
            }
            """
        )
    }

    func testEnumWithUnlabeledAssociatedValue() {
        assertMacro(
            """
            @LoremSwiftify
            enum Wrapper {
                case value(String)
            }
            """,
            expandedSource: """
            enum Wrapper {
                case value(String)
            }

            extension Wrapper: LoremIpsumize {
                #if DEBUG
                static func lorem() -> Self {
                    Wrapper.value(.lorem())
                }
                static func loremFixed() -> Self {
                    Wrapper.value(.loremFixed())
                }
                #endif
            }
            """
        )
    }

    func testEmptyEnumDiagnostic() {
        assertMacro(
            """
            @LoremSwiftify
            enum Empty {
            }
            """,
            expandedSource: """
            enum Empty {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "There is no enum case to lorem",
                    line: 1,
                    column: 1
                )
            ]
        )
    }
}

#endif
