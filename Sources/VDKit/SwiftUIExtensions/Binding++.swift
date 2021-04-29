//
//  File.swift
//  
//
//  Created by Данил Войдилов on 19.04.2021.
//

import SwiftUI
import Combine

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding {
	
	public init(wrappedValue: Value) {
		self = .var(wrappedValue)
	}
	
	public func map<T>(get: @escaping (Value) -> T, set: @escaping (Value, T) -> Value) -> Binding<T> {
		Binding<T>(
			get: { get(self.wrappedValue) },
			set: { self.wrappedValue = set(self.wrappedValue, $0) }
		)
	}
	
	public func map<T>(_ keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
		self[dynamicMember: keyPath]
	}
	
	public mutating func observe(_ observer: @escaping (_ old: Value, _ new: Value) -> Void) {
		let current = self
		self = Binding(
			get: { current.wrappedValue },
			set: {
				let old = current.wrappedValue
				current.wrappedValue = $0
				observer(old, $0)
			}
		)
	}
	
	public func didSet(_ action: @escaping (_ old: Value, _ new: Value) -> Void) -> Binding {
		Binding(
			get: { self.wrappedValue },
			set: {
				let old = self.wrappedValue
				self.wrappedValue = $0
				action(old, $0)
			}
		)
	}
	
	public func willSet(_ action: @escaping (_ old: Value, _ new: Value) -> Void) -> Binding {
		Binding(
			get: { self.wrappedValue },
			set: {
				action(self.wrappedValue, $0)
				self.wrappedValue = $0
			}
		)
	}
	
	public func didSet(_ action: @escaping (_ new: Value) -> Void) -> Binding {
		didSet { _, new in
			action(new)
		}
	}
	
	public func willSet(_ action: @escaping (_ new: Value) -> Void) -> Binding {
		willSet { _, new in
			action(new)
		}
	}
	
	public static func `var`(_ initial: Value) -> Binding {
		let wrapper = Wrapper(initial)
		return Binding(
			get: { wrapper.value },
			set: { wrapper.value = $0 }
		)
	}
	
	public static func `let`(_ value: Value) -> Binding {
		Binding(
			get: { value },
			set: { _ in }
		)
	}
	
	public static func `var`<Base>(_ base: Base, _ keyPath: ReferenceWritableKeyPath<Base, Value>) -> Binding {
		Binding(
			get: { base[keyPath: keyPath] },
			set: { base[keyPath: keyPath] = $0 }
		)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Binding where Value: Equatable {
	
	public func skipEqual() -> Binding {
		Binding(
			get: { self.wrappedValue },
			set: {
				guard self.wrappedValue != $0 else { return }
				self.wrappedValue = $0
			}
		)
	}
}

private final class Wrapper<T> {
	var value: T
	init(_ value: T) { self.value = value }
}
