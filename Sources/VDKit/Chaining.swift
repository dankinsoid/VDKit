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

public protocol TypeChainingProtocol: Chaining {
	func apply(for values: [W])
}

public protocol ValueChainingProtocol: Chaining {
	var wrappedValue: W { get set }
	func apply() -> W
}

extension ValueChainingProtocol {
	@discardableResult
	public func apply() -> W {
		action(wrappedValue)
	}
}

@dynamicMemberLookup
public struct TypeChaining<W>: TypeChainingProtocol {
	public private(set) var action: (W) -> W
	
	public init() {
		self.action = { $0 }
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<W, A>) -> ChainingProperty<Self, A> {
		ChainingProperty<Self, A>(self, getter: keyPath)
	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<W, A>) -> ChainingProperty<Self, A> {
//		ChainingProperty<Self, A, WritableKeyPath<W, A>>(self, getter: keyPath)
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<Self, A> {
//		ChainingProperty<Self, A, ReferenceWritableKeyPath<W, A>>(self, getter: keyPath)
//	}
	
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
	public var wrappedValue: W
	public private(set) var action: (W) -> W = { $0 }
	
	public init(_ value: W) {
		wrappedValue = value
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<W, A>) -> ChainingProperty<Self, A> {
		ChainingProperty<Self, A>(self, getter: keyPath)
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
public struct ChainingProperty<C: Chaining, B> {
	public let chaining: C
	public let getter: KeyPath<C.W, B>
	
	public init(_ value: C, getter: KeyPath<C.W, B>) {
		chaining = value
		self.getter = getter
	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<B, A>) -> ChainingProperty<C, A> {
		ChainingProperty<C, A>(chaining, getter: getter.appending(path: keyPath))
	}
	
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<B, A>) -> ChainingProperty<C, A> {
//		ChainingProperty<C, A>(chaining, getter: getter.append(reference: keyPath))
//	}
//
}

//extension ChainingProperty where G: WritableKeyPath<C.W, B> {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B, A>) -> ChainingProperty<C, A, WritableKeyPath<C.W, A>> {
//		ChainingProperty<C, A, WritableKeyPath<C.W, A>>(chaining, getter: getter.append(keyPath))
//	}
//
//}
//
extension ChainingProperty where B: OptionalProtocol {

	public subscript<A>(dynamicMember keyPath: KeyPath<B.Wrapped, A>) -> ChainingProperty<C, A?> {
		ChainingProperty<C, A?>(chaining, getter: getter.appending(path: \.okp[keyPath]))
	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<G.B.Wrapped, A>) -> ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>>(chaining, getter: getter.append(reference: \.okp[ref: keyPath]))
//	}
//
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<B.Wrapped, A?>) -> ChainingProperty<C, A?> {
		ChainingProperty<C, A?>(chaining, getter: getter.appending(path: \.okp[wro: keyPath]))
	}
//
}
//
//extension ChainingProperty where G: WritableKeyPath<C.W, B>, G.B: OptionalProtocol {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A>) -> ChainingProperty<C, A?, WritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, WritableKeyPath<C.W, A?>>(chaining, getter: getter.append(\.okp[wr: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A?>) -> ChainingProperty<C, A?, WritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, WritableKeyPath<C.W, A?>>(chaining, getter: getter.append(\.okp[wro: keyPath]))
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

extension ChainingProperty where C: TypeChainingProtocol {

	public subscript(_ value: B) -> C {
		chaining.copy {
			var result = chaining.action($0)
			if let kp = getter as? WritableKeyPath<C.W, B> {
				result[keyPath: kp] = value
			}
			return result
		}
	}

}

extension ChainingProperty where C: ValueChainingProtocol {

	public subscript(_ value: B) -> C {
		var new = chaining.apply()
		var chain = chaining.copy(with: { $0 })
		if let kp = getter as? WritableKeyPath<C.W, B> {
			new[keyPath: kp] = value
			chain.wrappedValue = new
		}
		return chain
	}

//	public subscript(final value: G.B) -> C.W {
//		self[value].apply()
//	}

	public func apply() -> C.W {
		chaining.apply()
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
//public postfix func ~?<C: Chaining, B: GetterProtocol, T>(_ lhs: ChainingProperty<C, T?, B>) -> OptionalChaining<C, B, T> where B.B == T? {
//	OptionalChaining(chaining: lhs)
//}
//
//@dynamicMemberLookup
//public struct OptionalChaining<C: Chaining, G: GetterProtocol, T> where G.B == T?, C.W == G.A {
//	public let chaining: ChainingProperty<C, T?, G>
//}
//
//extension OptionalChaining where G: KeyPath<C.W, T?> {
//
//	public subscript<A>(dynamicMember keyPath: KeyPath<T, A>) -> ChainingProperty<C, A?, KeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, KeyPath<C.W, A?>>(chaining.chaining, getter: chaining.getter.appending(path: \.okp[keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<T, A>) -> ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>>(chaining.chaining, getter: chaining.getter.append(reference: \.okp[ref: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<G.B.Wrapped, A?>) -> ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, ReferenceWritableKeyPath<C.W, A?>>(chaining.chaining, getter: chaining.getter.append(reference: \.okp[refo: keyPath]))
//	}
//
//}
//
//extension OptionalChaining where G: WritableKeyPath<C.W, T?> {
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<T, A>) -> ChainingProperty<C, A?, WritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, WritableKeyPath<C.W, A?>>(chaining.chaining, getter: chaining.getter.append(\.okp[wr: keyPath]))
//	}
//
//	public subscript<A>(dynamicMember keyPath: WritableKeyPath<G.B.Wrapped, A?>) -> ChainingProperty<C, A?, WritableKeyPath<C.W, A?>> {
//		ChainingProperty<C, A?, WritableKeyPath<C.W, A?>>(chaining.chaining, getter: chaining.getter.append(\.okp[wro: keyPath]))
//	}
//
//}
