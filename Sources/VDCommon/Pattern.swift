//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.05.2021.
//

import Foundation

public struct Pattern<Value> {
	public let closure: (Value) -> Bool
	
	public init(_ closure: @escaping (Value) -> Bool) {
		self.closure = closure
	}
	
	public static func ||(_ lhs: Pattern, _ rhs: Pattern) -> Pattern {
		Pattern { lhs.closure($0) || rhs.closure($0) }
	}
	
	public static func &&(_ lhs: Pattern, _ rhs: Pattern) -> Pattern {
		Pattern { lhs.closure($0) || rhs.closure($0) }
	}
}

public extension Pattern where Value: Hashable {
	static func any(of candidates: Set<Value>) -> Pattern {
		Pattern { candidates.contains($0) }
	}
}

public func ~=<T>(lhs: Pattern<T>, rhs: T) -> Bool {
	lhs.closure(rhs)
}

public extension Pattern where Value: Comparable {
	
	static func lessThan(_ value: Value) -> Pattern {
		Pattern { $0 < value }
	}
	
	static func greaterThan(_ value: Value) -> Pattern {
		Pattern { $0 > value }
	}
}

public func ~=<T>(lhs: KeyPath<T, Bool>, rhs: T) -> Bool {
	rhs[keyPath: lhs]
}

public func ==<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] == rhs }
}

public func ===<T, V: AnyObject>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] === rhs }
}

public func !==<T, V: AnyObject>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] !== rhs }
}

public func !=<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] != rhs }
}

public func < <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] < rhs }
}

public func <= <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] <= rhs }
}

public func > <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] > rhs }
}

public func >= <T, V: Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Pattern<T> {
	Pattern { $0[keyPath: lhs] >= rhs }
}

public prefix func !<T>(_ rhs: Pattern<T>) -> Pattern<T> {
	Pattern { !rhs.closure($0) }
}

public func ~=<T, R: RangeExpression>(lhs: KeyPath<T, R.Bound>, rhs: R) -> Pattern<T> {
	Pattern { rhs.contains($0[keyPath: lhs]) }
}

public func ~=<T, V>(lhs: KeyPath<T, V>, rhs: @escaping (V) -> Bool) -> Pattern<T> {
	Pattern { rhs($0[keyPath: lhs]) }
}

public func ~=<T, V: Hashable>(lhs: KeyPath<T, V>, rhs: Set<V>) -> Pattern<T> {
	Pattern { rhs.contains($0[keyPath: lhs]) }
}
