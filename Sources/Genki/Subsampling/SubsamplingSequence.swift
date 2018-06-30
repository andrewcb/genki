//
//  SubsamplingSequence.swift
//  Genki
//
//  Created by acb on 30/06/2018.
//

import Foundation

protocol SubsamplingBucket {
    associatedtype Element
    
    init(_ initial: Element)
    mutating func add(_ value: Element)
}

struct SubsamplingSequence<S: Sequence, B>: Sequence where B.Element == S.Element, B: SubsamplingBucket {
    
    typealias Element = B
    
    var source: S
    let span: Int
    
    struct Iterator: IteratorProtocol {
        typealias Element = B
        
        var source: S.Iterator
        let span: Int
        
        init( source: S.Iterator, span: Int) {
            self.source = source
            self.span = span
        }
        
        mutating func next() -> B? {
            guard let first = source.next() else { return nil }
            var bucket = B(first)
            for _ in 1..<self.span {
                guard let v = source.next() else { break }
                bucket.add(v)
            }
            return bucket
        }
    }
    
    init(source: S, span: Int) {
        self.source = source
        self.span = span
    }
    
    func makeIterator() -> SubsamplingSequence<S, B>.Iterator {
        return Iterator(source: self.source.makeIterator(), span: self.span)
    }
}



