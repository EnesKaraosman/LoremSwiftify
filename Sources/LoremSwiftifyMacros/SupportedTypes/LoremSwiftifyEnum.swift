//
//  LoremSwiftifyEnum.swift
//
//
//  Created by Enes Karaosman on 27.03.2024.
//

import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

class LoremSwiftifyEnum {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: EnumDeclSyntax,
        in context: some MacroExpansionContext,
        type: some SwiftSyntax.TypeSyntaxProtocol
    ) throws -> DeclSyntax {
        let cases = declaration.memberBlock.members.compactMap {
            $0.decl.as(EnumCaseDeclSyntax.self)
        }

        if cases.isEmpty {
            throw LoremSwiftifyMacroDiagnostic.noEnumCase
        }

        let caseExpr = generateEnumCreationFunctionBody(for: cases)

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
            body: CodeBlockSyntax(statements: .init(stringLiteral: "\(type)\(caseExpr)"))
        )

        return DeclSyntax(funcDecl)
    }

    static private func generateEnumCreationFunctionBody(
        for cases: [EnumCaseDeclSyntax]
    ) -> ExprSyntax {
        var exprSyntaxArray: [ExprSyntax] = []

        for caseItem in cases {
            if caseItem.hasAssociatedValues {
                let parameters = caseItem.parameters.map {
                    ParameterItem(
                        identifierName: $0.0?.text,
                        identifierType: $0.1
                    )
                }

                exprSyntaxArray.append(
                    ExprSyntax(
                        FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                period: .periodToken(),
                                name: .identifier(caseItem.name)
                            ),
                            leftParen: .leftParenToken(),
                            arguments: getArguments(parameters),
                            rightParen: .rightParenToken()
                        )
                    )
                )
            } else {
                exprSyntaxArray.append(
                    ExprSyntax(
                        MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: .identifier(caseItem.name)
                        )
                    )
                )
            }
        }

        return exprSyntaxArray.randomElement()!
    }

    static private func getArguments(_ parameters: [ParameterItem]) -> LabeledExprListSyntax {
        let parameterList = parameters.map { parameter -> LabeledExprSyntax in
            let expression = ExprSyntax(stringLiteral: ".lorem()")
            let isNotLast = parameter.identifierType != parameters.last?.identifierType
            
            return LabeledExprSyntax(
                label: parameter.hasName ? .identifier(parameter.identifierName!) : nil,
                colon: parameter.hasName ? .colonToken() : nil,
                expression: expression,
                trailingComma: isNotLast ? .commaToken() : nil
            )
        }

        return LabeledExprListSyntax(parameterList)
    }
}

extension LoremSwiftifyEnum {
    struct ParameterItem {
        let identifierName: String?
        let identifierType: TypeSyntax

        var hasName: Bool {
            identifierName != nil
        }
    }
}
