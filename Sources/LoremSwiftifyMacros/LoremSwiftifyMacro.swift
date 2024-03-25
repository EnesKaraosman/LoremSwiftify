import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

let protocolName = "LoremIpsumize"

// TODO: Use better diagnostics
// https://github.com/apple/swift-syntax/blob/main/Examples/Sources/MacroExamples/Implementation/Diagnostics.swift
enum LoremSwiftifyMacroDiagnostic: DiagnosticMessage, Error {
    case notAStructOrClass
    case noMemberToMock

    var message: String {
        switch self {
        case .notAStructOrClass:
            return "You can only lorem struct or class"
        case .noMemberToMock:
            return "There is no member to lorem"
        }
    }

    var diagnosticID: SwiftDiagnostics.MessageID {
        MessageID(domain: "Swift", id: "LoremSwiftifyMacroDiagnostic.\(self)")
    }

    var severity: SwiftDiagnostics.DiagnosticSeverity { .error }
}

public enum LoremSwiftifyMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try LoremSwiftifyClass.expansion(
                of: node,
                providingMembersOf: classDecl,
                in: context
            )
        }

        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try LoremSwiftifyStruct.expansion(
                of: node,
                providingMembersOf: structDecl,
                in: context
            )
        }

        context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.notAStructOrClass))

        throw LoremSwiftifyMacroDiagnostic.notAStructOrClass
    }
}

@main
struct LoremSwiftifyPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoremSwiftifyMacro.self,
    ]
}
