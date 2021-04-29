//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EmptyView: IterableView {
	public var count: Int { 0 }
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {}
	public func iterate<V: IterableViewVisitor>(with visitor: V) {}
}
