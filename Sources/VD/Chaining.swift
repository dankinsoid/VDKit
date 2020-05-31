//
//  Chaining.swift
//  NewYearPlans
//
//  Created by crypto_user on 25.12.2019.
//  Copyright © 2019 DanilVoidilov. All rights reserved.
//

import Foundation

public class Chaining<T> {
    fileprivate var action: (T) -> () = { _ in }
    
    fileprivate init() {}
}

@dynamicMemberLookup
public final class TypeChaining<T>: Chaining<T> {
    
    public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<T, A>) -> ChainingProperty<T, TypeChaining, A> {
        return ChainingProperty<T, TypeChaining, A>(self, keyPath: keyPath)
    }
    
    public func apply(for values: T...) {
        apply(for: values)
    }
    
    public func apply(for values: [T]) {
        values.forEach(action)
    }
}

@dynamicMemberLookup
public final class ValueChaining<T>: Chaining<T> {
    fileprivate let wrappedValue: T
    
    public subscript<A>(dynamicMember keyPath: ReferenceWritableKeyPath<T, A>) -> ChainingProperty<T, ValueChaining, A> {
        return ChainingProperty<T, ValueChaining, A>(self, keyPath: keyPath)
    }
    
    fileprivate init(_ value: T) {
        wrappedValue = value
    }
    
    public func apply() {
        action(wrappedValue)
    }
}

@dynamicMemberLookup
public final class ChainingProperty<T, C: Chaining<T>, P> {
    private let chaining: C
    private let keyPath: ReferenceWritableKeyPath<T, P>
    
    fileprivate init(_ value: C, keyPath: ReferenceWritableKeyPath<T, P>) {
        chaining = value
        self.keyPath = keyPath
    }
    
    public subscript<A>(dynamicMember keyPath: WritableKeyPath<P, A>) -> ChainingProperty<T, C, A> {
        return ChainingProperty<T, C, A>(chaining, keyPath: self.keyPath.appending(path: keyPath))
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

extension ChainingProperty where C == ValueChaining<T> {
    
    public subscript(_ value: P) -> T {
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
