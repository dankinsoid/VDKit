//
//  File.swift
//  
//
//  Created by Данил Войдилов on 09.02.2021.
//

import Foundation

@resultBuilder
public struct ArrayBuilder<T> {
	
	@inlinable
	public static func buildBlock(_ components: [T]...) -> [T] {
		Array(components.joined())
	}
	
	@inlinable
	public static func buildArray(_ components: [[T]]) -> [T] {
		Array(components.joined())
	}
	
	@inlinable
	public static func buildEither(first component: [T]) -> [T] {
		component
	}
	
	@inlinable
	public static func buildEither(second component: [T]) -> [T] {
		component
	}
	
	@inlinable
	public static func buildOptional(_ component: [T]?) -> [T] {
		component ?? []
	}
	
	@inlinable
	public static func buildLimitedAvailability(_ component: [T]) -> [T] {
		component
	}
	
	@inlinable
	public static func buildExpression(_ expression: T) -> [T] {
		[expression]
	}
	
	//	static func buildFinalResult(_ component: [T]) -> <#Result#> {
	//		<#code#>
	//	}
}
