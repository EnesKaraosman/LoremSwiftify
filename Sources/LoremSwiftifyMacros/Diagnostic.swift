//
//  Diagnostic.swift
//  
//
//  Created by Enes Karaosman on 10.08.2024.
//

import SwiftDiagnostics

enum LoremSwiftifyMacroDiagnostic: DiagnosticMessage, Error {
    case unsupportedType
    case noMemberToMock
    case noEnumCase

    var message: String {
        switch self {
        case .unsupportedType:
            return "You can only lorem struct, class and enum"
        case .noMemberToMock:
            return "There is no member to lorem"
        case .noEnumCase:
            return "There is no enum case to lorem"
        }
    }

    var diagnosticID: SwiftDiagnostics.MessageID {
        MessageID(domain: "Swift", id: "LoremSwiftifyMacroDiagnostic.\(self)")
    }

    var severity: SwiftDiagnostics.DiagnosticSeverity { .error }
}
