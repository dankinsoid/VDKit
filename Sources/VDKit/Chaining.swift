//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation

public class Chaining<W> {
	fileprivate var action: (W) -> () = { _ in }
	
	fileprivate init() {}
}

@dynamicMemberLookup
public final class TypeChaining<W>: Chaining<W> {
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<W, W, TypeChaining, A> {
		return ChainingProperty<W, W, TypeChaining, A>(self, keyPath: keyPath, map: { $0 })
	}
	
	public func apply(for values: W...) {
		apply(for: values)
	}
	
	public func apply(for values: [W]) {
		values.forEach(action)
	}
}

@dynamicMemberLookup
public final class ValueChaining<W, T>: Chaining<W> {
	fileprivate let wrappedValue: W
	fileprivate let map: (W) -> T
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<W, T, ValueChaining, A> {
		ChainingProperty<W, T, ValueChaining, A>(self, keyPath: keyPath, map: map)
	}
	
	fileprivate init(_ value: W, map: @escaping (W) -> T) {
		wrappedValue = value
		self.map = map
	}
	
	public func apply() {
		action(wrappedValue)
	}
}

@dynamicMemberLookup
public final class ChainingProperty<W, T, C: Chaining<W>, P> {
	private let chaining: C
	private let keyPath: ReferenceWritableKeyPath<W, P>
	private let map: (W) -> T
	
	fileprivate init(_ value: C, keyPath: ReferenceWritableKeyPath<W, P>, map: @escaping (W) -> T) {
		chaining = value
		self.map = map
		self.keyPath = keyPath
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<P, A>) -> ChainingProperty<W, T, C, A> {
		return ChainingProperty<W, T, C, A>(chaining, keyPath: self.keyPath.appending(path: keyPath), map: map)
	}
	
	public subscript(_ value: P) -> C {
		let prev = chaining.action
		let kp = keyPath
		chaining.action = {
			prev($0)
			$0[keyPath: kp] = value
		}
		return chaining
	}
	
}

extension ChainingProperty where C == ValueChaining<W, T> {
	
	public subscript(_ value: P) -> T {
		self[value].apply()
		return map(chaining.wrappedValue)
	}
	
}

extension NSObjectProtocol {
	public static var chain: TypeChaining<Self> { TypeChaining() }
	public var chain: ValueChaining<Self, Self> { ValueChaining(self, map: { $0 }) }
	
	public func apply(_ chain: TypeChaining<Self>) -> Self {
		chain.apply(for: self)
		return self
	}
	
}
