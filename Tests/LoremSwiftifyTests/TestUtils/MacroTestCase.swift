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
import SwiftSyntax
import SwiftSyntaxMacroExpansion

let testMacroSpecs: [String: MacroSpec] = [
    "LoremSwiftify": MacroSpec(
        type: LoremSwiftifyMacro.self,
        conformances: ["LoremIpsumize"]
    ),
    "Lorem": MacroSpec(type: LoremMacro.self),
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
            macroSpecs: testMacroSpecs,
            applyFixIts: applyFixIts,
            fixedSource: expectedFixedSource
        )
    }
}
