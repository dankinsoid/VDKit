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
extension Pair: IterableViewType where F: IterableViewType, S: IterableViewType {
	
	public var count: Int {
		_0.count + _1.count
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		guard count > 0 else { return true }
		return _0.iterate(with: visitor) && _1.iterate(with: visitor)
	}
}
