//
//  SubsamplingSequence.swift
//  Genki
//
//  Created by acb on 30/06/2018.
//

import Foundation

public protocol SubsamplingBucket {
    associatedtype Element
    
    /** Called to initialise the bucket with its first value. */
    init(_ initial: Element)
    /** Called to add a subsequent bucket */
    mutating func add(_ value: Element)
    /** Called after adding all values; any code to finalise the result value should be here */
    mutating func finalize()
}

extension SubsamplingBucket {
    // default implementation
    public mutating func finalize() { }
}

public struct SubsamplingSequence<S: Sequence, B>: Sequence where B.Element == S.Element, B: SubsamplingBucket {
    
    public typealias Element = B
    
    var source: S
    let span: Int
    
    public struct Iterator: IteratorProtocol {
        public typealias Element = B
        
        var source: S.Iterator
        let span: Int
        
        init( source: S.Iterator, span: Int) {
            self.source = source
            self.span = span
        }
        
        public mutating func next() -> B? {
            guard let first = source.next() else { return nil }
            var bucket = B(first)
            for _ in 1..<self.span {
                guard let v = source.next() else { break }
                bucket.add(v)
            }
            bucket.finalize()
            return bucket
        }
    }
    
    public init(source: S, span: Int) {
        self.source = source
        self.span = span
    }
    
    public func makeIterator() -> SubsamplingSequence<S, B>.Iterator {
        return Iterator(source: self.source.makeIterator(), span: self.span)
    }
}



