//
//  File.swift
//  
//
//  Created by Данил Войдилов on 17.04.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
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

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct GeometryBindingModifier: ViewModifier {
	public let binder: (GeometryProxy) -> Void
	
	public init(_ binder: @escaping (GeometryProxy) -> Void) {
		self.binder = binder
	}
	
	public func body(content: Content) -> some View {
		content.background(
			GeometryReader { geometry in
				Color.clear.preference(key: SizePreferenceKey.self, value: GeometryProxyData(proxy: geometry))
			}
		)
		.onPreferenceChange(SizePreferenceKey.self) {
			guard let proxy = $0 else { return }
			binder(proxy.proxy)
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct SizePreferenceKey: PreferenceKey {
	static var defaultValue: GeometryProxyData? { nil }
	
	static func reduce(value: inout GeometryProxyData?, nextValue: () -> GeometryProxyData?) {
		value = nextValue() ?? value
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct GeometryProxyData: Equatable {
	let proxy: GeometryProxy
	
	static func ==(lhs: GeometryProxyData, rhs: GeometryProxyData) -> Bool {
		false //lhs.proxy.size == rhs.proxy.size && lhs.proxy.safeAreaInsets == rhs.proxy.safeAreaInsets
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension GeometryProxy {
	public var width: CGFloat { size.width }
	public var height: CGFloat { size.height }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
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
