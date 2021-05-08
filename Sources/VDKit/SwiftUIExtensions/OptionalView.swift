//
//  File.swift
//  
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct OptionalView<Wrapped: View>: View {
	public var wrapped: Wrapped?
	
	public var body: some View { wrapped }
	
	public init(_ wrapped: Wrapped?) {
		self.wrapped = wrapped
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension OptionalView: IterableViewType where Wrapped: IterableViewType {
	
	public var count: Int {
		wrapped?.count ?? 0
	}
	
	public func iterate<V: IterableViewVisitor>(with visitor: V) -> Bool {
		wrapped?.iterate(with: visitor) ?? true
	}
}


@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension OptionalView: IterableView where Wrapped: IterableView {
	
	public func suffix(_ maxCount: Int) -> some IterableView {
		OptionalView<Wrapped.Suffix>(wrapped?.suffix(maxCount))
	}
	
	public func prefix(_ maxCount: Int) -> some IterableView {
		OptionalView<Wrapped.Prefix>(wrapped?.prefix(maxCount))
	}
}
