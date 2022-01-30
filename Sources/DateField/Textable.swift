//
//  Textable.swift
//  DateField
//
//  Created by Данил Войдилов on 28.01.2022.
//

#if canImport(UIKit)
import Foundation
import UIKit

protocol Textable: UIView {
	var textColor: UIColor! { get set }
	var text: String? { get set }
	var textFrame: CGRect { get }
	var fullText: String? { get }
	var placeholderColor: UIColor { get set }
	func set(text: String?, isBackspaced: Bool, animated: Bool)
	func set(textColor: UIColor!, placeholderColor: UIColor)
}

class CustomLabel: UILabel, Textable {

	var fullText: String? { text }
	
	var textFrame: CGRect {
		textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
	}
	
	var placeholderColor: UIColor = UIColor._label.withAlphaComponent(0.5) {
		didSet {
			if oldValue != placeholderColor {
				checkPlaceholder()
			}
		}
	}
	var placeholder: String? {
		didSet {
			if oldValue != placeholder {
				checkPlaceholder()
			}
		}
	}
	override var text: String? {
		didSet {
			if oldValue != text {
				checkPlaceholder()
			}
		}
	}
	override var textColor: UIColor! {
		get { super.textColor }
		set {
			super.textColor = newValue
			_textColor = newValue
		}
	}
	override var attributedText: NSAttributedString? {
		didSet {
			if oldValue != attributedText, text == placeholder {
				super.textColor = placeholderColor
			}
		}
	}
	private var _textColor: UIColor = ._label
	
	private func checkPlaceholder() {
		if text == placeholder {
			super.textColor = placeholderColor
		} else {
			super.textColor = _textColor
		}
	}
	
	func set(text: String?, isBackspaced: Bool, animated: Bool) {
		self.text = text
	}
	
	func set(textColor: UIColor!, placeholderColor: UIColor) {
		self.textColor = textColor
		self.placeholderColor = placeholderColor
	}
}
#endif
