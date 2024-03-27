// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol LoremIpsumize {
    static func lorem() -> Self
}

/// A macro that produces mock values for its properties
@attached(member, names: named(lorem))
@attached(extension, conformances: LoremIpsumize, names: named(lorem))
public macro LoremSwiftify() = #externalMacro(module: "LoremSwiftifyMacros", type: "LoremSwiftifyMacro")
