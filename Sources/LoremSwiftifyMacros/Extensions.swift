//
//  Extensions.swift
//
//
//  Created by Enes Karaosman on 23.03.2024.
//

import SwiftSyntax

extension MemberBlockItemListSyntax {
    var initializerDeclSyntax: InitializerDeclSyntax? {
        first(where: { $0.decl.is(InitializerDeclSyntax.self) })?.decl.as(InitializerDeclSyntax.self)
    }

    var structDeclSyntax: StructDeclSyntax? {
        first(where: { $0.decl.is(StructDeclSyntax.self) })?.decl.as(StructDeclSyntax.self)
    }

    var classDeclSyntax: ClassDeclSyntax? {
        first(where: { $0.decl.is(ClassDeclSyntax.self) })?.decl.as(ClassDeclSyntax.self)
    }

    var hasInit: Bool {
        initializerDeclSyntax != nil
    }

    var hasStructMember: Bool {
        structDeclSyntax != nil
    }

    var hasClassMember: Bool {
        classDeclSyntax != nil
    }
}

extension EnumCaseDeclSyntax {
    var hasAssociatedValues: Bool {
        self.elements.first?.parameterClause != nil
    }

    var name: String {
        guard let caseName = self.elements.first?.name.text
        else {
            fatalError("Compiler Bug: Case name not found")
        }

        return caseName
    }

    var parameters: [(TokenSyntax?, TypeSyntax)] {
        self.elements.first?.parameterClause?.parameters.map {
            ($0.firstName, $0.type)
        } ?? []
    }
}

extension VariableDeclSyntax {
    var isStoredProperty: Bool {
        // Stored properties cannot have more than 1 binding in its declaration.
        guard bindings.count == 1
        else {
            return false
        }

        guard let accesor = bindings.first?.accessorBlock
        else {
            // Nothing to review. It's a valid stored property
            return true
        }

        switch accesor.accessors {
        case .accessors(let accesorBlockSyntax):
            // Observers are valid accesors only
            let validAccesors = Set<TokenKind>([
                .keyword(.willSet), .keyword(.didSet)
            ])

            let hasValidAccesors = accesorBlockSyntax.contains {
                // Other kind of accesors will make the variable a computed property
                validAccesors.contains($0.accessorSpecifier.tokenKind)
            }
            return hasValidAccesors
        case .getter:
            // A variable with only a getter is not valid for initialization.
            return false
        }

    }

    var initializer: InitializerClauseSyntax? {
        bindings.compactMap { $0.initializer }.first
    }

    var isInitialized: Bool {
        initializer != nil
    }

    var typeName: String {
        bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self)?.name.text ?? ""
    }

    private var loremAttribute: AttributeSyntax? {
        attributes
            .first(
                where: { 
                    $0.as(AttributeSyntax.self)?
                        .attributeName.as(IdentifierTypeSyntax.self)?
                        .name.text == "Lorem"
                }
            )?
            .as(AttributeSyntax.self)
    }

    /// Returns a value to be used  to initiate `LoremKind` like .string(.init("creditCard"))
    var loremAttributeKindString: String? {
        guard
            let loremAttribute,
            let expression = loremAttribute
                .arguments?.as(LabeledExprListSyntax.self)?
                .first?.expression.as(FunctionCallExprSyntax.self),
            let outerEnumRawValue = expression.calledExpression.as(MemberAccessExprSyntax.self)?
                .declName.baseName.text,
            let innerEnumRawValue = expression.arguments
                .first?.expression.as(MemberAccessExprSyntax.self)?
                .declName.baseName.text
        else { return nil }

        return ".\(outerEnumRawValue)(.init(\"\(innerEnumRawValue)\"))"
    }
}

extension TypeSyntax {
    var isSimpleType: Bool {
        self.as(IdentifierTypeSyntax.self) != nil
    }

    var isDictionary: Bool {
        self.as(DictionaryTypeSyntax.self) != nil
    }

    var isOptional: Bool {
        self.as(OptionalTypeSyntax.self) != nil
    }
}
