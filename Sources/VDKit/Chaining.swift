//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation

public protocol Chaining {
	associatedtype W
	var action: (W) -> W { get }
	func copy(with action: @escaping (W) -> W) -> Self
}

extension Chaining where W: AnyObject {
	
	public func with(_ action: @escaping (W) -> Void) -> Self {
		copy {
			action($0)
			return $0
		}
	}
	
}

public protocol ValueChainingProtocol: Chaining {
	var wrappedValue: W { get }
	func apply() -> W
}

extension ValueChainingProtocol {
	@discardableResult
	public func apply() -> W {
		action(wrappedValue)
	}
}

@dynamicMemberLookup
public struct TypeChaining<W>: Chaining {
	public private(set) var action: (W) -> W
	
	public init() {
		self.action = { $0 }
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Self, A> {
		ChainingProperty<Self, A>(self, keyPath: keyPath)
	}
	
	public func apply(for values: W...) {
		apply(for: values)
	}
	
	public func apply(for values: [W]) {
		values.forEach { _ = action($0) }
	}
	
	public func copy(with action: @escaping (W) -> W) -> TypeChaining<W> {
		var result = TypeChaining()
		result.action = action
		return result
	}
	
}

@dynamicMemberLookup
public struct ValueChaining<W>: ValueChainingProtocol {
	public let wrappedValue: W
	public private(set) var action: (W) -> W = { $0 }
	
	public init(_ value: W) {
		wrappedValue = value
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Self, A> {
		ChainingProperty<Self, A>(self, keyPath: keyPath)
	}
	
	public func copy(with action: @escaping (W) -> W) -> ValueChaining<W> {
		var result = ValueChaining(wrappedValue)
		result.action = action
		return result
	}
	
}

@dynamicMemberLookup
public struct ChainingProperty<C: Chaining, P> {
	public let chaining: C
	private let setter: (C.W, P) -> C.W
	private let getter: (C.W) -> P
	
	public init(_ value: C, setter: @escaping (C.W, P) -> C.W,  getter: @escaping (C.W) -> P) {
		chaining = value
		self.setter = setter
		self.getter = getter
	}
	
	public init(_ value: C, keyPath: WritableKeyPath<C.W, P>) {
		chaining = value
		self.setter = {
			var result = $0
			result[keyPath: keyPath] = $1
			return result
		}
		self.getter = {
			$0[keyPath: keyPath]
		}
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<P, A>) -> ChainingProperty<C, A> {
		ChainingProperty<C, A>(chaining, setter: {
			var value = getter($0)
			value[keyPath: keyPath] = $1
			return setter($0, value)
		}, getter: {
			getter($0)[keyPath: keyPath]
		}
		)
	}
	
	public subscript(_ value: P) -> C {
		chaining.copy {
			setter(chaining.action($0), value)
		}
	}
	
}

extension ChainingProperty where C: ValueChainingProtocol {
	
	public subscript(_ value: P) -> C.W {
		self[value].apply()
	}
	
}

extension NSObjectProtocol {
	public static var chain: TypeChaining<Self> { TypeChaining() }
	public var chain: ValueChaining<Self> { ValueChaining(self) }
	
	public func apply(_ chain: TypeChaining<Self>) -> Self {
		chain.apply(for: self)
		return self
	}
	
}
