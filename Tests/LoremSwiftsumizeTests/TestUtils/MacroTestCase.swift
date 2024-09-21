//
//  MockableMacroTestCase.swift
//
//

import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros

let testMacros: [String: Macro.Type] = [
    "LoremSwiftifyMacros": LoremSwiftifyMacro.self
]
#endif

extension XCTestCase {
    func assertMacro(
      _ originalSource: String,
      expandedSource expectedExpandedSource: String,
      diagnostics: [DiagnosticSpec] = [],
      applyFixIts: [String]? = nil,
      fixedSource expectedFixedSource: String? = nil
    ) {
        assertMacroExpansion(
            originalSource,
            expandedSource: expectedExpandedSource,
            diagnostics: diagnostics,
            macros: testMacros,
            applyFixIts: applyFixIts,
            fixedSource: expectedFixedSource
        )
    }
}
