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
extension Pair: IterableViewType where F: View, S: View {
	
	public var count: Int {
		_0.contentCount + _1.contentCount
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		guard count > 0 else { return }
		_0.iterateContent(with: visitor)
		_1.iterateContent(with: visitor)
	}
}
