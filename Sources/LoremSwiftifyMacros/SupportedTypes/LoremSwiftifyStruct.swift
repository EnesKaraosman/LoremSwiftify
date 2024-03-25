//
//  LoremSwiftifyStruct.swift
//  
//
//  Created by Enes Karaosman on 25.03.2024.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

class LoremSwiftifyStruct {
    static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: StructDeclSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        return [
            try ExtensionDeclSyntax(
            """
            extension \(raw: declaration.name.text): \(raw: protocolName)
            """
            ) {
                "\(try structDeclSyntax(declaration: declaration, in: context))"
            }
        ]
    }

    private static func structDeclSyntax(declaration: StructDeclSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> DeclSyntax {

        if declaration.memberBlock.members.isEmpty {
            context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.noMemberToMock))
        }

        let members = declaration.memberBlock.members
        let structName = declaration.name.text

        return try LoremSwiftifyMacroParsingShared.handleClassOrStructDeclSyntax(
            selfName: structName,
            members: members,
            in: context,
            isClass: false
        )
    }
}

