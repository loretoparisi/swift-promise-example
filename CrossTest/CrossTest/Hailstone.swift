//
//  Hailstone.swift
//  CrossTest
//
//  Created by Loreto Parisi on 11/02/16.
//  Copyright © 2016 Musixmatch. All rights reserved.
//
// Collatz conjecture
// http://austinzheng.com/2015/01/24/swift-seq/
// https://en.wikipedia.org/wiki/Collatz_conjecture

struct HailstoneGenerator : GeneratorType {
    var value : Int
    
    mutating func next() -> Int? {
        let this = value
        // If even, divide by 2. If odd, multiply by 3 and add 1.
        value = (value % 2 == 0) ? (value / 2) : (3*value + 1)
        return this
    }
}

struct Hailstone : SequenceType {
    let start : Int
    
    func generate() -> HailstoneGenerator {
        return HailstoneGenerator(value: start)
    }
}
