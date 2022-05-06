//
//  UIKit+Ext.swift
//  TodoList
//
//  Created by Данил Войдилов on 28.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import VDBuilders

@resultBuilder
public struct SubviewsBuilder {
	
	@inlinable
	public static func buildBlock(_ components: [SubviewProtocol]...) -> [SubviewProtocol] {
		Array(components.joined())
	}
	
	@inlinable
	public static func buildArray(_ components: [[SubviewProtocol]]) -> [SubviewProtocol] {
		Array(components.joined())
	}
	
	@inlinable
	public static func buildEither(first component: [SubviewProtocol]) -> [SubviewProtocol] {
		component
	}
	
	@inlinable
	public static func buildEither(second component: [SubviewProtocol]) -> [SubviewProtocol] {
		component
	}
	
	@inlinable
	public static func buildOptional(_ component: [SubviewProtocol]?) -> [SubviewProtocol] {
		component ?? []
	}
	
	@inlinable
	public static func buildLimitedAvailability(_ component: [SubviewProtocol]) -> [SubviewProtocol] {
		component
	}
	
	@inlinable
	public static func buildExpression(_ expression: SubviewProtocol) -> [SubviewProtocol] {
		[expression]
	}
	
	@inline(__always)
	public static func buildExpression<S: SubviewProtocol>(_ expression: S) -> [SubviewProtocol] {
		[expression]
	}
}

#if canImport(SwiftUI)
import SwiftUI

extension SubviewsBuilder {
	
	@available(iOS 13.0, *)
	@inline(__always)
	public static func buildExpression<S: View>(_ expression: S) -> [SubviewProtocol] {
		[UIHostingController(rootView: expression)]
	}
}
#endif
#endif
