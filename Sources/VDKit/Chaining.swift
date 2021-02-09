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
	private var chaining: C
	private let keyPath: WritableKeyPath<C.W, P>
	
	public init(_ value: C, keyPath: WritableKeyPath<C.W, P>) {
		chaining = value
		self.keyPath = keyPath
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<P, A>) -> ChainingProperty<C, A> {
		return ChainingProperty<C, A>(chaining, keyPath: self.keyPath.appending(path: keyPath))
	}
	
	public subscript(_ value: P) -> C {
		let prev = chaining.action
		let kp = keyPath
		return chaining.copy {
			var result = prev($0)
			result[keyPath: kp] = value
			return result
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
