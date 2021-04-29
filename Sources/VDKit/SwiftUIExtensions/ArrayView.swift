//
//  ArrayView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ArrayView<Content: View>: View, ExpressibleByArrayLiteral {
	public var content: [Content]
	
	public var body: some View {
		ForEach(0..<content.count) { content[$0] }
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
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ArrayView: IterableView where Content: IterableView {
	
	public var count: Int { content.count }
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		content[range.relative(to: content)].forEach { $0.iterate(with: visitor) }
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		content.forEach { $0.iterate(with: visitor) }
	}
}
