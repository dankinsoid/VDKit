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

public protocol SetterProtocol: GetterProtocol {
	var set: (Root, Value) -> Root { get }
}

public struct Getter<Root, Value>: GetterProtocol {
	public let get: (Root) -> Value
}

public struct Setter<Root, Value>: SetterProtocol {
	public let get: (Root) -> Value
	public let set: (Root, Value) -> Root
}

extension KeyPath: GetterProtocol {
	public var get: (Root) -> Value {
		{ $0[keyPath: self] }
	}
}

extension WritableKeyPath: SetterProtocol {
	public var set: (Root, Value) -> Root {
		{
			var result = $0
			result[keyPath: self] = $1
			return result
		}
	}
}
