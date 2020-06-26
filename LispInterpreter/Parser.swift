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

extension Parsers {
    static func string(_ p: String) -> Parser<Void> {
        Parser { str in
            str.hasPrefix(p) ? ((), str.dropFirst(p.count)) : nil
        }
    }
    

}




