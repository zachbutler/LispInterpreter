//
//  Parser.swift
//  LispInterpreter
//
//  Created by Zach Butler on 6/26/20.
//  Copyright © 2020 Zach Butler. All rights reserved.
//

import Foundation

struct Parser<A> {
    // Generic parser structure. How do generics work in Swift? Let's find out.
    let parse: (_ s: Substring) throws -> (A, Substring)?
}

extension Parser {
    func parse(_ string: String) throws -> A? {
        try parse(string[...])?.0
    }
}

struct Parsers {}

// pattern matching on a string or character
extension Parsers {
    static func string(_ p: String) -> Parser<Void> {
        Parser { str in
            str.hasPrefix(p) ? ((), str.dropFirst(p.count)) : nil
        }
    }
    
    static let char = Parser<Character> { str in
        str.isEmpty ? nil : (str.first!, str.dropFirst())
    }
    
    static func char(excluding string: String) -> Parser<Character> {
        char.filter { !string.contains($0) }
    }
    
    static func char(from string: String) -> Parser<Character> {
        char.filter(string.contains)
    }
    
    static func string(excluding string: String) -> Parser<String> {
        char(excluding: string).oneOrMore.map { String($0) }
    }
    
    static let digit = char(from: "0123456789")
    static let naturalNumber = digit.oneOrMore.map { Int(String($0)) }
}

extension Parser: ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral, ExpressibleByExtendedGraphemeClusterLiteral where A == Void {
    
    typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    typealias UnicodeScalarLiteralType = StringLiteralType
    typealias StringLiteralType = String
    
    init(stringLiteral value: String) {
        self = Parsers.string(value)
    }
}

// Get Functional

func zip<A, B>()




