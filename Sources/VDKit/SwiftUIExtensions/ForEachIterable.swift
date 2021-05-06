//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach: IterableViewType where Content: IterableView {
	public var count: Int { data.reduce(0) { $0 + content($1).count } }
	
	public static func iterable(_ data: Data, id: KeyPath<Data.Element, ID>, @IterableViewBuilder _ content: @escaping (Data.Element) -> Content) -> ForEach {
		ForEach(data, id: id, content: content)
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) {
		data.map(content).forEach { $0.iterate(with: visitor) }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ForEach where Content: IterableView, ID: Identifiable, Data.Element == ID, ID.ID == ID {
	
	public static func iterable(_ data: Data, @IterableViewBuilder _ content: @escaping (Data.Element) -> Content) -> ForEach {
		ForEach(data, content: content)
	}
}
