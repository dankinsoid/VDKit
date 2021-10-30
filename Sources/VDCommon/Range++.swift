//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation

infix operator ±

public func ±<T: AdditiveArithmetic & Comparable>(_ lhs: T, _ rhs: T) -> ClosedRange<T> {
    let left = lhs - rhs
    let right = lhs + rhs
    return min(left, right)...max(left, right)
}

public protocol LowerRangeExpression: RangeExpression {
    var lowerBound: Bound { get }
}

public protocol UpperRangeExpression: RangeExpression {
    var upperBound: Bound { get }
}

public typealias FullRangeExpression = LowerRangeExpression & UpperRangeExpression

extension Range: FullRangeExpression {}
extension ClosedRange: FullRangeExpression {}
extension PartialRangeFrom: LowerRangeExpression {}
extension PartialRangeThrough: UpperRangeExpression {}
extension PartialRangeUpTo: UpperRangeExpression {}

public protocol MappableRangeExpression: RangeExpression {
    func map(_ mapping: (Bound) -> Bound) -> Self
}

extension Range: MappableRangeExpression {
    public func map(_ mapping: (Bound) -> Bound) -> Range<Bound> {
        mapping(lowerBound)..<mapping(upperBound)
    }
}

extension ClosedRange: MappableRangeExpression {
    public func map(_ mapping: (Bound) -> Bound) -> ClosedRange<Bound> {
        mapping(lowerBound)...mapping(upperBound)
    }
}

extension PartialRangeFrom: MappableRangeExpression {
    public func map(_ mapping: (Bound) -> Bound) -> PartialRangeFrom<Bound> {
        mapping(lowerBound)...
    }
}

extension PartialRangeThrough: MappableRangeExpression {
    public func map(_ mapping: (Bound) -> Bound) -> PartialRangeThrough<Bound> {
        ...mapping(upperBound)
    }
}

extension PartialRangeUpTo: MappableRangeExpression {
    public func map(_ mapping: (Bound) -> Bound) -> PartialRangeUpTo<Bound> {
        ..<mapping(upperBound)
    }
}

public func +<R: MappableRangeExpression>(_ lhs: R, _ rhs: R.Bound) -> R where R.Bound: AdditiveArithmetic {
    lhs.map { $0 + rhs }
}

public func +<R: MappableRangeExpression>(_ lhs: R.Bound, _ rhs: R) -> R where R.Bound: AdditiveArithmetic {
    rhs.map { lhs + $0 }
}

public func -<R: MappableRangeExpression>(_ lhs: R, _ rhs: R.Bound) -> R where R.Bound: AdditiveArithmetic {
    lhs.map { $0 - rhs }
}

public func -<R: MappableRangeExpression>(_ lhs: R.Bound, _ rhs: R) -> R where R.Bound: AdditiveArithmetic {
    rhs.map { lhs - $0 }
}

extension RangeExpression where Bound == Int {
	
	public func convert<C: Collection>(for data: C) -> Range<C.Index> {
		let range = relative(to: IntIndex(collection: data))
		let start = data.index(data.startIndex, offsetBy: range.lowerBound)
		let end = data.index(data.startIndex, offsetBy: range.upperBound)
		return start..<end
	}
}

private struct IntIndex<C: Collection>: Collection {
	typealias Index = Int
	typealias Element = C.Element
	
	var collection: C
	var startIndex: Int { 0 }
	var endIndex: Int { collection.count }
	
	subscript(position: Int) -> C.Element {
		collection[collection.index(collection.startIndex, offsetBy: position)]
	}
	
	func index(after i: Int) -> Int {
		i + 1
	}
}
