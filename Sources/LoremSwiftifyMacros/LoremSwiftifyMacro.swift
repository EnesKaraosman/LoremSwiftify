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

public enum LoremSwiftifyMacro: ExtensionMacro {
    // MARK: - Extension expansion
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try LoremSwiftifyClass.expansion(
                of: node,
                attachedTo: classDecl,
                providingExtensionsOf: type,
                conformingTo: protocols,
                in: context
            )
        }

        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try LoremSwiftifyStruct.expansion(
                of: node,
                attachedTo: structDecl,
                providingExtensionsOf: type,
                conformingTo: protocols,
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
