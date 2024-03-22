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
            return [
                try ExtensionDeclSyntax(
            """
            extension \(raw: classDecl.name.text): \(raw: protocolName)
            """
                ) {
                    "\(try expansion(of: node, providingMembersOf: declaration, in: context))"
                }
            ]
        }

        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return [
                try ExtensionDeclSyntax(
            """
            extension \(raw: structDecl.name.text): \(raw: protocolName)
            """
                ) {
                    "\(try expansion(of: node, providingMembersOf: declaration, in: context))"
                }
            ]
        }

        context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.notAStructOrClass))

        return []
    }

    // MARK: - Member expansion
    private static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> DeclSyntax {
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return try classDeclSyntax(declaration: classDecl, in: context)
        }

        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return try structDeclSyntax(declaration: structDecl, in: context)
        }

        context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.notAStructOrClass))

        throw LoremSwiftifyMacroDiagnostic.notAStructOrClass
    }


    // MARK: - Handle struct loreming
    static func structDeclSyntax(declaration: StructDeclSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> DeclSyntax {

        if declaration.memberBlock.members.isEmpty {
            context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.noMemberToMock))
        }

        let members = declaration.memberBlock.members
        let structName = declaration.name.text

        return try handleClassOrStructDeclSyntax(
            selfName: structName,
            members: members,
            in: context,
            isClass: false
        )
    }

    // MARK: - Handle class loreming
    static func classDeclSyntax(declaration: ClassDeclSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> DeclSyntax {

        if declaration.memberBlock.members.isEmpty {
            context.diagnose(.init(node: declaration, message: LoremSwiftifyMacroDiagnostic.noMemberToMock))
        }

        let members = declaration.memberBlock.members
        let className = declaration.name.text

        return try handleClassOrStructDeclSyntax(
            selfName: className,
            members: members,
            in: context,
            isClass: true
        )
    }

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
            let variableDecls = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }

            funcBody = generateInitCode(initName: selfName, variableDecls: variableDecls)
        }

        if isClass {
            funcBody.append(" as! Self")
        }

        let funcDecl = try FunctionDeclSyntax("static func lorem() -> Self") {
//            "\(raw: declaration.debugDescription)"
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

@main
struct LoremSwiftifyPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoremSwiftifyMacro.self,
    ]
}
