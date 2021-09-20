//
//  UIViewEnvironment.swift
//  TodoList
//
//  Created by Данил Войдилов on 29.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit

extension UIView {
	public var environments: UIViewEnvironment {
		if let result = objc_getAssociatedObject(self, &environmentsKey) as? UIViewEnvironment {
			return result
		}
		let result = UIViewEnvironment(self)
		objc_setAssociatedObject(self, &environmentsKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return result
	}
}

@dynamicMemberLookup
public final class UIViewEnvironment {
	private var values: [PartialKeyPath<UIViewEnvironment>: Any] = [:]
	private var keyPaths: Set<AnyKeyPath> = []
	fileprivate(set) public weak var view: UIView?
	
	fileprivate init(_ view: UIView) {
		self.view = view
	}
	
	public subscript<T>(_ keyPath: KeyPath<UIViewEnvironment, T>) -> T? {
		get {
			if let any = values[keyPath], type(of: any) == T.self {
				return any as? T
			}
			return view?.superview?.environments[keyPath]
		}
		set {
            guard let newValue = newValue else { return }
			values[keyPath] = newValue
			send(keyPath: keyPath, value: newValue)
		}
	}
	
	public subscript<T>(dynamicMember keyPath: KeyPath<UIView, T>) -> UIViewEnvironmentPath<T> {
		UIViewEnvironmentPath(keyPath: keyPath, environment: self)
	}
	
	public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<UIView, T>) -> T {
		get {
			if keyPaths.contains(keyPath) {
				return view?[keyPath: keyPath] ?? UIView()[keyPath: keyPath]
			} else {
				return view?.superview?.environments[dynamicMember: keyPath] ?? UIView()[keyPath: keyPath]
			}
		}
		set {
			set(keyPath: keyPath, value: newValue)
			keyPaths.insert(keyPath)
		}
	}
	
	public subscript<V: UIView, T>(_ keyPath: ReferenceWritableKeyPath<V, T>) -> T? {
		get {
			if keyPaths.contains(keyPath) {
				return (view as? V)?[keyPath: keyPath]
			} else {
				return view?.superview?.environments[keyPath]
			}
		}
		set {
			guard let value = newValue else { return }
			set(keyPath: keyPath, value: value)
			keyPaths.insert(keyPath)
		}
	}
	
	@discardableResult
	public func observe<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, observer: @escaping (T) -> Void) -> () -> Void {
		observer(self[keyPath: keyPath])
		observeMovedToSuperviewIfCan {
			observer(self[keyPath: keyPath])
		}
		return view?.environmentObservers.add(for: keyPath, observer) ?? {}
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, to: ReferenceWritableKeyPath<UIView, T>) -> () -> Void {
		observe(keyPath) { [weak view] in
			view?[keyPath: to] = $0
		}
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T>, to: ReferenceWritableKeyPath<UIView, T?>) -> () -> Void {
		observe(keyPath) { [weak view] in
			view?[keyPath: to] = $0
		}
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<UIViewEnvironment, T?>, to: ReferenceWritableKeyPath<UIView, T>) -> () -> Void {
		observe(keyPath) { [weak view] in
			guard let value = $0 else { return }
			view?[keyPath: to] = value
		}
	}
	
	private func set<V: UIView, T>(keyPath: ReferenceWritableKeyPath<V, T>, value: T) {
		(view as? V)?[keyPath: keyPath] = value
		view?.subviews.forEach {
			$0.environments.setRecursive(keyPath: keyPath, value: value)
		}
	}
	
	private func setRecursive<V: UIView, T>(keyPath: ReferenceWritableKeyPath<V, T>, value: T) {
		guard !keyPaths.contains(keyPath) else { return }
		set(keyPath: keyPath, value: value)
	}
	
	private func send<T>(keyPath: KeyPath<UIViewEnvironment, T>, value: T) {
		view?.environmentObservers.send(value, for: keyPath)
		view?.subviews.forEach {
			$0.environments.sendRecursive(keyPath: keyPath, value: value)
		}
	}
	
	private func sendRecursive<T>(keyPath: KeyPath<UIViewEnvironment, T>, value: T) {
		guard values[keyPath] == nil else { return }
		send(keyPath: keyPath, value: value)
	}
	
	private func observeMovedToSuperviewIfCan(_ action: @escaping () -> Void) {
		_ = try? view?.onMethodInvoked(#selector(UIView.didMoveToWindow)) { _ in
			action()
		}
	}
}

@dynamicMemberLookup
public struct UIViewEnvironmentPath<Value> {
	public let keyPath: KeyPath<UIView, Value>
	public let environment: UIViewEnvironment
	
	public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> UIViewEnvironmentPath<T> {
		UIViewEnvironmentPath<T>(keyPath: self.keyPath.appending(path: keyPath), environment: environment)
	}
	
	public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, T>) -> T {
		get { environment[dynamicMember: self.keyPath.appending(path: keyPath)] }
		nonmutating set { environment[dynamicMember: self.keyPath.appending(path: keyPath)] = newValue }
	}
}

extension UIView {
	fileprivate var environmentObservers: Observers {
		if let result = objc_getAssociatedObject(self, &observersKey) as? Observers {
			return result
		}
		let result = Observers()
		objc_setAssociatedObject(self, &observersKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return result
	}
}

private class Observers {
	private var observers: [AnyKeyPath: [UUID: (Any) -> Void]] = [:]
	
	func add<T>(for keyPath: KeyPath<UIViewEnvironment, T>, _ observer: @escaping (T) -> Void) -> () -> Void {
		let id = UUID()
		observers[keyPath, default: [:]][id] = {
			guard let value = $0 as? T else { return }
			observer(value)
		}
		return { self.observers[keyPath]?[id] = nil }
	}
	
	func send<T>(_ value: T, for keyPath: KeyPath<UIViewEnvironment, T>) {
		observers[keyPath]?.forEach {
			$0.value(value)
		}
	}
}

private var environmentsKey = "environmentsKey"
private var observersKey = "observersKey"
