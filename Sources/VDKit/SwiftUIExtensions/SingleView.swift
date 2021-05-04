//
//  SingleView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SingleView<Body: View>: IterableView {
	public var body: Body
	public var count: Int { 1 }
	
	public init(_ body: Body) {
		self.body = body
	}
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		guard range.contains(0) else { return }
		if let iterable = body as? IterableViewType {
			iterable.iterate(with: visitor, in: range)
		} else {
			visitor.visit(body)
		}
	}
}

extension TupleView: IterableView {
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		let mirror = Mirror(reflecting: self)
		guard let tuple = mirror.children.first?.value else { return }
		let tupleMirror = Mirror(reflecting: tuple)
		tupleMirror.children[range.convert(for: tupleMirror.children)].forEach {
			if let iterable = $0.value as? IterableViewType {
				iterable.iterate(with: visitor)
			} else {
				AnyView(_fromValue: $0.value).map {
					visitor.visit($0)
				}
			}
		}
	}
}
