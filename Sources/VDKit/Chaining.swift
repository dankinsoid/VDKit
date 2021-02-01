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
	var action: (W) -> Void { get }
	func copy(with action: @escaping (W) -> Void) -> Self
}

public protocol ValueChainingProtocol: Chaining {
	var wrappedValue: W { get }
	func apply()
}

extension ValueChainingProtocol {
	public func apply() {
		action(wrappedValue)
	}
}

@dynamicMemberLookup
public struct TypeChaining<W>: Chaining {
	public private(set) var action: (W) -> Void
	
	public init() {
		self.action = {_ in }
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<TypeChaining, A> {
		return ChainingProperty<TypeChaining, A>(self, keyPath: keyPath)
	}
	
	public func apply(for values: W...) {
		apply(for: values)
	}
	
	public func apply(for values: [W]) {
		values.forEach(action)
	}
	
	public func copy(with action: @escaping (W) -> Void) -> TypeChaining<W> {
		var result = TypeChaining()
		result.action = action
		return result
	}
	
}

@dynamicMemberLookup
public struct ValueChaining<W>: ValueChainingProtocol {
	public let wrappedValue: W
	public private(set) var action: (W) -> Void = { _ in }
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<ValueChaining, A> {
		ChainingProperty<ValueChaining, A>(self, keyPath: keyPath)
	}
	
	public init(_ value: W) {
		wrappedValue = value
	}
	
	public func copy(with action: @escaping (W) -> Void) -> ValueChaining<W> {
		var result = ValueChaining(wrappedValue)
		result.action = action
		return result
	}
	
}

@dynamicMemberLookup
public struct ChainingProperty<C: Chaining, P> {
	private var chaining: C
	private let keyPath: ReferenceWritableKeyPath<C.W, P>
	
	public init(_ value: C, keyPath: ReferenceWritableKeyPath<C.W, P>) {
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
			prev($0)
			$0[keyPath: kp] = value
		}
	}
	
}

extension ChainingProperty where C: ValueChainingProtocol {
	
	public subscript(_ value: P) -> C.W {
		self[value].apply()
		return chaining.wrappedValue
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
