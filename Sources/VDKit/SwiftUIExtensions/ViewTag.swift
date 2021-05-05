//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.05.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public var viewTag: AnyHashable? {
		Mirror(reflecting: self).descendant("modifier", "value", "tagged") as? AnyHashable
	}
	
	var content: Any? { Mirror(reflecting: self).last("content") }
}

extension Mirror {
	func last(_ first: MirrorPath) -> Any? {
		let current = descendant(first)
		return current.flatMap { Mirror(reflecting: $0).last(first) } ?? current
	}
}
