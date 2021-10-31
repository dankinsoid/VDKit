//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation
import VDOptional

public protocol Chaining {
	associatedtype Value
	var apply: (inout Value) -> Void { get set }
	mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P)
}

extension Chaining {
	
	public mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P) {}
	
	public func `do`(_ action: @escaping (inout Value) -> Void) -> Self {
		var result = self
		result.apply = {[apply] result in
			apply(&result)
			action(&result)
		}
		return result
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Self, A> {
		ChainProperty(self, getter: keyPath)
	}
}

public protocol ValueChainingProtocol: Chaining {
	var value: Value { get }
}

extension ValueChainingProtocol {
	@discardableResult
	public func apply() -> Value {
		var result = value
		apply(&result)
		return result
	}
	
	public func modifier(_ chain: TypeChain<Value>) -> Self {
		self.do(chain.apply)
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

	public var apply: (inout Value) -> Void = {_ in }
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
	
	public var apply: (inout Value) -> Void = {_ in }
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
}

extension ChainProperty where Value: OptionalProtocol {

	public subscript<A>(dynamicMember keyPath: KeyPath<Value.Wrapped, A>) -> ChainProperty<Base, A?> {
		ChainProperty<Base, A?>(chaining, getter: getter.appending(path: \.okp[keyPath]))
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value.Wrapped, A?>) -> ChainProperty<Base, A?> {
		ChainProperty<Base, A?>(chaining, getter: getter.appending(path: \.okp[wro: keyPath]))
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

extension ChainProperty {

	public func apply(for value: inout Base.Value) {
		chaining.apply(&value)
	}
	
	public func callAsFunction(_ value: Value) -> Base {
		guard let kp = getter as? WritableKeyPath<Base.Value, Value> else { return chaining }
		var result = chaining
		result.onGetProperty(kp, value)
		result.apply = {[chaining] result in
			chaining.apply(&result)
			result[keyPath: kp] = value
		}
		return result
	}
	
	@available(*, deprecated, message: "Use (...) instead")
	public subscript(_ value: Value) -> Base {
		callAsFunction(value)
	}
}

extension ChainProperty where Base: ValueChainingProtocol {
	
	public func apply() -> Base.Value {
		chaining.apply()
	}
	
	public func callAsFunction(apply value: Value) -> Base.Value {
		callAsFunction(value).apply()
	}
}

extension NSObjectProtocol {
	public static var chain: TypeChain<Self> { TypeChain() }
	public var chain: Chain<Self> { Chain(self) }
	
	public func apply<C: Chaining>(_ chain: C) -> Self where C.Value == Self {
		var result = self
		chain.apply(&result)
		return result
	}
}

extension KeyPath {
	
	public func callAsFunction(_ value: Value) -> TypeChain<Root> {
		TypeChain()[dynamicMember: self](value)
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

postfix operator ~

public postfix func ~<T>(_ lhs: T) -> Chain<T> { Chain(lhs) }

//public protocol Chaining {
//	associatedtype Value
//	var apply: (inout Value) -> Void { get set }
//	mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P)
//}
//
//extension Chaining {
//
//	public mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<Value, P>, _ value: P) {}
//
//	public func `do`(_ action: @escaping (inout Value) -> Void) -> Self {
//		var result = self
//		result.apply = {[apply] result in
//			apply(&result)
//			action(&result)
//		}
//		return result
//	}
//}
//
//public protocol ValueChainingProtocol: Chaining {
//	var value: Value { get }
//}
//
//extension ValueChainingProtocol {
//	@discardableResult
//	public func apply() -> Value {
//		var result = value
//		apply(&result)
//		return result
//	}
//
//	public func modifier(_ chain: TypeChain<Value>) -> Self {
//		self.do(chain.apply)
//			}
//
//}
//
//extension ValueChainingProtocol {
//	public func `do`(_ action: @escaping (Value) -> Void) -> Self {
//		let new = apply()
//		action(new)
//		return self
//	}
//}
//
//@dynamicMemberLookup
//public struct TypeChain<Value>: Chaining {
//	public var apply: (inout Value) -> Void = {_ in }
//	public init() {}
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Self, A, KeyPath<Value, A>> {
//		ChainProperty(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> ChainProperty<Self, A, WritableKeyPath<Value, A>> {
//		ChainProperty<Self, A, WritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, A>) -> ChainProperty<Self, A, ReferenceWritableKeyPath<Value, A>> {
//		ChainProperty<Self, A, ReferenceWritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
//}
//
//@dynamicMemberLookup
//public struct Chain<Value>: ValueChainingProtocol {
//	public var value: Value
//	public var apply: (inout Value) -> Void = {_ in }
//
//	public init(_ value: Value) {
//		self.value = value
//	}
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Self, A, KeyPath<Value, A>> {
//		ChainProperty(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> ChainProperty<Self, A, WritableKeyPath<Value, A>> {
//		ChainProperty<Self, A, WritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, A>) -> ChainProperty<Self, A, ReferenceWritableKeyPath<Value, A>> {
//		ChainProperty<Self, A, ReferenceWritableKeyPath<Value, A>>(self, getter: keyPath)
//	}
//}
//
//@dynamicMemberLookup
//public struct ChainProperty<Base: Chaining, Value, KP: KeyPath<Base.Value, Value>> {
//	public let chaining: Base
//	public let getter: KP
//
//	public init(_ value: Base, getter: KP) {
//		chaining = value
//		self.getter = getter
//	}
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<Value, A>) -> ChainProperty<Base, A, KeyPath<Base.Value, A>> {
//		ChainProperty<Base, A, KeyPath<Base.Value, A>>(chaining, getter: getter.appending(path: keyPath))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, A>) -> ChainProperty<Base, A, ReferenceWritableKeyPath<Base.Value, A>> {
//		ChainProperty<Base, A, ReferenceWritableKeyPath<Base.Value, A>>(chaining, getter: getter.append(reference: keyPath))
//	}
//}
//
//extension ChainProperty where KP: WritableKeyPath<Base.Value, Value> {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> ChainProperty<Base, A, WritableKeyPath<Base.Value, A>> {
//		ChainProperty<Base, A, WritableKeyPath<Base.Value, A>>(chaining, getter: getter.append(keyPath))
//	}
//}
//
//extension ChainProperty where Value: OptionalProtocol {
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<Value.Wrapped, A>) -> ChainProperty<Base, A?, KeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, KeyPath<Base.Value, A?>>(chaining, getter: getter.appending(path: \.okp[keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value.Wrapped, A>) -> ChainProperty<Base, A?, ReferenceWritableKeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, ReferenceWritableKeyPath<Base.Value, A?>>(chaining, getter: getter.append(reference: \.okp[ref: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<Value.Wrapped, A?>) -> ChainProperty<Base, A?, KeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, KeyPath<Base.Value, A?>>(chaining, getter: getter.appending(path: \.okp[o: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<Value.Wrapped, A?>) -> ChainProperty<Base, A?, ReferenceWritableKeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, ReferenceWritableKeyPath<Base.Value, A?>>(chaining, getter: getter.append(reference: \.okp[refo: keyPath]))
//	}
//}
//
//extension ChainProperty where KP: WritableKeyPath<Base.Value, Value>, Value: OptionalProtocol {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value.Wrapped, A>) -> ChainProperty<Base, A?, WritableKeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, WritableKeyPath<Base.Value, A?>>(chaining, getter: getter.append(\.okp[wr: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value.Wrapped, A?>) -> ChainProperty<Base, A?, WritableKeyPath<Base.Value, A?>> {
//		ChainProperty<Base, A?, WritableKeyPath<Base.Value, A?>>(chaining, getter: getter.append(\.okp[wro: keyPath]))
//	}
//}
//
//extension KeyPath {
//	func append<A>(reference: ReferenceWritableKeyPath<Value, A>) -> ReferenceWritableKeyPath<Root, A> {
//		appending(path: reference)
//	}
//}
//
//extension WritableKeyPath {
//	func append<A>(_ path: WritableKeyPath<Value, A>) -> WritableKeyPath<Root, A> {
//		appending(path: path)
//	}
//}
//
//
//extension ChainProperty {
//
//	public func apply(for value: inout Base.Value) {
//		chaining.apply(&value)
//	}
//}
//
//extension ChainProperty where KP: WritableKeyPath<Base.Value, Value> {
//
//	public func callAsFunction(_ value: Value) -> Base {
//		var result = chaining
//		result.onGetProperty(getter, value)
//		result.apply = {[chaining, getter] result in
//			chaining.apply(&result)
//			result[keyPath: getter] = value
//		}
//		return result
//	}
//
//	@available(*, deprecated, message: "Use (...) instead")
//	public subscript(_ value: Value) -> Base {
//		callAsFunction(value)
//	}
//}
//
//extension ChainProperty where Base: ValueChainingProtocol {
//
//	public func apply() -> Base.Value {
//		chaining.apply()
//	}
//}
//
//extension ChainProperty where Base: ValueChainingProtocol, KP: WritableKeyPath<Base.Value, Value> {
//
//	public func callAsFunction(apply value: Value) -> Base.Value {
//		self(value).apply()
//	}
//}
//
//extension NSObjectProtocol {
//	public static var chain: TypeChain<Self> { TypeChain() }
//	public var chain: Chain<Self> { Chain(self) }
//
//	public func apply<C: Chaining>(_ chain: C) -> Self where C.Value == Self {
//		var result = self
//		chain.apply(&result)
//		return result
//	}
//}
//
//extension WritableKeyPath {
//
//	public func callAsFunction(_ value: Value) -> TypeChain<Root> {
//		TypeChain()[dynamicMember: self](value)
//	}
//}
//
//extension OptionalProtocol {
//	fileprivate var okp: OKP<Wrapped> {
//		get { OKP(optional: asOptional()) }
//		set { self = .init(newValue.optional) }
//	}
//}
//
//private struct OKP<A> {
//	var optional: A?
//
//	subscript<B>(_ keyPath: KeyPath<A, B>) -> B? {
//		optional?[keyPath: keyPath]
//	}
//
//	subscript<B>(o keyPath: KeyPath<A, B?>) -> B? {
//		optional?[keyPath: keyPath]
//	}
//
//	subscript<B>(wr keyPath: WritableKeyPath<A, B>) -> B? {
//		get { optional?[keyPath: keyPath] }
//		set {
//			if let value = newValue {
//				optional?[keyPath: keyPath] = value
//			}
//		}
//	}
//
//	subscript<B>(wro keyPath: WritableKeyPath<A, B?>) -> B? {
//		get { optional?[keyPath: keyPath] }
//		set {
//			if let value = newValue {
//				optional?[keyPath: keyPath] = value
//			} else {
//				optional?[keyPath: keyPath] = .none
//			}
//		}
//	}
//
//	subscript<B>(ref keyPath: ReferenceWritableKeyPath<A, B>) -> B? {
//		get { optional?[keyPath: keyPath] }
//		nonmutating set {
//			if let value = newValue {
//				optional?[keyPath: keyPath] = value
//			}
//		}
//	}
//
//	subscript<B>(refo keyPath: ReferenceWritableKeyPath<A, B?>) -> B? {
//		get { optional?[keyPath: keyPath] }
//		nonmutating set {
//			if let value = newValue {
//				optional?[keyPath: keyPath] = value
//			} else {
//				optional?[keyPath: keyPath] = .none
//			}
//		}
//	}
//
//}
//
//postfix operator ~
//
//public postfix func ~<T>(_ lhs: T) -> Chain<T> { Chain(lhs) }
