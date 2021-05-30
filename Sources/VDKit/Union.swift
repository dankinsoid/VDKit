//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.05.2021.
//

import Foundation

@dynamicMemberLookup
public enum Union<A, B> {
	case lhs(A), rhs(B)
	
	public var erased: Any {
		switch self {
		case .lhs(let a): return a
		case .rhs(let b): return b
		}
	}
	
	public init(_ a: A) { self = .lhs(a) }
	public init(_ b: B) { self = .rhs(b) }
	
	public var lhs: A? { if case .lhs(let a) = self { return a } else { return nil } }
	public var rhs: B? { if case .rhs(let b) = self { return b } else { return nil } }
	
	public func `as`(_ type: A.Type) -> A? { lhs }
	public func `as`(_ type: B.Type) -> B? { rhs }
	
	public func `is`(_ type: A.Type) -> Bool { if case .lhs = self { return true } else { return false } }
	public func `is`(_ type: B.Type) -> Bool { if case .rhs = self { return true } else { return false } }
	
	public subscript<T>(dynamicMember keyPath: KeyPath<A, T>) -> Union<T, B> {
		switch self {
		case .lhs(let a): return .lhs(a[keyPath: keyPath])
		case .rhs(let b): return .rhs(b)
		}
	}
	
	public subscript<T>(dynamicMember keyPath: KeyPath<B, T>) -> Union<A, T> {
		switch self {
		case .lhs(let a): return .lhs(a)
		case .rhs(let b): return .rhs(b[keyPath: keyPath])
		}
	}
}

extension Union: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .lhs(let l): return "\(l)"
		case .rhs(let r): return "\(r)"
		}
	}
}

extension Union: Equatable where A: Equatable, B: Equatable {}
extension Union: Hashable where A: Hashable, B: Hashable {}

public func ~=<A: Equatable, B>(_ lhs: A, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.lhs
}

public func ~=<A, B: Equatable>(_ lhs: B, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.rhs
}


public func ?? <A, B>(_ lhs: Union<A, B>, _ rhs: A) -> A {
	lhs.lhs ?? rhs
}

public func ?? <A, B>(_ lhs: Union<A, B>, _ rhs: B) -> B {
	lhs.rhs ?? rhs
}

public func ?? <A, B>(_ lhs: Union<A?, B>, _ rhs: A) -> A {
	(lhs.lhs ?? rhs) ?? rhs
}

public func ?? <A, B>(_ lhs: Union<A, B?>, _ rhs: B) -> B {
	(lhs.rhs ?? rhs) ?? rhs
}


public func ==<A: Equatable, B>(_ lhs: Union<A, B>, _ rhs: A) -> Bool {
	lhs.lhs == rhs
}

public func ==<A: Equatable, B>(_ lhs: A, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.lhs
}

public func !=<A: Equatable, B>(_ lhs: Union<A, B>, _ rhs: A) -> Bool {
	lhs.lhs != rhs
}

public func !=<A: Equatable, B>(_ lhs: A, _ rhs: Union<A, B>) -> Bool {
	lhs != rhs.lhs
}

public func ==<A: Equatable, B>(_ lhs: Union<A, B>, _ rhs: A?) -> Bool {
	lhs.lhs == rhs
}

public func ==<A: Equatable, B>(_ lhs: A?, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.lhs
}

public func !=<A: Equatable, B>(_ lhs: Union<A, B>, _ rhs: A?) -> Bool {
	lhs.lhs != rhs
}

public func !=<A: Equatable, B>(_ lhs: A?, _ rhs: Union<A, B>) -> Bool {
	lhs != rhs.lhs
}


public func ==<A, B: Equatable>(_ lhs: Union<A, B>, _ rhs: B) -> Bool {
	lhs.rhs == rhs
}

public func ==<A, B: Equatable>(_ lhs: B, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.rhs
}

public func !=<A, B: Equatable>(_ lhs: Union<A, B>, _ rhs: B) -> Bool {
	lhs.rhs != rhs
}

public func !=<A, B: Equatable>(_ lhs: B, _ rhs: Union<A, B>) -> Bool {
	lhs != rhs.rhs
}

public func ==<A, B: Equatable>(_ lhs: Union<A, B>, _ rhs: B?) -> Bool {
	lhs.rhs == rhs
}

public func ==<A, B: Equatable>(_ lhs: B?, _ rhs: Union<A, B>) -> Bool {
	lhs == rhs.rhs
}

public func !=<A, B: Equatable>(_ lhs: Union<A, B>, _ rhs: B?) -> Bool {
	lhs.rhs != rhs
}

public func !=<A, B: Equatable>(_ lhs: B?, _ rhs: Union<A, B>) -> Bool {
	lhs != rhs.rhs
}

extension Union: Decodable where A: Decodable, B: Decodable {
	
	public init(from decoder: Decoder) throws {
		do {
			let a = try A(from: decoder)
			self = .lhs(a)
		} catch {
			self = try .rhs(B(from: decoder))
		}
	}
}

extension Union: Encodable where A: Encodable, B: Encodable {
	
	public func encode(to encoder: Encoder) throws {
		switch self {
		case .lhs(let a):
			try a.encode(to: encoder)
		case .rhs(let b):
			try b.encode(to: encoder)
		}
	}
}

postfix operator |

public postfix func |<A, B>(_ lhs: A) -> Union<A, B> {
	Union(lhs)
}

public postfix func |<A, B>(_ lhs: B) -> Union<A, B> {
	Union(lhs)
}
