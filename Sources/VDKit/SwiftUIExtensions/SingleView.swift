//
//  SingleView.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct SingleView<Body: View>: IterableView {
	public var body: Body
	public var count: Int { 1 }
	
	public init(_ body: Body) {
		self.body = body
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		visitor.visit(body)
	}
}
