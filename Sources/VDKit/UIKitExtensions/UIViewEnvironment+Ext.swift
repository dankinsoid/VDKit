//
//  UIViewEnvironment+Ext.swift
//  TodoList
//
//  Created by Данил Войдилов on 02.07.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit

extension ChainProperty where Value == UIViewEnvironment, Base: ValueChainingProtocol {
	
	public func observe<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, observer: @escaping (T) -> Void) -> Base {
		observe(keyPath) {
			$0.observe(keyPath, observer: observer)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, to: ReferenceWritableKeyPath<UIView, T>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T?>, to: ReferenceWritableKeyPath<UIView, T>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, to: ReferenceWritableKeyPath<UIView, T?>) -> Base {
		observe(keyPath) {
			$0.bind(keyPath, to: to)
		}
	}
	
	private func observe<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, observer: @escaping (UIViewEnvironment) -> Void) -> Base {
		var result = chaining
		result.apply = {[chaining] in
			let result = chaining.apply($0)
			observer(result[keyPath: getter])
			return result
		}
		return result
	}
	
	public func bind<T>(_ keyPath: ReferenceWritableKeyPath<UIView, T>) -> Base {
		bind(\.[dynamicMember: keyPath], to: keyPath)
	}
}
