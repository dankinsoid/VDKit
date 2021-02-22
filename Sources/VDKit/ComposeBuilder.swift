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

@_functionBuilder
public struct ComposeBuilder<C: ArrayInitable> {
	
	static func buildBlock(_ components: C.Item...) -> C.Item {
		C.create(from: components)
	}
	
	static func buildArray(_ components: [C.Item]) -> C.Item {
		C.create(from: components)
	}
	
	static func buildEither(first component: C.Item) -> C.Item {
		component
	}
	
	static func buildEither(second component: C.Item) -> C.Item {
		component
	}
	
	static func buildOptional(_ component: C.Item?) -> C.Item {
		component ?? C.create(from: [])
	}
	
	static func buildLimitedAvailability(_ component: C.Item) -> C.Item {
		component
	}
	
	//	static func buildExpression(_ expression: [C.Item]) -> C.Item {
	//		C.Items.create(expression)
	//	}
	
	//	static func buildFinalResult(_ component: [T]) -> <#Result#> {
	//		<#code#>
	//	}
	
}
