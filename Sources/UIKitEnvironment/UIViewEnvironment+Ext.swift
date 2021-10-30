//
//  UIViewEnvironment+Ext.swift
//  TodoList
//
//  Created by Данил Войдилов on 02.07.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import VDChain

extension ChainProperty where Value == ObjectEnvironment<Base.Value>, Base: ValueChainingProtocol {
	
	public func observe<T>(_ keyPath: KeyPath<Value, T>, observer: @escaping (T) -> Void) -> Base {
		observe(keyPath) {
			$0.observe(keyPath, observer: observer)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<Value, T>, to: ReferenceWritableKeyPath<Base.Value, T>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<Value, T?>, to: ReferenceWritableKeyPath<Base.Value, T>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<Value, T>, to: ReferenceWritableKeyPath<Base.Value, T?>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	private func observe<T>(_ keyPath: KeyPath<Value, T>, observer: @escaping (Value) -> Void) -> Base {
		var result = chaining
		result.apply = {[chaining] result in
			chaining.apply(&result)
			observer(result[keyPath: getter])
		}
		return result
	}
	
	public func bind<T>(_ keyPath: ReferenceWritableKeyPath<Base.Value, T>) -> Base {
		bind(\.[dynamicMember: keyPath], to: keyPath)
	}
}
#endif
