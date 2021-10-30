//
//  ArrayView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI
import VDBuilders

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ArrayView<Content: IterableView>: IterableView, ExpressibleByArrayLiteral {
	public var content: [Content]
	
	public var body: some View {
        ForEach(Array(content.enumerated()), id: \.offset) { $0.element }
	}
	
	public init<C: Collection>(_ content: C) where C.Element == Content {
		self.content = Array(content)
	}
	
	public init(arrayLiteral elements: Content...) {
		content = elements
	}
	
	public init(@ArrayBuilder<Content> _ content: () -> [Content]) {
		self.content = content()
	}
	
	public var count: Int { content.reduce(0) { $0 + $1.count } }
	
	public func iterate<V: IterableViewVisitor>(with visitor: V, reversed: Bool) -> Bool {
		switch reversed {
		case true:
			return !content.reversed().contains(where: { !$0.iterate(with: visitor, reversed: reversed) })
		case false:
			return !content.contains(where: { !$0.iterate(with: visitor, reversed: reversed) })
		}
	}
	
	public func subrange(at range: Range<Int>) -> some IterableView {
		ArrayView(content[range.clamped(to: 0..<content.count)])
	}
}
