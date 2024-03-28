// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces mock values for its properties
@attached(member, names: named(lorem))
@attached(extension, conformances: LoremIpsumize, names: named(lorem))
public macro LoremSwiftify() = #externalMacro(module: "LoremSwiftifyMacros", type: "LoremSwiftifyMacro")

@attached(peer)
public macro Lorem(_ kind: LoremKind) = #externalMacro(module: "LoremSwiftifyMacros", type: "LoremMacro")
