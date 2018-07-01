//
//  Mean.swift
//  Genki
//
//  Created by acb on 30/06/2018.
//  Copyright © 2018 Kineticfactory. All rights reserved.
//

import Foundation

// Since there is no universal parent numeric type that defines division, we need to retrofit the existing types into a protocol
public protocol Averageable {
    init(_ v: Int)
    static func += (lhs: inout Self, rhs: Self)
    static func / (lhs: Self, rhs: Self) -> Self
}
extension Float: Averageable { }
extension Double: Averageable { }
extension Int: Averageable { }
extension UInt: Averageable { }

public struct MeanBucket<Element>: SubsamplingBucket where Element: Averageable {
    var sum: Element
    var count: Int
    
    public init(_ initial: Element) {
        self.sum = initial
        self.count = 1
    }
    
    public mutating func add(_ value: Element) {
        self.sum += value
        self.count += 1
    }
    
    public var mean: Element {
        return sum / Element(count)
    }
}
