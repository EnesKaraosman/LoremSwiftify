import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

final class DiagnosticTests: XCTestCase {

    func testUnsupportedTypeProtocol() {
        assertMacro(
            """
            @LoremSwiftify
            protocol Foo {
            }
            """,
            expandedSource: """
            protocol Foo {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "You can only lorem struct, class and enum",
                    line: 1,
                    column: 1
                )
            ]
        )
    }
}

#endif
