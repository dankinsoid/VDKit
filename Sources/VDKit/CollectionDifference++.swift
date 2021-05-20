//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension CollectionDifference.Change {
	
	public var offset: Int {
		switch self {
		case .insert(let offset, _, _):	return offset
		case .remove(let offset, _, _): return offset
		}
	}
	
	public var element: ChangeElement {
		switch self {
		case .insert(_, let element, _): return element
		case .remove(_, let element, _): return element
		}
	}
	
	public var associatedWith: Int? {
		switch self {
		case .insert(_, _, let associatedWith):	return associatedWith
		case .remove(_, _, let associatedWith):	return associatedWith
		}
	}
	
	public var debugDescription: String {
		switch self {
		case .insert(let offset, let element, let associatedWith):
			return "insert \(element) at \(offset)" + (associatedWith.map { " associatedWith \($0)" } ?? "")
		case .remove(let offset, let element, let associatedWith):
			return "remove \(element) from \(offset)" + (associatedWith.map { " associatedWith \($0)" } ?? "")
		}
	}
}
