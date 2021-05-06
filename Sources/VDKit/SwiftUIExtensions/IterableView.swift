//
//  IterableView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol IterableViewType {
	var count: Int { get }
	func iterate<V: IterableViewVisitor>(with visitor: V)
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias IterableView = IterableViewType & View

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension IterableViewType {
	
	public var contentArray: [AnyView] {
		let iterator = AnyViewVisitor()
		iterate(with: iterator)
		return iterator.anyViews
	}
}
