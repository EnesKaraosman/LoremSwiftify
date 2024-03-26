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

        let funcDecl = try FunctionDeclSyntax("static func lorem() -> Self") {
            StmtSyntax(stringLiteral: funcBody)
        }

        return DeclSyntax(funcDecl)
    }

    // MARK: - Fill existing init
    static func fillInitCode(
        initName: String,
        parameters: FunctionParameterListSyntax
    ) -> String {
        var initialCode: String = "return \(initName)("

        for parameter in parameters {
            let name = parameter.firstName.text
            let typeName = "\(parameter.type)"

            let defaultValue = parameter.defaultValue?.value ?? "\(raw: typeName).lorem()"
            initialCode.append("\n\(name): \(defaultValue), ")
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
        var initialCode: String = "return \(initName)("

        for variable in variableDecls {
            guard let pattern = variable.bindings.first?.pattern else { continue }
            let name = "\(pattern.trimmed)"

            if let initializer = variable.bindings.first(where: { $0.initializer != nil })?.initializer {
                initialCode.append("\n\(name): \(initializer.value), ")
                continue
            }

            if let patternBindingSyntax = variable.bindings.first,
               let type = patternBindingSyntax.typeAnnotation?.type.as(IdentifierTypeSyntax.self) {

                let typeName = type.name.trimmed.text
                initialCode.append("\n\(name): \(typeName).lorem(), ")
            }
        }

        initialCode = String(initialCode.dropLast(2))
        initialCode.append("\n)")

        return initialCode
    }
}
