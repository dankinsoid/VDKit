//
//  SwiftUI+Ext.swift
//  TodoList
//
//  Created by Данил Войдилов on 28.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import Combine

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct UIKitView<Content: UIKitViewWrappable, V>: View where Content.V == V {
	private let content: Content
	
	public var body: some View {
		content
	}
	
	private init(_ content: Content) {
		self.content = content
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension UIKitView where Content == _UIViewView<V> {
	
	public init(_ make: @escaping () -> V, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(.init(make, update: update))
	}

	public init(_ make: @escaping @autoclosure () -> V, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}

	public init(_ make: @escaping () -> Chain<V>, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init({ make().apply() }, update: update)
	}

	public init(_ make: @escaping @autoclosure () -> Chain<V>, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension UIKitView where Content == _UIViewControllerView<V> {
	
	public init(_ make: @escaping () -> V, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(.init(make, update: update))
	}
	
	public init(_ make: @escaping @autoclosure () -> V, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
	
	public init(_ make: @escaping () -> Chain<V>, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init({ make().apply() }, update: update)
	}
	
	public init(_ make: @escaping @autoclosure () -> Chain<V>, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol UIKitViewWrappable: View {
	associatedtype V
	associatedtype VContext
	init(_ make: @escaping () -> V, update: @escaping (V, VContext) -> Void)
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct _UIViewView<V: UIView>: UIViewRepresentable, UIKitViewWrappable {
	
	let make: () -> V
	let update: (V, Context) -> Void
	
	public init(_ make: @escaping () -> V, update: @escaping (V, Context) -> Void = {_, _ in }) {
		self.make = make
		self.update = update
	}
	
	public func makeUIView(context: Context) -> V {
		make()
	}
	
	public func updateUIView(_ uiView: V, context: Context) {
		update(uiView, context)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct _UIViewControllerView<V: UIViewController>: UIViewControllerRepresentable, UIKitViewWrappable {
	
	let make: () -> V
	let update: (V, Context) -> Void
	
	public init(_ make: @escaping () -> V, update: @escaping (V, Context) -> Void = {_, _ in }) {
		self.make = make
		self.update = update
	}
	
	public func makeUIViewController(context: Context) -> V {
		make()
	}
	
	public func updateUIViewController(_ uiViewController: V, context: Context) {
		update(uiViewController, context)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
	public var uiKit: UIHostingController<Self> {
		UIHostingController(rootView: self)
	}
}
#endif
