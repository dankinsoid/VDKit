//
//  DragAndDrop.swift
//  MonthCalendar
//
//  Created by Данил Войдилов on 29.09.2021.
//

import SwiftUI

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
extension View {
	
	public func dragAndDropCanvas() -> some View {
		modifier(DragAndDropCanvas())
	}
	
	public func dragAndDrop<Value, Draggable: View, Placeholder: View>(_ value: Value, minimumPressDurtion: Double = 0.5, @ViewBuilder draggable: @escaping (CGPoint) -> Draggable, @ViewBuilder placeholder: () -> Placeholder) -> some View {
		modifier(DragModifier(value: value, minimumPressDurtion: minimumPressDurtion, draggable: draggable, placeholder: placeholder()))
	}
	
	public func dragAndDrop<Value>(_ value: Value, minimumPressDurtion: Double = 0.5) -> some View {
		modifier(DragModifier(value: value, minimumPressDurtion: minimumPressDurtion, draggable: { _ in self }, placeholder: EmptyView()))
	}
	
	public func dragAndDrop<Value, Placeholder: View>(_ value: Value, minimumPressDurtion: Double = 0.5, @ViewBuilder placeholder: () -> Placeholder) -> some View {
		modifier(DragModifier(value: value, minimumPressDurtion: minimumPressDurtion, draggable: { _ in self }, placeholder: placeholder()))
	}
	
	public func dragAndDrop<Value, Draggable: View>(_ value: Value, minimumPressDurtion: Double = 0.5, @ViewBuilder draggable: @escaping (CGPoint) -> Draggable) -> some View {
		modifier(DragModifier(value: value, minimumPressDurtion: minimumPressDurtion, draggable: draggable, placeholder: EmptyView()))
	}
	
	public func dragAndDrop<Draggable: View, Placeholder: View>(minimumPressDurtion: Double = 0.5, @ViewBuilder draggable: @escaping (CGPoint) -> Draggable, @ViewBuilder placeholder: () -> Placeholder) -> some View {
		modifier(DragModifier(value: (), minimumPressDurtion: minimumPressDurtion, draggable: draggable, placeholder: placeholder()))
	}
	
	public func dragAndDrop(minimumPressDurtion: Double = 0.5) -> some View {
		modifier(DragModifier(value: (), minimumPressDurtion: minimumPressDurtion, draggable: { _ in self }, placeholder: EmptyView()))
	}
	
	public func dragAndDrop<Placeholder: View>(minimumPressDurtion: Double = 0.5, @ViewBuilder placeholder: () -> Placeholder) -> some View {
		modifier(DragModifier(value: (), minimumPressDurtion: minimumPressDurtion, draggable: { _ in self }, placeholder: placeholder()))
	}
	
	public func dragAndDrop<Draggable: View>(minimumPressDurtion: Double = 0.5, @ViewBuilder draggable: @escaping (CGPoint) -> Draggable) -> some View {
		modifier(DragModifier(value: (), minimumPressDurtion: minimumPressDurtion, draggable: draggable, placeholder: EmptyView()))
	}
	
	public func onDrop<T>(_ type: T.Type, action: @escaping (T, CGPoint) -> Void) -> some View {
		modifier(
			DropModifier {
				guard $2, let value = $0 as? T else { return }
				action(value, $1)
			}
		)
	}
	
	public func onDrop(_ action: @escaping (CGPoint) -> Void) -> some View {
		onDrop(Void.self) { _, point in
			action(point)
		}
	}
	
	public func onDrag<T>(_ type: T.Type, action: @escaping (T, CGPoint) -> Void) -> some View {
		modifier(
			DropModifier {
				guard !$2, let value = $0 as? T else { return }
				action(value, $1)
			}
		)
	}
	
	public func onDrag(_ action: @escaping (CGPoint) -> Void) -> some View {
		onDrag(Void.self) { _, point in
			action(point)
		}
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
private struct DragAndDropCanvas: ViewModifier {
	
	@StateObject private var manager = DragAndDropManager()
	@Namespace private var namespace
	
	private var draggingView: DragViewInfo? {
		manager.draggingId.flatMap { manager.views[$0] }
	}
	
	func body(content: Content) -> some View {
		ZStack(alignment: .topLeading) {
			content
				.onPreferenceChange(DropPreference.self) {
					manager.drops = $0.value
				}
			
			draggingView.map { info in
				ZStack {
					info.draggView
						.offset(CGSize(width: manager.offset.width, height: manager.offset.height))
				}
				.matchedGeometryEffect(id: info.id, in: namespace, isSource: false)
			}
		}
		.coordinateSpace(name: namespace)
		.environmentStateObject(manager)
		.environment(\.namespace, namespace)
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
enum DropPreference: PreferenceKey {
	struct Value: Equatable {
		var value: [UUID: (Any, CGPoint, Bool) -> Void] = [:]
		
		static func ==(_ lhs: Value, _ rhs: Value) -> Bool {
			Set(lhs.value.keys) == Set(rhs.value.keys)
		}
	}
	
	static var defaultValue: Value { Value() }
	
	static func reduce(value: inout Value, nextValue: () -> Value) {
		value.value.merge(nextValue().value, uniquingKeysWith: {_, p in p })
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
struct DropModifier: ViewModifier {
	@State private var id = UUID()
	@State private var frame = CGRect.zero
	@Environment(\.namespace) private var namespace
	var action: (Any, CGPoint, Bool) -> Void
	
	func body(content: Content) -> some View {
		content
			.bindFrame(in: .named(namespace), to: $frame)
			.preference(key: DropPreference.self, value: .init(value: [id: _action]))
	}
	
	private func _action(value: Any, location: CGPoint, isDropped: Bool) {
		guard frame.contains(location) else { return }
		action(value, CGPoint(x: location.x - frame.minX, y: location.y - frame.minY), isDropped)
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
private final class DragAndDropManager: ObservableObject {
	@Published var touch: DragGesture.Value?
	var offset: CGSize { touch?.translation ?? .zero }
	var location: CGPoint { touch?.location ?? .zero }
	@Published var views: [UUID: DragViewInfo] = [:]
	@Published var drops: [UUID: (Any, CGPoint, Bool) -> Void] = [:]
	@Published var draggingId: UUID?
	var started: Bool { draggingId != nil }
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
private struct DragViewInfo: Identifiable {
	var id: UUID
	var draggView: AnyView
	
	static func == (lhs: DragViewInfo, rhs: DragViewInfo) -> Bool {
		lhs.id == rhs.id
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
private struct DragModifier<Value, Draggable: View, Placeholder: View>: ViewModifier {
	
	let value: Value
	let minimumPressDurtion: Double
	let draggable: (CGPoint) -> Draggable
	let placeholder: Placeholder
	@State private var id = UUID()
	@Environment(\.namespace) var namespace
	@EnvironmentStateObject var manager = DragAndDropManager()
	
	func body(content: Content) -> some View {
		ZStack {
			content
				.opacity(manager.draggingId == nil ? 1 : 0)
			if manager.draggingId != nil {
				placeholder
			}
		}
		.onTapGesture {}
		.gesture(
			SequenceGesture(
				LongPressGesture(minimumDuration: minimumPressDurtion)
					.onEnded { _ in
						manager.views[id] = DragViewInfo(id: id, draggView: AnyView(draggable(.zero)))
						withAnimation {
							manager.draggingId = id
						}
					},
				DragGesture(minimumDistance: 0, coordinateSpace: .named(namespace))
					.onChanged { value in
						manager.views[id] = DragViewInfo(id: id, draggView: AnyView(draggable(value.location)))
						manager.touch = value
						manager.drops.forEach {
							$0.value(self.value, value.location, false)
						}
					}
					.onEnded { value in
						withAnimation {
							manager.draggingId = nil
							manager.drops.forEach {
								$0.value(self.value, manager.location, true)
							}
							manager.touch = nil
						}
					}
			)
		)
		.matchedGeometryEffect(id: id, in: namespace, isSource: true)
	}
}

@available(iOS 14.0, OSX 10.16, tvOS 14.0, watchOS 7.0, *)
// MARK: Environments
private extension EnvironmentValues {
	
	var namespace: Namespace.ID {
		get { self[\.namespace] ?? Namespace().wrappedValue }
		set { self[\.namespace] = newValue }
	}
	
	var canvasId: UUID {
		get { self[\.canvasId] ?? UUID() }
		set { self[\.canvasId] = newValue }
	}
}
