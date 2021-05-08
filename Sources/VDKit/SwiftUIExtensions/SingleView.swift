//
//  SingleView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SingleView<Content: View>: IterableView {
	public var content: Content
	public var count: Int { 1 }
	
	public var body: Content {
		content
	}
	
	public init(_ content: Content) {
		self.content = content
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		visitor.visit(body)
	}
	
	@IterableViewBuilder
	public func suffix(_ maxCount: Int) -> some IterableView {
		if maxCount > 0 {
			self
		}
	}
	
	@IterableViewBuilder
	public func prefix(_ maxCount: Int) -> some IterableView {
		if maxCount > 0 {
			self
		}
	}
}
