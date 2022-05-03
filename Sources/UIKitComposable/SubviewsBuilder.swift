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

public typealias SubviewsBuilder = ArrayBuilder<SubviewProtocol>

extension ArrayBuilder where T == SubviewProtocol {
	
	@inline(__always)
	public static func buildExpression<S: SubviewProtocol>(_ expression: S) -> [T] {
		[expression]
	}
}

#if canImport(SwiftUI)
import SwiftUI

extension ArrayBuilder where T == SubviewProtocol {
	
	@available(iOS 13.0, *)
	@inline(__always)
	public static func buildExpression<S: View>(_ expression: S) -> [T] {
		[UIHostingController(rootView: expression)]
	}
}

#endif
#endif
