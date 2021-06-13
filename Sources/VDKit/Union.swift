//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.05.2021.
//

import Foundation

@dynamicMemberLookup
public enum Union<T0, T1> {
	case lhs(T0), rhs(T1)
	
	public var erased: Any {
		switch self {
		case .lhs(let a): return a
		case .rhs(let b): return b
		}
	}
	
	public init(_ a: T0) { self = .lhs(a) }
	public init(_ b: T1) { self = .rhs(b) }
	
	public init?(erased: Any) {
		if let lhs = erased as? T0 {
			self = .lhs(lhs)
		} else if let rhs = erased as? T1 {
			self = .rhs(rhs)
		} else {
			return nil
		}
	}
	
	public var lhs: T0? { if case .lhs(let a) = self { return a } else { return nil } }
	public var rhs: T1? { if case .rhs(let b) = self { return b } else { return nil } }
	
	public func `as`(_ type: T0.Type) -> T0? { lhs }
	public func `as`(_ type: T1.Type) -> T1? { rhs }
	
	public func `is`(_ type: T0.Type) -> Bool { if case .lhs = self { return true } else { return false } }
	public func `is`(_ type: T1.Type) -> Bool { if case .rhs = self { return true } else { return false } }
	
	public subscript<T>(dynamicMember keyPath: KeyPath<T0, T>) -> Union<T, T1> {
		switch self {
		case .lhs(let a): return .lhs(a[keyPath: keyPath])
		case .rhs(let b): return .rhs(b)
		}
	}
	
	public subscript<T>(dynamicMember keyPath: KeyPath<T1, T>) -> Union<T0, T> {
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

extension Union: Equatable where T0: Equatable, T1: Equatable {}
extension Union: Hashable where T0: Hashable, T1: Hashable {}

public func ~=<T0: Equatable, T1>(_ lhs: T0, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.lhs
}

public func ~=<T0, T1: Equatable>(_ lhs: T1, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.rhs
}


public func ?? <T0, T1>(_ lhs: Union<T0, T1>, _ rhs: T0) -> T0 {
	lhs.lhs ?? rhs
}

public func ?? <T0, T1>(_ lhs: Union<T0, T1>, _ rhs: T1) -> T1 {
	lhs.rhs ?? rhs
}

public func ?? <T0, T1>(_ lhs: Union<T0?, T1>, _ rhs: T0) -> T0 {
	(lhs.lhs ?? rhs) ?? rhs
}

public func ?? <T0, T1>(_ lhs: Union<T0, T1?>, _ rhs: T1) -> T1 {
	(lhs.rhs ?? rhs) ?? rhs
}


public func ==<T0: Equatable, T1>(_ lhs: Union<T0, T1>, _ rhs: T0) -> Bool {
	lhs.lhs == rhs
}

public func ==<T0: Equatable, T1>(_ lhs: T0, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.lhs
}

public func !=<T0: Equatable, T1>(_ lhs: Union<T0, T1>, _ rhs: T0) -> Bool {
	lhs.lhs != rhs
}

public func !=<T0: Equatable, T1>(_ lhs: T0, _ rhs: Union<T0, T1>) -> Bool {
	lhs != rhs.lhs
}

public func ==<T0: Equatable, T1>(_ lhs: Union<T0, T1>, _ rhs: T0?) -> Bool {
	lhs.lhs == rhs
}

public func ==<T0: Equatable, T1>(_ lhs: T0?, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.lhs
}

public func !=<T0: Equatable, T1>(_ lhs: Union<T0, T1>, _ rhs: T0?) -> Bool {
	lhs.lhs != rhs
}

public func !=<T0: Equatable, T1>(_ lhs: T0?, _ rhs: Union<T0, T1>) -> Bool {
	lhs != rhs.lhs
}


public func ==<T0, T1: Equatable>(_ lhs: Union<T0, T1>, _ rhs: T1) -> Bool {
	lhs.rhs == rhs
}

public func ==<T0, T1: Equatable>(_ lhs: T1, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.rhs
}

public func !=<T0, T1: Equatable>(_ lhs: Union<T0, T1>, _ rhs: T1) -> Bool {
	lhs.rhs != rhs
}

public func !=<T0, T1: Equatable>(_ lhs: T1, _ rhs: Union<T0, T1>) -> Bool {
	lhs != rhs.rhs
}

public func ==<T0, T1: Equatable>(_ lhs: Union<T0, T1>, _ rhs: T1?) -> Bool {
	lhs.rhs == rhs
}

public func ==<T0, T1: Equatable>(_ lhs: T1?, _ rhs: Union<T0, T1>) -> Bool {
	lhs == rhs.rhs
}

public func !=<T0, T1: Equatable>(_ lhs: Union<T0, T1>, _ rhs: T1?) -> Bool {
	lhs.rhs != rhs
}

public func !=<T0, T1: Equatable>(_ lhs: T1?, _ rhs: Union<T0, T1>) -> Bool {
	lhs != rhs.rhs
}

extension Union: Decodable where T0: Decodable, T1: Decodable {
	
	public init(from decoder: Decoder) throws {
		do {
			let a = try T0(from: decoder)
			self = .lhs(a)
		} catch {
			self = try .rhs(T1(from: decoder))
		}
	}
}

extension Union: Encodable where T0: Encodable, T1: Encodable {
	
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

public postfix func |<T0, T1>(_ lhs: T0) -> Union<T0, T1> {
	Union(lhs)
}

public postfix func |<T0, T1>(_ lhs: T1) -> Union<T0, T1> {
	Union(lhs)
}
