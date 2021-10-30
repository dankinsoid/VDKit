//
//  File.swift
//  
//
//  Created by Данил Войдилов on 08.05.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum IfViewIterable<First: IterableView, Second: IterableView>: IterableView {
	case first(First), second(Second)
	
	public var body: some View {
		switch self {
		case .first(let first): 	first
		case .second(let second): second
		}
	}
	
	public var count: Int {
		switch self {
		case .first(let first): return first.count
		case .second(let second): return second.count
		}
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V, reversed: Bool) -> Bool {
		switch self {
		case .first(let first): return first.iterate(with: visitor, reversed: reversed)
		case .second(let second): return second.iterate(with: visitor, reversed: reversed)
		}
	}
	
	@IterableViewBuilder
	public func subrange(at range: Range<Int>) -> some IterableView {
		switch self {
		case .first(let first): 	first.subrange(at: range)
		case .second(let second): second.subrange(at: range)
		}
	}
}
