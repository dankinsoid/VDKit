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
	func iterate<V: IterableViewVisitor>(with visitor: V, reversed: Bool) -> Bool
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension IterableViewType {
	
	@discardableResult
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		iterate(with: visitor, reversed: false)
	}
	
	public var contentArray: [AnyView] {
		let iterator = AnyViewVisitor()
		_ = iterate(with: iterator)
		return iterator.anyViews
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol IterableView: IterableViewType, View {
	associatedtype Subview: IterableView
	func subrange(at range: Range<Int>) -> Subview
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension IterableView {
    
    public var subviews: [Subview] {
        (0..<count).map { self[$0] }
    }
	
	public subscript(_ index: Int) -> Subview {
		subrange(at: index..<(index + 1))
	}
	
	public func suffix(_ maxCount: Int) -> Subview {
		let cnt = count
		return subrange(at: max(0, cnt - maxCount)..<cnt)
	}
	
	public func prefix(_ maxCount: Int) -> Subview {
		subrange(at: 0..<(min(maxCount, count)))
	}
}
