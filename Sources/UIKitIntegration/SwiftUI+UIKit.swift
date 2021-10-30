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
import VDChain

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public struct UIKitView<Content: UIKitViewWrappable, V>: Chaining, View where Content.V == V {
	public var apply: (inout V) -> Void = { _ in }
	private let content: Content
	private let update: (V, Content.VContext) -> Void
	@Environment(\.uikit) private var environment
	
	public var body: some View {
		var result = content
		result.update = {[update, apply] in
			var view = $0
			apply(&view)
			environment(view)
			update(view, $1)
		}
		return result
	}
	
	fileprivate init(_ content: Content, update: @escaping (V, Content.VContext) -> Void) {
		self.content = content
		self.update = update
	}
	
	public subscript<T>(dynamicMember keyPath: KeyPath<V, T>) -> ChainProperty<Self, T> {
		ChainProperty(self, getter: keyPath)
	}
}

postfix operator §

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public postfix func §<T: UIView>(_ lhs: @escaping @autoclosure () -> T) -> UIKitView<_UIViewView<T>, T> { UIKitView(_UIViewView(lhs), update: {_, _ in}) }

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public postfix func §<T: UIViewController>(_ lhs: @escaping @autoclosure () -> T) -> UIKitView<_UIViewControllerView<T>, T> { UIKitView(_UIViewControllerView(lhs), update: {_, _ in}) }

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension UIKitView where Content == _UIViewView<V> {
	
	public init(_ make: @escaping () -> V, update: @escaping (V, Content.VContext) -> Void = {_, _ in }) {
		self = .init(.init(make), update: update)
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
		self = .init(.init(make), update: update)
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
	var update: (V, VContext) -> Void { get set }
	init(_ make: @escaping () -> V)
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct _UIViewView<V: UIView>: UIViewRepresentable, UIKitViewWrappable {
	
	let make: () -> V
	public var update: (V, Context) -> Void = { _, _ in }
	
	public init(_ make: @escaping () -> V) {
		self.make = make
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
	public var update: (V, Context) -> Void = { _, _ in }
	
	public init(_ make: @escaping () -> V) {
		self.make = make
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

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func uiKitViewEnvironment<T: UIView>(for type: T.Type) -> UIKitViewEnvironment<T, Self> {
		UIKitViewEnvironment(content: self)
	}
	
	public func uiKitViewEnvironment<T: UIViewController>(for type: T.Type) -> UIKitViewEnvironment<T, Self> {
		UIKitViewEnvironment(content: self)
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	fileprivate var uikit: (Any) -> Void {
		get { self[UIKitKey.self] }
		set { self[UIKitKey.self] = newValue }
	}
	
	private enum UIKitKey: EnvironmentKey {
		static var defaultValue: (Any) -> Void { { _ in } }
	}
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public struct UIKitViewEnvironment<T, Content: View>: Chaining, View {
	public var apply: (inout T) -> Void = { _ in }
	public let content: Content
//	private var ketPathes: [PartialKeyPath<T>: Any] = [:]
	
	public var body: some View {
		content
			.transformEnvironment(\.uikit) { closure in
				let cl = closure
				closure = {
					cl($0)
					if var t = $0 as? T {
						apply(&t)
					}
				}
			}
	}
//
//	public mutating func onGetProperty<P>(_ keyPath: WritableKeyPath<T, P>, _ value: P) {
//		ketPathes[keyPath] = value
//	}
	
	public subscript<A>(dynamicMember keyPath: KeyPath<T, A>) -> ChainProperty<Self, A> {
		ChainProperty(self, getter: keyPath)
	}
}
#endif
