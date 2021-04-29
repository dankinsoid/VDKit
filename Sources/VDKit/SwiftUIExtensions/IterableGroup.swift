//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IterableGroup<Body: IterableView>: IterableView {
	public var body: Body
	public var count: Int { body.count }
	
	public init(_ content: Body) {
		body = content
	}
	
	public init(@IterableViewBuilder _ content: () -> Body) {
		body = content()
	}
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		body.iterate(with: visitor, in: range)
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		body.iterate(with: visitor)
	}
}
