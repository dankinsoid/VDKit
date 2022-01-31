//
//  DateField.swift
//  DateField
//
//  Created by Данил Войдилов on 27.01.2022.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit
import VDDates
import VDSwiftUICommon
import VDUIKit

@available(iOS 13.0, *)
public struct DateField: UIViewRepresentable {
	public var date: Binding<Date?>
	public var isEditing: Binding<Bool>?
	@Environment(\.dateFieldFormat) private var format: DateFormat
	@Environment(\.dateFieldStyle) private var style: [Calendar.Component: UIDateField.ComponentStyle]
	@Environment(\.dateFieldInsets) private var insets: EdgeInsets
	@Environment(\.dateFieldTextColor) private var textColor: Color?
	@Environment(\.dateFieldPlaceholderColor) private var placeholderColor: Color?
	@Environment(\.font) private var font: Font?
	
	public init(_ date: Binding<Date?>, isEditing: Binding<Bool>? = nil) {
		self.date = date
		self.isEditing = isEditing
	}
	
	public func makeUIView(context: Context) -> UIDateField {
		let result = UIDateField()
		result.contentPriority.vertical.hugging = .defaultLow
		return result
	}
	
	public func updateUIView(_ uiView: UIDateField, context: Context) {
		uiView.set(format: format, style: style)
		if date.wrappedValue != uiView.date {
			context.coordinator.needUpdateDate = false
			uiView.set(date: date.wrappedValue, animated: context.transaction.animation != nil)
			context.coordinator.needUpdateDate = true
		}
		if let isEditing = isEditing?.wrappedValue, isEditing != uiView.isEditing {
			context.coordinator.needUpdateIsEditing = false
			uiView.isEditing = isEditing
			context.coordinator.needUpdateIsEditing = true
		}
		uiView.font = font?.uiFont ?? .systemFont(ofSize: 16)
		uiView.edgeInsets = insets.ui
		uiView.setColors(
			text: textColor?.ui ?? .label,
			placeholder: placeholderColor?.ui ?? .label.withAlphaComponent(0.5),
			tint: Color.accentColor.ui
		)
		
		uiView.onChange = {[date] value, _ in
			guard context.coordinator.needUpdateDate, value != date.wrappedValue else { return }
			date.wrappedValue = value
		}
		uiView.onEditingChange = {[isEditing] in
			guard context.coordinator.needUpdateIsEditing, $0 != isEditing?.wrappedValue else { return }
			isEditing?.wrappedValue = $0
		}
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator()
	}
	
	public final class Coordinator {
		var needUpdateDate = true
		var needUpdateIsEditing = true
	}
}

@available(iOS 13.0, *)
extension View {
	public func dateField(format: DateFormat) -> some View {
		environment(\.dateFieldFormat, format)
	}
	public func dateField(textColor: Color) -> some View {
		environment(\.dateFieldTextColor, textColor)
	}
	public func dateField(placeholderColor: Color) -> some View {
		environment(\.dateFieldPlaceholderColor, placeholderColor)
	}
	public func dateField(style: [Calendar.Component: UIDateField.ComponentStyle]) -> some View {
		environment(\.dateFieldStyle, style)
	}
	public func dateField(insets: EdgeInsets) -> some View {
		environment(\.dateFieldInsets, insets)
	}
}

@available(iOS 13.0, *)
extension EnvironmentValues {
	public var dateFieldTextColor: Color? {
		get { self[\.dateFieldTextColor] ?? nil }
		set { self[\.dateFieldTextColor] = newValue }
	}
	
	public var dateFieldPlaceholderColor: Color? {
		get { self[\.dateFieldPlaceholderColor] ?? dateFieldTextColor?.opacity(0.5) }
		set { self[\.dateFieldPlaceholderColor] = newValue }
	}
	
	public var dateFieldInsets: EdgeInsets {
		get { self[\.dateFieldInsets] ?? .zero }
		set { self[\.dateFieldInsets] = newValue }
	}
	
	public var dateFieldFormat: DateFormat {
		get { self[\.dateFieldFormat] ?? "\(.day) \(.month) \(.year)" }
		set { self[\.dateFieldFormat] = newValue }
	}
	
	public var dateFieldStyle: [Calendar.Component: UIDateField.ComponentStyle] {
		get { self[\.dateFieldStyle] ?? [:] }
		set { self[\.dateFieldStyle] = newValue }
	}
}

@available(iOS 13.0, *)
struct DateField_Previews: PreviewProvider, View {
	@State var date: Date?
	static var previews: some View {
		DateField_Previews()
			.previewLayout(.sizeThatFits)
	}
	
	var body: some View {
		DateField($date)
	}
}
#endif
