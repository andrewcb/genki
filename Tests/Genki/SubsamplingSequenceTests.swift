//
//  SubsamplingSequenceTests.swift
//  GenkiTests
//
//  Created by acb on 30/06/2018.
//  Copyright © 2018 Kineticfactory. All rights reserved.
//

import XCTest
@testable import Genki

class SubsamplingSequenceTests: XCTestCase {

    func testIntMinMax() {
        let s = [3,1,2,6,9,-3,4,7,1]
        let r = SubsamplingSequence<[Int],MinMaxBucket<Int>>(source: s, span:2).map { ($0.min, $0.max) }

        // uncomment this line and delete the following two once running on a Swift that propagates Equatability to lists of tuples
//        XCTAssertEqual(r, [(1,3),(2,6), (-3,9), (4,7), (1,1)])
        XCTAssertEqual(r.map {$0.0}, [1,2,-3,4,1])
        XCTAssertEqual(r.map {$0.1}, [3,6,9,7,1])
    }
    
    func testFloatMean() {
        let s = [2.0, 3.0, 6.0, 4.0]
        let r = SubsamplingSequence<[Double],MeanBucket<Double>>(source: s, span: 2).map { $0.mean }
        XCTAssertEqual(r, [2.5, 5.0])
    }

    func testHandleFinalize() {
        struct TestBucket: SubsamplingBucket {
            var values: [Int]
            init(_ initial: Int) {
                self.values = [initial]
            }
            mutating func add(_ value: Int) {
                self.values.append(value)
            }
            mutating func finalize() {
                self.values.sort()
            }
        }
        
        let s = [3,1,4,6,8,2,9,5,1]
        let r = SubsamplingSequence<[Int], TestBucket>(source:s, span:3).map { $0.values }
        XCTAssertEqual(r, [[1,3,4],[2,6,8],[1,5,9]])
    }
}
