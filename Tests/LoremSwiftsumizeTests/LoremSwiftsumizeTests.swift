import MacroTesting
import XCTest

final class LoremSwiftifyTests: MacroTestCase {
    func testUnsupportedDeclSyntaxMacro() throws {
        assertMacro {
            """
            @LoremSwiftify
            struct User {
                let name: String
            }
            """
        } expansion: {
            """
            extension User: LoremIpsumize {
                static func lorem() -> Self {
                    return User(name: "lorem")
                }
            }
            """
        }
    }
}
