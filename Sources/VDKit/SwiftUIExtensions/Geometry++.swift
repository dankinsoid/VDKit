//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.04.2021.
//

import SwiftUI

extension View {
	
	public func bindSize(to binder: Binding<CGSize>) -> some View {
		bindGeometry(\.size, to: binder)
	}
	
	public func bindFrame(in space: CoordinateSpace, to binder: Binding<CGRect>) -> some View {
		bindGeometry {
			let frame = $0.frame(in: space)
			if binder.wrappedValue != frame {
				binder.wrappedValue = frame
			}
		}
	}
	
	public func bindSafeArea(to binder: Binding<EdgeInsets>) -> some View {
		bindGeometry(\.safeAreaInsets, to: binder)
	}
	
	public func bindGeometry<T>(_ path: KeyPath<GeometryProxy, T>, to binder: Binding<T>) -> some View {
		bindGeometry {
			binder.wrappedValue = $0[keyPath: path]
		}
	}
	
	public func bindGeometry<T: Equatable>(_ path: KeyPath<GeometryProxy, T>, to binder: Binding<T>) -> some View {
		bindGeometry {
			if binder.wrappedValue != $0[keyPath: path] {
				binder.wrappedValue = $0[keyPath: path]
			}
		}
	}
	
	public func bindGeometry(to binder: Binding<GeometryProxy>) -> some View {
		bindGeometry { binder.wrappedValue = $0 }
	}
	
	public func bindGeometry(to binder: Binding<GeometryProxy?>) -> some View {
		bindGeometry { binder.wrappedValue = $0 }
	}
	
	public func bindGeometry(to binder: @escaping (GeometryProxy) -> Void) -> some View {
		modifier(GeometryBindingModifier(binder))
	}
}

public struct GeometryBindingModifier: ViewModifier {
	public let id = UUID()
	public let binder: (GeometryProxy) -> Void
	
	public init(_ binder: @escaping (GeometryProxy) -> Void) {
		self.binder = binder
	}
	
	public func body(content: Content) -> some View {
		content.background(
			GeometryReader { geometry in
				Color.clear.preference(key: SizePreferenceKey.self, value: [id: GeometryProxyData(proxy: geometry)])
			}
		)
		.onPreferenceChange(SizePreferenceKey.self) {
			if let proxy = $0[id] {
				binder(proxy.proxy)
			}
		}
	}
}

private struct SizePreferenceKey: PreferenceKey {
	static var defaultValue: [UUID: GeometryProxyData] { [:] }
	
	static func reduce(value: inout [UUID: GeometryProxyData], nextValue: () -> [UUID: GeometryProxyData]) {
		value = value.merging(nextValue()) {_, p in p }
	}
}

private struct GeometryProxyData: Equatable {
	let proxy: GeometryProxy
	
	static func ==(lhs: GeometryProxyData, rhs: GeometryProxyData) -> Bool {
		false //lhs.proxy.size == rhs.proxy.size && lhs.proxy.safeAreaInsets == rhs.proxy.safeAreaInsets
	}
}

extension GeometryProxy {
	public var width: CGFloat { size.width }
	public var height: CGFloat { size.height }
}

public enum Geometry {
	
	public static func hStack<Content: View>(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (GeometryProxy) -> Content) -> some View {
		GeometryReader { proxy in
			HStack<Content>(alignment: alignment, spacing: spacing, content: { content(proxy) })
		}
	}
	
	public static func vStack<Content: View>(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping (GeometryProxy) -> Content) -> some View {
		GeometryReader { proxy in
			VStack<Content>(alignment: alignment, spacing: spacing, content: { content(proxy) })
		}
	}
	
	public static func zStack<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping (GeometryProxy) -> Content) -> some View {
		GeometryReader { proxy in
			ZStack<Content>(alignment: alignment, content: { content(proxy) })
		}
	}
	
	public static func scroll<Content: View>(_ axis: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: @escaping (GeometryProxy) -> Content) -> some View {
		GeometryReader { proxy in
			ScrollView<Content>.init(axis, showsIndicators: showsIndicators, content: { content(proxy) })
		}
	}
}

extension CGRect {
	public func insets(to rect: CGRect) -> EdgeInsets {
		EdgeInsets(
			top: minY - rect.minY,
			leading: minX - rect.minY,
			bottom: rect.maxY - maxY,
			trailing: rect.maxX - maxX
		)
	}
}
