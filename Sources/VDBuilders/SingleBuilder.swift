//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.02.2021.
//

import Foundation

@resultBuilder
public struct SingleBuilder<T> {
	
	public static func buildBlock(_ components: T) -> T {
		components
	}
	
	public static func buildEither(first component: T) -> T {
		component
	}
	
	public static func buildEither(second component: T) -> T {
		component
	}
	
	public static func buildLimitedAvailability(_ component: T) -> T {
		component
	}
}

extension SingleBuilder where T: RangeReplaceableCollection {
	
	public static func buildExpression(_ expression: T) -> T {
		expression
	}
	
	public static func buildExpression(_ expression: T.Element...) -> T {
		T.init(expression)
	}
	
	public static func buildArray(_ components: [T]) -> T {
		T.init(components.joined())
	}
	
	public static func buildOptional(_ component: T?) -> T {
		component ?? T.init()
	}
}
