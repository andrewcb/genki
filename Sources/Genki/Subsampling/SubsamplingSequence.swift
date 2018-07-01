//
//  SubsamplingSequence.swift
//  Genki
//
//  Created by acb on 30/06/2018.
//

import Foundation

public protocol SubsamplingBucket {
    associatedtype Element
    
    init(_ initial: Element)
    mutating func add(_ value: Element)
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



