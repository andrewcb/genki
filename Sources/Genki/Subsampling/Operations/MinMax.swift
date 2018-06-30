//
//  MinMax.swift
//  Genki
//
//  Created by acb on 30/06/2018.
//  Copyright © 2018 Kineticfactory. All rights reserved.
//

import Foundation

struct MinMaxBucket<Element>: SubsamplingBucket where Element: Comparable {
    var min: Element
    var max: Element
    
    init(_ initial: Element) {
        self.min = initial
        self.max = initial
    }
    
    mutating func add(_ value: Element) {
        if value<self.min { self.min = value }
        if value>self.max { self.max = value }
    }
}
