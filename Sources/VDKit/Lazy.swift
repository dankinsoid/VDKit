//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import Foundation

@propertyWrapper
public final class Lazy<T> {
	let get: () -> T
	private var value: T?
	
	public var wrappedValue: T {
		get {
			if value == nil {
				value = get()
			}
			return value ?? get()
		}
		set {
			value = newValue
		}
	}
	
	public init(_ get: @escaping () -> T) {
		self.get = get
	}
	
	public init(wrappedValue: @escaping @autoclosure () -> T) {
		self.get = wrappedValue
	}
	
	public func reset() {
		value = nil
	}
	
	public func update() {
		value = get()
	}
}
