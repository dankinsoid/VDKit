//
//  File.swift
//  
//
//  Created by Данил Войдилов on 27.11.2021.
//
#if canImport(UIKit)
import SwiftUI
import UIKit
import VDSwiftUICommon

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
		environment(\.fieldOnCommit, block)
	}
	
	public func fieldOnDelete(_ block: @escaping () -> Void) -> some View {
		environment(\.fieldOnDelete, block)
	}
	
	public func fieldOnChangeEditing(_ block: @escaping (Bool) -> Void) -> some View {
		environment(\.fieldOnChangeEditing, block)
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
#endif
