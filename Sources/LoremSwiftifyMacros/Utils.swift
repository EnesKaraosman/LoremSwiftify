//
//  Utils.swift
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

    var isArray: Bool {
        bindings
            .first?
            .typeAnnotation?.as(TypeAnnotationSyntax.self)?
            .type.is(ArrayTypeSyntax.self) ?? false
    }
}

extension TypeSyntax {
    var isArray: Bool {
        self.as(ArrayTypeSyntax.self) != nil
    }

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
