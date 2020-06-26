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
}

// Define a function
final public class Func {
    
}
