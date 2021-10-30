//
//  File.swift
//  
//
//  Created by Данил Войдилов on 15.08.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension IterableView {
	
	public func iterableModifier<M: ViewModifier>(_ modifier: M) -> IterableMapView<Self, M> {
		iterableModifier { _ in modifier }
	}
	
	public func iterableModifier<M: ViewModifier>(_ modifier: @escaping (Int) -> M) -> IterableMapView<Self, M> {
		IterableMapView(base: self, modifier: modifier)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct IterableMapView<Base: IterableView, Modifier: ViewModifier>: IterableView {
	public var base: Base
	public var modifier: (Int) -> Modifier
	public var count: Int { base.count }
	
	public var body: some View {
		if count > 0 {
			ForEach(Array(base.subviews.enumerated()), id: \.offset) {
				$0.element.modifier(modifier($0.offset))
			}
		}
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V, reversed: Bool) -> Bool {
		let visitor = MapIterableViewVisitor(modifier: modifier, base: visitor)
		return base.iterate(with: visitor, reversed: reversed)
	}
	
	public func subrange(at range: Range<Int>) -> some IterableView {
		IterableMapView<Base.Subview, Modifier>(base: base.subrange(at: range), modifier: modifier)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
final class MapIterableViewVisitor<Base: IterableViewVisitor, Modifier: ViewModifier>: IterableViewVisitor {
	var modifier: (Int) -> Modifier
	var base: Base
	var count = 0
	
	init(modifier: @escaping (Int) -> Modifier, base: Base) {
		self.modifier = modifier
		self.base = base
	}
	
	func visit<V>(_ value: V) -> Bool where V : View {
		let result = base.visit(value.modifier(modifier(count)))
		count += 1
		return result
	}
}
