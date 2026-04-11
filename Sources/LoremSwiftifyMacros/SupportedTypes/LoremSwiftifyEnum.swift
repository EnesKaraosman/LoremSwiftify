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
        type: some SwiftSyntax.TypeSyntaxProtocol,
        accessModifier: DeclModifierSyntax? = nil
    ) throws -> DeclSyntax {
        let cases = declaration.memberBlock.members.compactMap {
            $0.decl.as(EnumCaseDeclSyntax.self)
        }

        if cases.isEmpty {
            throw LoremSwiftifyMacroDiagnostic.noEnumCase
        }

        let randomCaseExpr = generateEnumCreationFunctionBody(for: cases, fixed: false)
        let firstCaseExpr = generateEnumCreationFunctionBody(for: cases, fixed: true)

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
            body: CodeBlockSyntax(statements: .init(stringLiteral: "\(type)\(randomCaseExpr)"))
        )

        let loremFixedFunc = try FunctionDeclSyntax(
            modifiers: modifiers,
            name: "loremFixed",
            signature: FunctionSignatureSyntax(
                parameterClause: emptyParams,
                returnClause: returnClause
            ),
            body: CodeBlockSyntax(statements: .init(stringLiteral: "\(type)\(firstCaseExpr)"))
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

    static private func generateEnumCreationFunctionBody(
        for cases: [EnumCaseDeclSyntax],
        fixed: Bool
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
                            arguments: getArguments(parameters, fixed: fixed),
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

        if fixed {
            return exprSyntaxArray.first!
        }
        return exprSyntaxArray.randomElement()!
    }

    static private func getArguments(_ parameters: [ParameterItem], fixed: Bool) -> LabeledExprListSyntax {
        let loremCall = fixed ? ".loremFixed()" : ".lorem()"
        let parameterList = parameters.map { parameter -> LabeledExprSyntax in
            let expression = ExprSyntax(stringLiteral: loremCall)
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
