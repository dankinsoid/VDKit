//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation

extension RangeExpression where Bound == Int {
	
	public func convert<C: Collection>(for data: C) -> Range<C.Index> {
		let range = relative(to: IntIndex(collection: data))
		let start = data.index(data.startIndex, offsetBy: range.lowerBound)
		let end = data.index(data.startIndex, offsetBy: range.upperBound)
		return start..<end
	}
}

private struct IntIndex<C: Collection>: Collection {
	typealias Index = Int
	typealias Element = C.Element
	
	var collection: C
	var startIndex: Int { 0 }
	var endIndex: Int { collection.count }
	
	subscript(position: Int) -> C.Element {
		collection[collection.index(collection.startIndex, offsetBy: position)]
	}
	
	func index(after i: Int) -> Int {
		i + 1
	}
}
