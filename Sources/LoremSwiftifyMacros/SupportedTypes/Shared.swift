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
        isClass: Bool,
        accessModifier: DeclModifierSyntax? = nil
    ) throws -> DeclSyntax {
        var loremBody = ""
        var loremFixedBody = ""

        // Use default init if exist
        if let initDeclSynax = members.initializerDeclSyntax {
            let parameters = initDeclSynax.signature.parameterClause.parameters

            loremBody = fillInitCode(initName: selfName, parameters: parameters, fixed: false)
            loremFixedBody = fillInitCode(initName: selfName, parameters: parameters, fixed: true)
        } else {
            // There is no default init, so create one
            let variableDecls = members
                .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                .filter(\.isStoredProperty)

            loremBody = generateInitCode(initName: selfName, variableDecls: variableDecls, fixed: false)
            loremFixedBody = generateInitCode(initName: selfName, variableDecls: variableDecls, fixed: true)
        }

        if isClass {
            loremBody.append(" as! Self")
            loremFixedBody.append(" as! Self")
        }

        var modifiers: DeclModifierListSyntax = [
            .init(name: .keyword(.static))
        ]
        if let accessModifier {
            modifiers = [accessModifier, .init(name: .keyword(.static))]
        }

        let returnClause = ReturnClauseSyntax(type: IdentifierTypeSyntax(name: .identifier("Self")))
        let emptyParams = try FunctionParameterClauseSyntax(validating: .init(parameters: []))

        let loremFunc = try FunctionDeclSyntax(
            modifiers: modifiers,
            name: "lorem",
            signature: FunctionSignatureSyntax(
                parameterClause: emptyParams,
                returnClause: returnClause
            ),
            body: CodeBlockSyntax(statements: .init(stringLiteral: loremBody))
        )

        let loremFixedFunc = try FunctionDeclSyntax(
            modifiers: modifiers,
            name: "loremFixed",
            signature: FunctionSignatureSyntax(
                parameterClause: emptyParams,
                returnClause: returnClause
            ),
            body: CodeBlockSyntax(statements: .init(stringLiteral: loremFixedBody))
        )

        let ifConfigDecl = IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("DEBUG"))),
                    elements: .decls(MemberBlockItemListSyntax {
                        MemberBlockItemSyntax(decl: loremFunc)
                        MemberBlockItemSyntax(decl: loremFixedFunc)
                    })
                )
            },
            poundEndif: .poundEndifToken()
        )

        return DeclSyntax(ifConfigDecl)
    }

    // MARK: - Fill existing init
    static func fillInitCode(
        initName: String,
        parameters: FunctionParameterListSyntax,
        fixed: Bool
    ) -> String {
        var initialCode: String = "\(initName)("

        for parameter in parameters {
            let name = parameter.firstName.text

            let lorem = fixed ? ".loremFixed()" : ".lorem()"

            let value = parameter.defaultValue?.value ?? "\(raw: lorem)"
            initialCode.append("\n\(name): \(value), ")
        }

        initialCode = String(initialCode.dropLast(2))
        initialCode.append("\n)")

        return initialCode
    }

    // MARK: - Generate init
    static func generateInitCode(
        initName: String,
        variableDecls: [VariableDeclSyntax],
        fixed: Bool
    ) -> String {
        var initialCode: String = "\(initName)("

        for variable in variableDecls where !variable.isInitialized {
            guard let pattern = variable.bindings.first?.pattern else { continue }

            var lorem = fixed ? ".loremFixed()" : ".lorem()"

            if !fixed, let loremAttributeKindString = variable.loremAttributeKindString {
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
