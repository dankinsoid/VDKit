//
//  Pair+Iterable.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pair: View where F: View, S: View {
	public var body: some View {
		Group {
			_0
			_1
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pair: IterableView where F: IterableView, S: IterableView {
	
	public var count: Int {
		_0.count + _1.count
	}
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		let cnt = count
		guard cnt > 0 else { return }
		let indecis = range.relative(to: 0..<cnt)
		let firstCount = _0.count
		if firstCount > 0 {
			let range = indecis.clamped(to: 0..<firstCount)
			if !range.isEmpty {
				_0.iterate(with: visitor, in: range)
			}
		}
		if cnt > firstCount {
			let range = indecis.clamped(to: firstCount..<cnt)
			if !range.isEmpty {
				_1.iterate(with: visitor, in: (range.lowerBound - firstCount)..<(range.upperBound - firstCount))
			}
		}
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		guard count > 0 else { return }
		_0.iterate(with: visitor)
		_1.iterate(with: visitor)
	}
}
