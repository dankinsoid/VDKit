//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.06.2021.
//

import Foundation

public protocol GetterProtocol {
	associatedtype Root
	associatedtype Value
	var get: (Root) -> Value { get }
}

public protocol SetterProtocol {
	associatedtype Root
	associatedtype Value
	var set: (inout Root, Value) -> Void { get }
}

public protocol NonmutatuingSetterProtocol {
	associatedtype Root
	associatedtype Value
	var nonmutatuingSet: (Root, Value) -> Void { get }
}

public typealias GetterSetterProtocol = GetterProtocol & SetterProtocol
public typealias GetterNonmutatuingSetterProtocol = GetterProtocol & NonmutatuingSetterProtocol

public struct Getter<Root, Value>: GetterProtocol {
	public let get: (Root) -> Value
	
	public init(_ get: @escaping (Root) -> Value) {
		self.get = get
	}
}

public struct Setter<Root, Value>: SetterProtocol {
	public let set: (inout Root, Value) -> Void
	
	public init(_ set: @escaping (inout Root, Value) -> Void) {
		self.set = set
	}
}

public struct NonmutatuingSetter<Root, Value>: NonmutatuingSetterProtocol {
	public let nonmutatuingSet: (Root, Value) -> Void
	
	public init(_ set: @escaping (Root, Value) -> Void) {
		self.nonmutatuingSet = set
	}
}

public struct GetterSetter<Root, Value>: GetterSetterProtocol {
	public let get: (Root) -> Value
	public let set: (inout Root, Value) -> Void
	
	public init(get: @escaping (Root) -> Value, set: @escaping (inout Root, Value) -> Void) {
		self.get = get
		self.set = set
	}
}

public struct GetterNonmutatuingSetter<Root, Value>: GetterNonmutatuingSetterProtocol {
	public let get: (Root) -> Value
	public let nonmutatuingSet: (Root, Value) -> Void
	
	public init(get: @escaping (Root) -> Value, set: @escaping (Root, Value) -> Void) {
		self.get = get
		self.nonmutatuingSet = set
	}
}

extension KeyPath: GetterProtocol {
	public var get: (Root) -> Value {
		{ $0[keyPath: self] }
	}
}

extension WritableKeyPath: SetterProtocol {
	public var set: (inout Root, Value) -> Void {
		{ $0[keyPath: self] = $1 }
	}
}

extension ReferenceWritableKeyPath: NonmutatuingSetterProtocol {
	public var nonmutatuingSet: (Root, Value) -> Void {
		{ $0[keyPath: self] = $1 }
	}
}
