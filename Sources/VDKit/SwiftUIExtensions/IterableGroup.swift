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
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		body.iterate(with: visitor)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Group: IterableViewType {
	
	private var children: [IterableViewType] {
		Mirror(reflecting: self).children.compactMap {
			($0.value as? IterableViewType) ?? AnyView(_fromValue: $0.value).map { SingleView($0) }
		}
	}
	
	public var count: Int {
		children.reduce(0) { $0 + $1.count }
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		children.forEach { $0.iterate(with: visitor) }
	}
}
