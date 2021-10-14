//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Field<Input: View>: UIViewRepresentable {
	
	@Binding public var text: String
	public let placeholder: String
	public var isEditing: Binding<Bool>?
	public var selection: Binding<Range<Int>>?
	public let inputView: Input
	
	public init(_ text: Binding<String>, placeholder: String = "", isEditing: Binding<Bool>? = nil, selection: Binding<Range<Int>>? = nil, @ViewBuilder input: () -> Input) {
		self._text = text
		self.placeholder = placeholder
		self.isEditing = isEditing
		self.selection = selection
		self.inputView = input()
	}
	
	public func makeUIView(context: Context) -> UIField<Input> {
		let result = UIField<Input>()
		if inputView as? EmptyInputView == nil {
			result.hostingInput = UIHostingController(rootView: inputView)
		}
		return result
	}
	
	public func updateUIView(_ uiView: UIField<Input>, context: Context) {
		guard !uiView.isUpdating else { return }
		uiView.font = context.environment.font?.uiFont
		uiView.textColor = context.environment.fieldTextColor.ui
		uiView.setTextAndCursor(text, selected: selection.flatMap { uiView.textRange(from: $0.wrappedValue) })
		uiView.onCommit = context.environment.fieldOnCommit
		uiView.textContentType = context.environment.fieldTextContentType
		uiView.keyboardType = context.environment.fieldKeyboardType
		uiView.keyboardAppearance = context.environment.fieldKeyboardStyle
		uiView.autocapitalizationType = context.environment.fieldAutocapitalization
		uiView.returnKeyType = context.environment.fieldReturnKey
		uiView.isSecureTextEntry = context.environment.fieldIsSecure
		uiView.autocorrectionType = context.environment.disableAutocorrection == true ? .no : .yes
		uiView.smartInsertDeleteType = context.environment.fieldSmartInsertDelete
		uiView.smartQuotesType = context.environment.fieldSmartQuotes
		uiView.smartDashesType = context.environment.fieldSmartDashes
		uiView.spellCheckingType = context.environment.fieldSpellChecking
		uiView.edgeInsets = context.environment.fieldEdgeInsets.ui
		uiView.textAlignment = context.environment.multilineTextAlignment.ns
		uiView.hostingInput?.rootView = inputView
		
		uiView.onEditingChange = { value in
            if value != isEditing?.wrappedValue {
                isEditing?.wrappedValue = value
            }
            context.environment.fieldOnChangeEditing(value)
		}
		uiView.onChange = { value in
			if value != text { text = value }
		}
		uiView.onChangeSelection = { value in
            if value != selection?.wrappedValue { selection?.wrappedValue = value }
		}
		uiView.onDelete = context.environment.fieldOnDelete
		
		let attributedPlaceholder = NSMutableAttributedString(
			string: placeholder,
			attributes: [.foregroundColor: context.environment.fieldPlaceholderColor.ui]
		)
		if let font = context.environment.placeholderFont?.uiFont {
			attributedPlaceholder.addAttribute(.font, value: font, range: NSRange(0..<placeholder.count))
		}
		uiView.attributedPlaceholder = attributedPlaceholder
		if let isEditing = self.isEditing?.wrappedValue, uiView.isEditing != isEditing {
			_ = isEditing ? uiView.becomeFirstResponder() : uiView.resignFirstResponder()
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Field where Input == EmptyInputView {
	
	public init(_ text: Binding<String>, placeholder: String = "", isEditing: Binding<Bool>? = nil, selection: Binding<Range<Int>>? = nil) {
		self = Field(text, placeholder: placeholder, isEditing: isEditing, selection: selection) { EmptyInputView() }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct EmptyInputView: View {
	public var body: some View { EmptyView() }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
open class UIField<Input: View>: UITextField, UITextFieldDelegate {
	public var onCommit: () -> Void = {}
	public var onDelete: () -> Void = {}
	public var onEditingChange: (Bool) -> Void = { _ in }
	public var onChange: (String) -> Void = { _ in }
	public var onChangeSelection: (Range<Int>) -> Void = { _ in }
	var isUpdating = false
	var hostingInput: UIHostingController<Input>? {
		didSet {
			hostingInput?.loadViewIfNeeded()
			inputView = hostingInput?.view
		}
	}
	
	public var edgeInsets: UIEdgeInsets = .init() {
		didSet { if oldValue != edgeInsets { setNeedsLayout() } }
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		delegate = self
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		delegate = self
	}
	
	open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		true
	}
	
	open func textFieldDidBeginEditing(_ textField: UITextField) {
		isUpdating = true
		onEditingChange(true)
		isUpdating = false
	}
	
	open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		true
	}
	
	open func textFieldDidEndEditing(_ textField: UITextField) {
		isUpdating = true
		onEditingChange(false)
		isUpdating = false
	}
	
	open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		isUpdating = true
		onEditingChange(false)
		isUpdating = false
	}
	
	open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let newText = ((text ?? "") as NSString).replacingCharacters(in: range, with: string)
		onChange(newText)
		return false
	}
	
	open func textFieldDidChangeSelection(_ textField: UITextField) {
		isUpdating = true
		onChangeSelection(selectedRange)
		isUpdating = false
	}
	
	open func textFieldShouldClear(_ textField: UITextField) -> Bool {
		true
	}
	
	open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		onCommit()
		return true
	}
	
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		super.textRect(forBounds: bounds).inset(by: edgeInsets)
	}
	
	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		super.editingRect(forBounds: bounds).inset(by: edgeInsets)
	}
	
	override open func deleteBackward() {
		super.deleteBackward()
		onDelete()
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldTextColorKey: EnvironmentKey {
	static var defaultValue: Color { .black }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldPlaceholderColorKey: EnvironmentKey {
	static var defaultValue: Color { #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1) }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldOnCommitKey: EnvironmentKey {
	static var defaultValue: () -> Void { {} }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldOnDeleteKey: EnvironmentKey {
	static var defaultValue: () -> Void { {} }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldOnChangEditingKey: EnvironmentKey {
	static var defaultValue: (Bool) -> Void { { _ in } }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum PlaceholderFontKey: EnvironmentKey {
	static var defaultValue: Font? { nil }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum TextContentTypeKey: EnvironmentKey {
	static var defaultValue: UITextContentType { .nickname }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum KeyboardTypeKey: EnvironmentKey {
	static var defaultValue: UIKeyboardType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum KeyboardStyleKey: EnvironmentKey {
	static var defaultValue: UIKeyboardAppearance { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum AutocapitalizationKey: EnvironmentKey {
	static var defaultValue: UITextAutocapitalizationType { .none }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldReturnKey: EnvironmentKey {
	static var defaultValue: UIReturnKeyType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldSecureKey: EnvironmentKey {
	static var defaultValue: Bool { false }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldSmartInsertDeleteKey: EnvironmentKey {
	static var defaultValue: UITextSmartInsertDeleteType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldSmartQuotesKey: EnvironmentKey {
	static var defaultValue: UITextSmartQuotesType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldSmartDashesKey: EnvironmentKey {
	static var defaultValue: UITextSmartDashesType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldSpellCheckingKey: EnvironmentKey {
	static var defaultValue: UITextSpellCheckingType { .default }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum FieldInsetsKey: EnvironmentKey {
	static var defaultValue: EdgeInsets { .init() }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var fieldTextColor: Color {
		get { self[FieldTextColorKey.self] }
		set { self[FieldTextColorKey.self] = newValue }
	}
	
	public var fieldPlaceholderColor: Color {
		get { self[FieldPlaceholderColorKey.self] }
		set { self[FieldPlaceholderColorKey.self] = newValue }
	}
	
	public var placeholderFont: Font? {
		get { self[PlaceholderFontKey.self] }
		set { self[PlaceholderFontKey.self] = newValue }
	}
	
	public var fieldOnCommit: () -> Void {
		get { self[FieldOnCommitKey.self] }
		set { self[FieldOnCommitKey.self] = newValue }
	}
	
	public var fieldOnDelete: () -> Void {
		get { self[FieldOnDeleteKey.self] }
		set { self[FieldOnDeleteKey.self] = newValue }
	}
	
	public var fieldOnChangeEditing: (Bool) -> Void {
		get { self[FieldOnChangEditingKey.self] }
		set { self[FieldOnChangEditingKey.self] = newValue }
	}
	
	public var fieldTextContentType: UITextContentType {
		get { self[TextContentTypeKey.self] }
		set { self[TextContentTypeKey.self] = newValue }
	}
	
	public var fieldKeyboardType: UIKeyboardType {
		get { self[KeyboardTypeKey.self] }
		set { self[KeyboardTypeKey.self] = newValue }
	}
	
	public var fieldKeyboardStyle: UIKeyboardAppearance {
		get { self[KeyboardStyleKey.self] }
		set { self[KeyboardStyleKey.self] = newValue }
	}
	
	public var fieldAutocapitalization: UITextAutocapitalizationType {
		get { self[AutocapitalizationKey.self] }
		set { self[AutocapitalizationKey.self] = newValue }
	}
	
	public var fieldReturnKey: UIReturnKeyType {
		get { self[FieldReturnKey.self] }
		set { self[FieldReturnKey.self] = newValue }
	}
	
	public var fieldIsSecure: Bool {
		get { self[FieldSecureKey.self] }
		set { self[FieldSecureKey.self] = newValue }
	}
	
	public var fieldSmartInsertDelete: UITextSmartInsertDeleteType {
		get { self[FieldSmartInsertDeleteKey.self] }
		set { self[FieldSmartInsertDeleteKey.self] = newValue }
	}
	
	public var fieldSmartQuotes: UITextSmartQuotesType {
		get { self[FieldSmartQuotesKey.self] }
		set { self[FieldSmartQuotesKey.self] = newValue }
	}
	
	public var fieldSmartDashes: UITextSmartDashesType {
		get { self[FieldSmartDashesKey.self] }
		set { self[FieldSmartDashesKey.self] = newValue }
	}
	
	public var fieldSpellChecking: UITextSpellCheckingType {
		get { self[FieldSpellCheckingKey.self] }
		set { self[FieldSpellCheckingKey.self] = newValue }
	}
	
	public var fieldEdgeInsets: EdgeInsets {
		get { self[FieldInsetsKey.self] }
		set { self[FieldInsetsKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func field(textColor color: Color) -> some View {
		environment(\.fieldTextColor, color)
	}
	
	public func placeholderColor(_ color: Color) -> some View {
		environment(\.fieldPlaceholderColor, color)
	}
	
	public func placeholderFont(_ font: Font) -> some View {
		environment(\.placeholderFont, font)
	}
	
	public func fieldOnCommit(_ block: @escaping () -> Void) -> some View {
		OnCommitView(content: self, action: block)
	}
	
	public func fieldOnDelete(_ block: @escaping () -> Void) -> some View {
		OnDeleteView(content: self, action: block)
	}
	
	public func fieldOnChangeEditing(_ block: @escaping (Bool) -> Void) -> some View {
		OnChangeEditingView(content: self, action: block)
	}
	
	public func field(textContent type: UITextContentType) -> some View {
		environment(\.fieldTextContentType, type)
	}
	
	public func field(keyboard type: UIKeyboardType) -> some View {
		environment(\.fieldKeyboardType, type)
	}
	
	public func field(keyboardStyle style: UIKeyboardAppearance) -> some View {
		environment(\.fieldKeyboardStyle, style)
	}
	
	public func field(autocapitalization type: UITextAutocapitalizationType) -> some View {
		environment(\.fieldAutocapitalization, type)
	}
	
	public func field(returnKey type: UIReturnKeyType) -> some View {
		environment(\.fieldReturnKey, type)
	}
	
	public func field(isSecure: Bool) -> some View {
		environment(\.fieldIsSecure, isSecure)
	}
	
	public func field(smartInsertDelete: UITextSmartInsertDeleteType) -> some View {
		environment(\.fieldSmartInsertDelete, smartInsertDelete)
	}
	
	public func field(smartQuotes: UITextSmartQuotesType) -> some View {
		environment(\.fieldSmartQuotes, smartQuotes)
	}
	
	public func field(smartDashes: UITextSmartDashesType) -> some View {
		environment(\.fieldSmartDashes, smartDashes)
	}
	
	public func field(spellChecking: UITextSpellCheckingType) -> some View {
		environment(\.fieldSpellChecking, spellChecking)
	}
	
	public func field(edgeInsets: EdgeInsets) -> some View {
		environment(\.fieldEdgeInsets, edgeInsets)
	}
	
	public func field(edgeInset: CGFloat, at edges: Edge.Set) -> some View {
		environment(\.fieldEdgeInsets, EdgeInsets(edgeInset, edges))
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct OnCommitView<Content: View>: View {
	@Environment(\.fieldOnCommit) var onCommit
	let content: Content
	let action: () -> Void
	
	var body: some View {
		content.environment(\.fieldOnCommit) {
			onCommit()
			action()
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct OnDeleteView<Content: View>: View {
	@Environment(\.fieldOnDelete) var onDelete
	let content: Content
	let action: () -> Void
	
	var body: some View {
		content.environment(\.fieldOnDelete) {
			onDelete()
			action()
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct OnChangeEditingView<Content: View>: View {
	@Environment(\.fieldOnChangeEditing) var onChangeEditing
	let content: Content
	let action: (Bool) -> Void
	
	var body: some View {
		content.environment(\.fieldOnChangeEditing) {
			onChangeEditing($0)
			action($0)
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Field_Previews: PreviewProvider {
	
	static var previews: some View {
		Preview()
	}
	
	struct Preview: View {
		@State private var text = "text"
		@State private var selection = 0..<3
		
		var body: some View {
			VStack {
				Field($text, placeholder: "fff", selection: $selection)
					.font(.system(size: 26).italic())
					.field(textColor: .green)
					.field(keyboard: .numberPad)
					.field(edgeInset: 16, at: .horizontal)
					.placeholderColor(.red)
					.accentColor(.green)
					.previewLayout(.fixed(width: 300, height: 56))
					.height(56)
				Text("\(selection)" as String)
			}
		}
	}
}
