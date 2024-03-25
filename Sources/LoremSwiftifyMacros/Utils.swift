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
