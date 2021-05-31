//
//  File.swift
//  
//
//  Created by Данил Войдилов on 22.02.2021.
//

import Foundation

public protocol ArrayInitable {
	associatedtype Item
	static func create(from: [Item]) -> Item
}

@resultBuilder
public struct ComposeBuilder<C: ArrayInitable> {
	
	@inlinable
	public static func buildBlock(_ components: C.Item...) -> C.Item {
		C.create(from: components)
	}
	
	@inlinable
	public static func buildArray(_ components: [C.Item]) -> C.Item {
		C.create(from: components)
	}
	
	@inlinable
	public static func buildEither(first component: C.Item) -> C.Item {
		component
	}
	
	@inlinable
	public static func buildEither(second component: C.Item) -> C.Item {
		component
	}
	
	@inlinable
	public static func buildOptional(_ component: C.Item?) -> C.Item {
		component ?? C.create(from: [])
	}
	
	@inlinable
	public static func buildLimitedAvailability(_ component: C.Item) -> C.Item {
		component
	}
}
