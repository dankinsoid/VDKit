//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach: IterableView where Content: IterableView {
	public var count: Int { data.reduce(0) { $0 + content($1).count } }
	
	public func iterate<V: IterableViewVisitor, R: RangeExpression>(with visitor: V, in range: R) where R.Bound == Int {
		data[range.convert(for: data)].map(content).forEach { $0.iterate(with: visitor) }
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		data.map(content).forEach { $0.iterate(with: visitor) }
	}
}
