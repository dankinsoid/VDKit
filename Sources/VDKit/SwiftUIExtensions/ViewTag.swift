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
		Mirror(reflecting: self).recursive(path: ["modifier", "value", "tagged"]) as? AnyHashable
	}
}

extension Mirror {
	
	func last(_ first: String) -> Any? {
		let current = recursive(path: [first])
		return current.flatMap { Mirror(reflecting: $0).last(first) } ?? current
	}
	
	func recursive<C: Collection>(path: C) -> Any? where C.Element == String {
		guard !path.isEmpty else { return nil }
		if let value = children.first(where: { $0.label == path.first })?.value {
			if path.count == 1 { return value }
			if let result = Mirror(reflecting: value).recursive(path: path.dropFirst()) {
				return result
			}
		}
		for (_, value) in children {
			if let result = Mirror(reflecting: value).recursive(path: path) {
				return result
			}
		}
		return nil
	}
}
