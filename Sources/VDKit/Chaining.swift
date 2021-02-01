//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation

open class Chaining<W> {
	public fileprivate(set) var action: (W) -> ()
	
	fileprivate init(action: @escaping (W) -> () = { _ in }) {
		self.action = action
	}
}

@dynamicMemberLookup
public final class TypeChaining<W>: Chaining<W> {
	
	public init() {
		super.init()
	}
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<W, TypeChaining, A> {
		return ChainingProperty<W, TypeChaining, A>(self, keyPath: keyPath)
	}
	
	public func apply(for values: W...) {
		apply(for: values)
	}
	
	public func apply(for values: [W]) {
		values.forEach(action)
	}
	
}

@dynamicMemberLookup
public final class ValueChaining<W>: Chaining<W> {
	fileprivate let wrappedValue: W
	
	public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<W, A>) -> ChainingProperty<W, ValueChaining, A> {
		ChainingProperty<W, ValueChaining, A>(self, keyPath: keyPath)
	}
	
	public init(_ value: W) {
		wrappedValue = value
	}
	
	public func apply() {
		action(wrappedValue)
	}
}

@dynamicMemberLookup
public final class ChainingProperty<W, C: Chaining<W>, P> {
	private let chaining: C
	private let keyPath: ReferenceWritableKeyPath<W, P>
	
	public init(_ value: C, keyPath: ReferenceWritableKeyPath<W, P>) {
		chaining = value
		self.keyPath = keyPath
	}
	
	public subscript<A>(dynamicMember keyPath: WritableKeyPath<P, A>) -> ChainingProperty<W, C, A> {
		return ChainingProperty<W, C, A>(chaining, keyPath: self.keyPath.appending(path: keyPath))
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

extension ChainingProperty where C == ValueChaining<W> {
	
	public subscript(_ value: P) -> W {
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
