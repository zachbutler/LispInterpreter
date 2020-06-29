//
//  Types.swift
//  LispInterpreter
//
//  Created by Zach Butler on 6/26/20.
//  Copyright © 2020 Zach Butler. All rights reserved.
//

import Foundation

public let keywordMagic: Character = "\u{029E}"

public enum Expr {
    case number(Int)
    case bool(Bool)
    case null
    case string(String)
    case symbol(String)
    // indirect allows for a sort of recursive typing
    indirect case list([Expr], Expr)
    indirect case vector([Expr], Expr)
    indirect case hashmap([String: Expr], Expr)
    case function(Func)
    case atom(Atom)
}

public extension Expr {
    static func list(_ lst: [Expr]) -> Expr {
        return .list(lst, .null)
    }
    
    static func vector(_ lst: [Expr]) -> Expr {
        return .vector(lst, .null)
    }
    
    static func hashmap(_ data: [String: Expr]) -> Expr {
        return .hashmap(data, .null)
    }
}

extension Expr: Equatable {
    // Switch statement defining equality for expressions.
    public static func == (left: Self, right: Self) -> Bool {
        switch (left, right) {
        case let (.number(a), .number(b)):
            return a == b
        case let (.bool(a), .bool(b)):
            return a == b
        case (.null, .null):
            return true
        case let (.string(a), .string(b)):
            return a == b
        case let (.symbol(a), .symbol(b)):
            return a == b
        case let (.list(a), .list(b)),
             let (.vector(a), .vector(b)),
             let (.list(a), .vector(b)),
             let (.vector(a), .list(b)):
            return a == b
        case let (.hashmap(a), .hashmap(b)):
            return a == b
        case let (.function(a), .function(b)):
            return a == b
        case let (.atom(a), .atom(b)):
            return a == b
        
        default:
            return false
        }
        
    }
}

// Define a function
final public class Func {
    
}

final public class Atom {
    public var val: Expr
    public let meta: Expr
    
    public init (_ val: Expr, meta: Expr = .null) {
        self.val = val
        self.meta = meta
    }
    
    public func withMeta(_ meta: Expr) -> Atom {
        return Atom(val, meta: meta)
    }
}

extension Atom: Equatable {
    public static func == (left: Atom, right: Atom) -> Bool {
        return left.val == right.val
    }
}
