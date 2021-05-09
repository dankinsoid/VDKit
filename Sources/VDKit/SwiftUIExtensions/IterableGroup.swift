//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IterableGroup<Content: IterableView>: IterableView {
	
	public var content: Content
	
	public init(@IterableViewBuilder build: () -> Content) {
		content = build()
	}
	
	public var body: Content { content }
	
	public var count: Int {
		content.count
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		content.iterate(with: visitor)
	}
	
	public func subrange(at range: Range<Int>) -> some IterableView {
		content.subrange(at: range)
	}
}
