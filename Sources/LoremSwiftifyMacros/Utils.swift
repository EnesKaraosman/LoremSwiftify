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

    var hasInit: Bool {
        initializerDeclSyntax != nil
    }
}
