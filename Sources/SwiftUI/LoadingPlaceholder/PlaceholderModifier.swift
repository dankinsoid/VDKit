//
//  File.swift
//  
//
//  Created by Данил Войдилов on 21.11.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct PlaceholderModifier<Placeholder: View>: ViewModifier {
	
	@Environment(\.showLoadingPlaceholder) private var show
	let placeholder: Placeholder
	
	func body(content: Content) -> some View {
		if show {
			placeholder
		} else {
			content
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum PlaceholderKey: EnvironmentKey {
	static var defaultValue: Bool { false }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var showLoadingPlaceholder: Bool {
		get { self[PlaceholderKey.self] }
		set { self[PlaceholderKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	
	public func loadingPlaceholder<Placeholder: View>(@ViewBuilder _ placeholder: () -> Placeholder) -> some View {
		modifier(PlaceholderModifier(placeholder: placeholder()))
	}
	
	public func loadingPlaceholder() -> some View {
		loadingPlaceholder {
			Shimmering()
		}
	}
	
	public func showLoadingPlaceholder(_ show: Bool) -> some View {
		environment(\.showLoadingPlaceholder, show)
	}
}
