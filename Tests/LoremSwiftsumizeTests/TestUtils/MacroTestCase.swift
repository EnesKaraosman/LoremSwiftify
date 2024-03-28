//
//  MockableMacroTestCase.swift
//
//

import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacroTesting
import XCTest

#if canImport(LoremSwiftifyMacros)
import LoremSwiftifyMacros
#endif

class MacroTestCase: XCTestCase {
    override func invokeTest() {
        #if canImport(LoremSwiftifyMacros)
        withMacroTesting(isRecording: false, macros: ["LoremSwiftifyMacros": LoremSwiftifyMacro.self]) {
            super.invokeTest()
        }
        #else
        fatalError("Macro tests can only be run on the host platform!")
        #endif
    }
}
