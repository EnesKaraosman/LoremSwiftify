import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

let protocolName = "LoremIpsumize"

public enum LoremMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        // LoremMacro does not generate something, this will be controlled in LoremSwiftify macro
        []
    }
}

public enum LoremSwiftifyMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        if !declaration.is(StructDeclSyntax.self)
            && !declaration.is(ClassDeclSyntax.self)
            && !declaration.is(EnumDeclSyntax.self) {
            throw LoremSwiftifyMacroDiagnostic.unsupportedType
        }

        let extensionDecl = try ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: InheritanceClauseSyntax(
                inheritedTypes: .init(
                    itemsBuilder: { .init(type: protocols.first!) }
                )
            ),
            memberBlockBuilder:  {
                if let classDecl = declaration.as(ClassDeclSyntax.self) {
                    try LoremSwiftifyClass.expansion(
                        of: node,
                        providingMembersOf: classDecl,
                        in: context,
                        type: type
                    )
                } else if let structDecl = declaration.as(StructDeclSyntax.self) {
                    try LoremSwiftifyStruct.expansion(
                        of: node,
                        providingMembersOf: structDecl,
                        in: context,
                        type: type
                    )
                } else if let enumDecl = declaration.as(EnumDeclSyntax.self) {
                    try LoremSwiftifyEnum.expansion(
                        of: node,
                        providingMembersOf: enumDecl,
                        in: context,
                        type: type
                    )
                }
            }
        )

        return [extensionDecl]
    }
}

@main
struct LoremSwiftifyPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoremSwiftifyMacro.self,
        LoremMacro.self,
    ]
}
