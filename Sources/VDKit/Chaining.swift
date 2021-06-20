//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation

public protocol Chaining {
	associatedtype Value
	var apply: (Value) -> Value { get set }
	mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P)
}

extension Chaining {
	
	public mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P) {}
	
	public func `do`(_ action: @escaping (inout Value) -> Void) -> Self {
		var result = self
		result.apply = {[apply] in
			var result = apply($0)
			action(&result)
			return result
		}
		return result
	}
}

public protocol ValueChainingProtocol: Chaining {
	var value: Value { get }
}

extension ValueChainingProtocol {
	@discardableResult
	public func apply() -> Value {
		apply(value)
	}
}

extension ValueChainingProtocol {
	public func `do`(_ action: @escaping (Value) -> Void) -> Self {
		let new = apply()
		action(new)
		return self
	}
}

@dynamicMemberLookup
public struct TypeChain<Value>: Chaining {
	
	public init() {}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Self, A> {
		ChainProperty(self, getter: keyPath)
	}

//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> ChainProperty<Self, A> {
//		ChainProperty<Self, A, WritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, A>) -> ChainProperty<Self, A> {
//		ChainProperty<Self, A, ReferenceWritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
	
	public var apply: (Value) -> Value = { $0 }
}

@dynamicMemberLookup
public struct Chain<Value>: ValueChainingProtocol {
	public var value: Value
	
	public init(_ value: Value) {
		self.value = value
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Self, A> {
		ChainProperty(self, getter: keyPath)
	}
	
	public var apply: (Value) -> Value = { $0 }
}

@dynamicMemberLookup
public struct ChainProperty<Base: Chaining, Value> {
	public let chaining: Base
	public let getter: KeyPath<Base.Value, Value>
	
	public init(_ value: Base, getter: KeyPath<Base.Value, Value>) {
		chaining = value
		self.getter = getter
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Base, A> {
		ChainProperty<Base, A>(chaining, getter: getter.appending(path: keyPath))
	}
	
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<B, A>) -> ChainProperty<C, A> {
//		ChainProperty<C, A>(chaining, getter: getter.append(reference: keyPath))
//	}
//
}

//extension ChainProperty where G: WritableKeyPath<C.Value, B> {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B, A>) -> ChainProperty<C, A, WritableKeyPath<C.Value, A>> {
//		ChainProperty<C, A, WritableKeyPath<C.Value, A>>(chaining, getter: getter.append(keyPath))
//	}
//
//}
//

extension ChainProperty where Value: OptionalProtocol {

	public subscript<A>(dynamicMember keyPath: KeyPath<Value.Wrapped, A>) -> ChainProperty<Base, A?> {
		ChainProperty<Base, A?>(chaining, getter: getter.appending(path: \.okp[keyPath]))
	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<G.B.Wrapped, A>) -> ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>>(chaining, getter: getter.append(reference: \.okp[ref: keyPath]))
//	}
//
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value.Wrapped, A?>) -> ChainProperty<Base, A?> {
		ChainProperty<Base, A?>(chaining, getter: getter.appending(path: \.okp[wro: keyPath]))
	}
//
}
//
//extension ChainProperty where G: WritableKeyPath<C.Value, B>, G.B: OptionalProtocol {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A>) -> ChainProperty<C, A?, WritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, WritableKeyPath<C.Value, A?>>(chaining, getter: getter.append(\.okp[wr: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A?>) -> ChainProperty<C, A?, WritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, WritableKeyPath<C.Value, A?>>(chaining, getter: getter.append(\.okp[wro: keyPath]))
//	}
//
//}

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


extension ChainProperty {

	public func apply(for value: Base.Value) -> Base.Value {
		chaining.apply(value)
	}
	
	public func callAsFunction(_ value: Value) -> Base {
		self[value]
	}
	
	public subscript(_ value: Value) -> Base {
		guard let kp = getter as? WritableKeyPath<Base.Value, Value> else { return chaining }
		var result = chaining
		result.onGetProperty(kp, value)
		result.apply = {[chaining] in
			var result = chaining.apply($0)
			result[keyPath: kp] = value
			return result
		}
		return chaining
	}
}

extension ChainProperty where Base: ValueChainingProtocol {
	
	public func apply() -> Base.Value {
		chaining.apply()
	}
	
	public func callAsFunction(apply value: Value) -> Base.Value {
		self[value].apply()
	}
}

extension NSObjectProtocol {
	public static var chain: TypeChain<Self> { TypeChain() }
	public var chain: Chain<Self> { Chain(self) }
	
	public func apply<C: Chaining>(_ chain: C) -> Self where C.Value == Self {
		chain.apply(self)
	}
}

extension KeyPath {
	
	public subscript(_ value: Value) -> TypeChain<Root> {
		TypeChain()[dynamicMember: self][value]
	}
}

extension OptionalProtocol {
	fileprivate var okp: OKP<Wrapped> {
		get { OKP(optional: asOptional()) }
		set { self = .init(newValue.optional) }
	}
}

private struct OKP<A> {
	var optional: A?
	
	subscript<B>(_ keyPath: KeyPath<A, B>) -> B? {
		optional?[keyPath: keyPath]
	}
	
	subscript<B>(wr keyPath: WritableKeyPath<A, B>) -> B? {
		get { optional?[keyPath: keyPath] }
		set {
			if let value = newValue {
				optional?[keyPath: keyPath] = value
			}
		}
	}
	
	subscript<B>(wro keyPath: WritableKeyPath<A, B?>) -> B? {
		get { optional?[keyPath: keyPath] }
		set {
			if let value = newValue {
				optional?[keyPath: keyPath] = value
			} else {
				optional?[keyPath: keyPath] = .none
			}
		}
	}
	
	subscript<B>(ref keyPath: ReferenceWritableKeyPath<A, B>) -> B? {
		get { optional?[keyPath: keyPath] }
		nonmutating set {
			if let value = newValue {
				optional?[keyPath: keyPath] = value
			}
		}
	}
	
	subscript<B>(refo keyPath: ReferenceWritableKeyPath<A, B?>) -> B? {
		get { optional?[keyPath: keyPath] }
		nonmutating set {
			if let value = newValue {
				optional?[keyPath: keyPath] = value
			} else {
				optional?[keyPath: keyPath] = .none
			}
		}
	}
	
}

//postfix operator ~?
//
//public postfix func ~?<C: Chaining, B: GetterProtocol, T>(_ lhs: ChainProperty<C, T?, B>) -> OptionalChaining<C, B, T> where B.B == T? {
//	OptionalChaining(chaining: lhs)
//}
//
//@dynamicMemberLookup
//public struct OptionalChaining<C: Chaining, G: GetterProtocol, T> where G.B == T?, C.Value == G.A {
//	public let chaining: ChainProperty<C, T?, G>
//}
//
//extension OptionalChaining where G: KeyPath<C.Value, T?> {
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<T, A>) -> ChainProperty<C, A?, KeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, KeyPath<C.Value, A?>>(chaining.chaining, getter: chaining.getter.appending(path: \.okp[keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<T, A>) -> ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>>(chaining.chaining, getter: chaining.getter.append(reference: \.okp[ref: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<G.B.Wrapped, A?>) -> ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, ReferenceWritableKeyPath<C.Value, A?>>(chaining.chaining, getter: chaining.getter.append(reference: \.okp[refo: keyPath]))
//	}
//
//}
//
//extension OptionalChaining where G: WritableKeyPath<C.Value, T?> {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<T, A>) -> ChainProperty<C, A?, WritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, WritableKeyPath<C.Value, A?>>(chaining.chaining, getter: chaining.getter.append(\.okp[wr: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A?>) -> ChainProperty<C, A?, WritableKeyPath<C.Value, A?>> {
//		ChainProperty<C, A?, WritableKeyPath<C.Value, A?>>(chaining.chaining, getter: chaining.getter.append(\.okp[wro: keyPath]))
//	}
//
//}
