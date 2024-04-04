//
//  Shared.swift
//
//
//  Created by Enes Karaosman on 25.03.2024.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum LoremSwiftifyMacroParsingShared {
    static func handleClassOrStructDeclSyntax(
        selfName: String,
        members: MemberBlockItemListSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext,
        isClass: Bool
    ) throws -> DeclSyntax {
        var funcBody = ""

        // Use default init if exist
        if let initDeclSynax = members.initializerDeclSyntax {
            let parameters = initDeclSynax.signature.parameterClause.parameters

            funcBody = fillInitCode(initName: selfName, parameters: parameters)
        } else {
            // There is no default init, so create one
            let variableDecls = members
                .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                .filter(\.isStoredProperty)

            funcBody = generateInitCode(initName: selfName, variableDecls: variableDecls)
        }

        if isClass {
            funcBody.append(" as! Self")
        }

        let funcDecl = try FunctionDeclSyntax(
            modifiers: [
                .init(name: .keyword(.public)), // TODO: Add if type is public
                .init(name: .keyword(.static))
            ],
            name: "lorem",
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(validating: .init(parameters: [])),
                returnClause: ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .identifier("Self")))
            ),
            body: CodeBlockSyntax(statements: .init(stringLiteral: funcBody))
        )

        return DeclSyntax(funcDecl)
    }

    // MARK: - Fill existing init
    static func fillInitCode(
        initName: String,
        parameters: FunctionParameterListSyntax
    ) -> String {
        var initialCode: String = "\(initName)("

        for parameter in parameters {
            let name = parameter.firstName.text

            if let defaultValue = parameter.defaultValue?.value {
                initialCode.append("\n\(name): \(defaultValue), ")
            } else {
                
                let lorem = ".lorem()"
//                let value = "\(raw: lorem)"
                initialCode.append("\n\(name): \(lorem), ")
            }

        }

        initialCode = String(initialCode.dropLast(2))
        initialCode.append("\n)")

        return initialCode
    }

    // MARK: - Generate init
    static func generateInitCode(
        initName: String,
        variableDecls: [VariableDeclSyntax]
    ) -> String {
        var initialCode: String = "\(initName)("

        for variable in variableDecls where !variable.isInitialized {
            guard let pattern = variable.bindings.first?.pattern else { continue }
            
            var lorem = ".lorem()"

            if let loremAttributeKindString = variable.loremAttributeKindString {
                lorem = ".lorem(\(loremAttributeKindString))"
            }

            let name = "\(pattern.trimmed)"

            initialCode.append("\n\(name): \(lorem), ")
        }

        initialCode = String(initialCode.dropLast(2))
        initialCode.append("\n)")

        return initialCode
    }
}
