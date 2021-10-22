//
//  File.swift
//  
//
//  Created by Данил Войдилов on 22.10.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	@inlinable public func onFirstAppear(perform: (() -> Void)? = nil) -> some View {
		modifier(OnFirstAppearModifier(perform: perform))
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct OnFirstAppearModifier: ViewModifier {
	
	@State private var wasAppeared = false
	public var perform: (() -> Void)?
	
	public init(perform: (() -> Void)?) {
		self.perform = perform
	}
	
	public func body(content: Content) -> some View {
		content.onAppear {
			guard !wasAppeared else { return }
			wasAppeared = true
			perform?()
		}
	}
}
