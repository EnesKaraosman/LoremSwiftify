import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

let protocolName = "LoremIpsumize"

// TODO: Use better diagnostics
// https://github.com/apple/swift-syntax/blob/main/Examples/Sources/MacroExamples/Implementation/Diagnostics.swift
enum LoremSwiftifyMacroDiagnostic: DiagnosticMessage, Error {
    case unsupportedType
    case noMemberToMock
    case noEnumCase

    var message: String {
        switch self {
        case .unsupportedType:
            return "You can only lorem struct, class and enum"
        case .noMemberToMock:
            return "There is no member to lorem"
        case .noEnumCase:
            return "There is no enum case to lorem"
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
        if !declaration.is(StructDeclSyntax.self)
            && !declaration.is(ClassDeclSyntax.self)
            && !declaration.is(EnumDeclSyntax.self) {

            context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.unsupportedType))

            throw LoremSwiftifyMacroDiagnostic.unsupportedType
        }

        return []
    }
}

extension LoremSwiftifyMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {

        let extensionDecl = try ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: InheritanceClauseSyntax(
                inheritedTypes: .init(
                    itemsBuilder: { .init(type: protocols.first!) }
                )
            )
        ) {
            if let classDecl = declaration.as(ClassDeclSyntax.self) {
                try LoremSwiftifyClass.expansion(
                    of: node,
                    providingMembersOf: classDecl,
                    in: context,
                    type: type
                )
            }

            if let structDecl = declaration.as(StructDeclSyntax.self) {
                try LoremSwiftifyStruct.expansion(
                    of: node,
                    providingMembersOf: structDecl,
                    in: context,
                    type: type
                )
            }

            if let enumDecl = declaration.as(EnumDeclSyntax.self) {
                try LoremSwiftifyEnum.expansion(
                    of: node,
                    providingMembersOf: enumDecl,
                    in: context,
                    type: type
                )
            }
        }

        return [extensionDecl]
    }
}

@main
struct LoremSwiftifyPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoremSwiftifyMacro.self,
    ]
}
