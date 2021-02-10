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
	
	public subscript<A>(dynamicMember keyPath: KeyPath<W, A>) -> ChainingProperty<Self, A, KeyPath<W, A>> {
		ChainingProperty<Self, A, KeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Self, A, WritableKeyPath<W, A>> {
		ChainingProperty<Self, A, WritableKeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<Self, A, ReferenceWritableKeyPath<W, A>> {
		ChainingProperty<Self, A, ReferenceWritableKeyPath<W, A>>(self, getter: keyPath)
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
	
	public subscript<A>(dynamicMember keyPath: KeyPath<W, A>) -> ChainingProperty<Self, A, KeyPath<W, A>> {
		ChainingProperty<Self, A, KeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Self, A, WritableKeyPath<W, A>> {
		ChainingProperty<Self, A, WritableKeyPath<W, A>>(self, getter: keyPath)
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<Self, A, ReferenceWritableKeyPath<W, A>> {
		ChainingProperty<Self, A, ReferenceWritableKeyPath<W, A>>(self, getter: keyPath)
	}
	
	public func copy(with action: @escaping (W) -> W) -> ValueChaining<W> {
		var result = ValueChaining(wrappedValue)
		result.action = action
		return result
	}
	
}

public protocol GetterProtocol {
	associatedtype A
	associatedtype B
	var get: (A) -> B { get }
}

public protocol SetterProtocol: GetterProtocol {
	var set: (A, B) -> A { get }
}

public struct Getter<A, B>: GetterProtocol {
	public let get: (A) -> B
}

public struct Setter<A, B>: SetterProtocol {
	public let get: (A) -> B
	public let set: (A, B) -> A
}

extension KeyPath: GetterProtocol {
	public var get: (Root) -> Value {
		{ $0[keyPath: self] }
	}
}

extension WritableKeyPath: SetterProtocol {
	public var set: (Root, Value) -> Root {
		{
			var result = $0
			result[keyPath: self] = $1
			return result
		}
	}
}

@dynamicMemberLookup
public struct ChainingProperty<C: Chaining, B, G: GetterProtocol> where G.A == C.W, G.B == B {
	public let chaining: C
	public let getter: G
	
	public init(_ value: C, getter: G) {
		chaining = value
		self.getter = getter
	}

}

extension ChainingProperty where G: KeyPath<C.W, B> {
	
	public subscript<A>(dynamicMember keyPath: KeyPath<G.B, A>) -> ChainingProperty<C, A, KeyPath<C.W, A>> {
		ChainingProperty<C, A, KeyPath<C.W, A>>(chaining, getter: getter.appending(path: keyPath))
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<G.B, A>) -> ChainingProperty<C, A, ReferenceWritableKeyPath<C.W, A>> {
		ChainingProperty<C, A, ReferenceWritableKeyPath<C.W, A>>(chaining, getter: getter.append(reference: keyPath))
	}
	
}


extension ChainingProperty where G: WritableKeyPath<C.W, B> {
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B, A>) -> ChainingProperty<C, A, WritableKeyPath<C.W, A>> {
		ChainingProperty<C, A, WritableKeyPath<C.W, A>>(chaining, getter: getter.append(keyPath))
	}
	
}

extension KeyPath {
	func append<A>(reference: ReferenceWritableKeyPath<Value, A>) -> ReferenceWritableKeyPath<Root, A> {
		appending(path: reference)
	}
}

extension WritableKeyPath {
	func append<A>(_ path: WritableKeyPath<Value, A>) -> WritableKeyPath<Root, A> {
		appending(path: path)
	}
}

extension ChainingProperty where G: SetterProtocol {
	
	public subscript(_ value: G.B) -> C {
		chaining.copy {
			getter.set(chaining.action($0), value)
		}
	}
	
}

extension ChainingProperty where C: ValueChainingProtocol, G: SetterProtocol {
	
	public subscript(_ value: G.B) -> C.W {
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
