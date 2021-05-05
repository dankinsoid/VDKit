//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension TupleView: IterableViewType {
	
	private var children: [IterableViewType] {
		Mirror(reflecting: self).children.first.map {
			Mirror(reflecting: $0.value).children.compactMap {
				($0.value as? IterableViewType) ?? AnyView(_fromValue: $0.value).map { SingleView($0) }
			}
		} ?? []
	}
	
	public var count: Int {
		children.reduce(0) { $0 + $1.count }
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		children.forEach { $0.iterate(with: visitor) }
	}
}
