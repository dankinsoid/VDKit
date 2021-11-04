//
//  File.swift
//  
//
//  Created by Данил Войдилов on 02.11.2021.
//

import Foundation

private final class Ref<T> {
	var val : T
	init(_ v : T) { val = v }
}

@propertyWrapper
public struct COW<T> {
	private var ref : Ref<T>
	
	public init(_ value : T) {
		ref = Ref(value)
	}
	
	public init(wrappedValue: T) {
		self = COW(wrappedValue)
	}
	
	public var wrappedValue: T {
		get { ref.val }
		set {
			if !isKnownUniquelyReferenced(&ref) {
				ref = Ref(newValue)
				return
			}
			ref.val = newValue
		}
	}
}
