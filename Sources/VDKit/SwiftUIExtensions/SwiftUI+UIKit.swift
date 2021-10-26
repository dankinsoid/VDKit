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
public struct UIKitView<V: UIView>: UIViewRepresentable {
	
	let make: () -> V
	let update: (V, UIViewRepresentableContext<UIKitView<V>>) -> Void
	
	public init(_ make: @escaping () -> V, update: @escaping (V, UIViewRepresentableContext<UIKitView<V>>) -> Void = {_, _ in }) {
		self.make = make
		self.update = update
	}
	
	public init(_ make: @escaping @autoclosure () -> V, update: @escaping (V, UIViewRepresentableContext<UIKitView<V>>) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
	
	public init(_ make: @escaping () -> Chain<V>, update: @escaping (V, UIViewRepresentableContext<UIKitView<V>>) -> Void = {_, _ in }) {
		self = .init({ make().apply() }, update: update)
	}
	
	public init(_ make: @escaping @autoclosure () -> Chain<V>, update: @escaping (V, UIViewRepresentableContext<UIKitView<V>>) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
	
	public func makeUIView(context: UIViewRepresentableContext<UIKitView<V>>) -> V {
		make()
	}
	
	public func updateUIView(_ uiView: V, context: UIViewRepresentableContext<UIKitView<V>>) {
		update(uiView, context)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct UIKitViewController<V: UIViewController>: UIViewControllerRepresentable {
	
	let make: () -> V
	let update: (V, UIViewControllerRepresentableContext<UIKitViewController<V>>) -> Void
	
	public init(_ make: @escaping () -> V, update: @escaping (V, UIViewControllerRepresentableContext<UIKitViewController<V>>) -> Void = {_, _ in }) {
		self.make = make
		self.update = update
	}
	
	public init(_ make: @escaping @autoclosure () -> V, update: @escaping (V, UIViewControllerRepresentableContext<UIKitViewController<V>>) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
	
	public init(_ make: @escaping () -> Chain<V>, update: @escaping (V, UIViewControllerRepresentableContext<UIKitViewController<V>>) -> Void = {_, _ in }) {
		self = .init({ make().apply() }, update: update)
	}
	
	public init(_ make: @escaping @autoclosure () -> Chain<V>, update: @escaping (V, UIViewControllerRepresentableContext<UIKitViewController<V>>) -> Void = {_, _ in }) {
		self = .init(make, update: update)
	}
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<UIKitViewController<V>>) -> V {
		make()
	}
	
	public func updateUIViewController(_ uiViewController: V, context: UIViewControllerRepresentableContext<UIKitViewController<V>>) {
		update(uiViewController, context)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
	public var uiKit: UIHostingController<Self> {
		UIHostingController(rootView: self)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct SubviewRepresentableView<V: SubviewProtocol>: UIViewRepresentable {
	
	let make: () -> V
	
	public init(_ make: @escaping () -> V) {
		self.make = make
	}
	
	public init(_ make: @escaping @autoclosure () -> V) {
		self.make = make
	}
	
	public func makeUIView(context: UIViewRepresentableContext<SubviewRepresentableView<V>>) -> UIView {
		let content = make().createViewToAdd()
		content.translatesAutoresizingMaskIntoConstraints = false
		content.contentPriority.both.both = .required
		return content
	}
	
	public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SubviewRepresentableView<V>>) {}
	
}

#endif
