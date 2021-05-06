//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Group: IterableViewType where Content: IterableViewType {
	
	private var children: [IterableViewType] {
		Mirror(reflecting: self).children.compactMap {
			($0.value as? IterableViewType) ?? AnyView(_fromValue: $0.value).map { SingleView($0) }
		}
	}
	
	public var count: Int {
		children.reduce(0) { $0 + $1.count }
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		!children.contains(where: { !$0.iterate(with: visitor) })
	}
}
