//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import SwiftUI
import UIKit
import VDSwiftUICommon

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
		result.setInput(view: inputView)
		return result
	}
	
	public func updateUIView(_ uiView: UIField<Input>, context: Context) {
		guard !uiView.isUpdating else { return }
		uiView.changeSelection = false
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
		uiView.resignOnCommit = context.environment.fieldHideKeyboardOnCommit
		uiView.textAlignment = context.environment.multilineTextAlignment.ns
		uiView.setInput(view: inputView)
		
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
		uiView.changeSelection = true
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

@available(iOS 14.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Field_Previews: PreviewProvider {
	
	static var previews: some View {
		Preview()
	}
	
	struct Preview: View {
		@State private var text = "text"
		@State private var selection = 0..<3
		
		var body: some View {
			VStack {
				Field($text, placeholder: "fff", selection: $selection) {
					DatePicker(
						"",
						selection: .constant(Date()),
						displayedComponents: [.date]
					)
						.datePickerStyle(.graphical)
				}
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
#endif
