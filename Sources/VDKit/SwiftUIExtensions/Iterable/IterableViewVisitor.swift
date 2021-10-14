//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol IterableViewVisitor {
	func visit<V: View>(_ value: V) -> Bool
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
open class AnyViewVisitor: IterableViewVisitor {
	open var anyViews: [AnyView] = []
	
	public init() {}
	
	open func visit<V: View>(_ value: V) -> Bool {
		anyViews.append(AnyView(value))
		return true
	}
}
