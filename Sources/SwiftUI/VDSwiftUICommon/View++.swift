//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func map<T: View>(@ViewBuilder _ map: (Self) -> T) -> T {
		map(self)
	}
	
	public func fullScreenBackground<V: View>(_ view: V) -> some View {
		ZStack {
			view.edgesIgnoringSafeArea(.all)
			self
		}
	}
	
	public func fullScreenBackground<V: View>(@ViewBuilder _ view: () -> V) -> some View {
		fullScreenBackground(view())
	}
	
	public func background<V: View>(alignment: Alignment = .center, @ViewBuilder _ view: () -> V) -> some View {
		background(view(), alignment: alignment)
	}
	
	public func height(_ height: CGFloat) -> some View {
		frame(height: height)
	}
	
	public func width(_ width: CGFloat) -> some View {
		frame(width: width)
	}
	
	public func log(_ values: Any...) -> Self {
		#if DEBUG
		if values.isEmpty {
			print()
		} else {
			values.dropLast().forEach { print($0, separator: "", terminator: " ") }
			print(values.last!)
		}
		#endif
		return self
	}
}

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	
	public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct RoundedCorner: Shape {
	
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
#endif
#endif
