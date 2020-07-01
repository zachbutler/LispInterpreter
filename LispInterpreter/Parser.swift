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

func zip<A, B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
    a.flatMap { matchA in b.map { matchB in (matchA, matchB) } }
}

func oneOf<A>(_ parsers: Parser<A>...) -> Parser<A> {
    precondition(!parsers.isEmpty)
    return Parser<A> { str -> (A, Substring)? in
        for parser in parsers {
            // FIXME: - check out where syntax here
            if let match  = try parser.parse(str) {
                return match
            }
        }
        return nil
    }
}

extension Parser {
    func map<B>(_ transform: @escaping (A) throws -> B?) -> Parser<B> {
        flatMap { match in
            Parser<B> { str in
                (try transform(match)).map { ($0, str) }
            }
        }
    }
    
    func flatMap<B>(_ transform: @escaping (A) throws -> Parser<B>) -> Parser<B> {
        Parser<B> {str in
            guard let (a, str) = try self.parse(str) else { return nil }
            return try transfrom(a).parse(str)
        }
    }
    
    func filter(_ predicate: @escaping (A) -> Bool) -> Parser<A> {
        map { predicate($0) ? $0 : nil }
    }
}






