//
//  File.swift
//  
//
//  Created by Данил Войдилов on 22.11.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func rounded(relativeCornerRadius: Double = 0.5) -> some View {
		modifier(RoundedModifier(k: relativeCornerRadius))
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private struct RoundedModifier: ViewModifier {
	var k: Double = 0.5
	@State private var size: CGSize = .zero
	
	func body(content: Content) -> some View {
		content.background(
			GeometryReader { proxy in
				Color.clear
					.preference(key: SizeKey.self, value: proxy.size)
			}
		)
			.onPreferenceChange(SizeKey.self) {
				self.size = $0
			}
			.cornerRadius(min(size.width, size.height) * k)
	}
	
	private struct SizeKey: PreferenceKey {
		static var defaultValue: CGSize { .zero }
		
		static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
			value = nextValue()
		}
	}
}
