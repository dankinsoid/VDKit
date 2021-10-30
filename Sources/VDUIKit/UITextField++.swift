//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

extension UITextField {
	
	public var selectedRange: Range<Int> {
		get { range(from: selectedTextRange) }
		set { selectedTextRange = textRange(from: newValue) }
	}
	
	public func setTextAndCursor(_ string: String, selected: UITextRange? = nil) {
		guard let selected = selected ?? selectedTextRange else {
			text = string
			return
		}
		guard text != string else {
			selectedTextRange = selected
			return
		}
		let difference = string.count - (text ?? "").count
		text = string
		let selectedLength = offset(from: selected.start, to: selected.end)
		let _offset = selectedLength + difference
		let length = 0
		let startOffset = max(0, min(text?.count ?? 0, offset(from: beginningOfDocument, to: selected.start) + _offset))
		let start = position(from: beginningOfDocument, offset: startOffset) ?? beginningOfDocument
		let end = position(from: start, offset: max(0, min(length, (text?.count ?? 0) - startOffset))) ?? start
		selectedTextRange = textRange(from: start, to: end)
	}
	
	public func textRange(from range: Range<Int>) -> UITextRange? {
		textRange(
			from: position(from: beginningOfDocument, offset: range.lowerBound) ?? endOfDocument,
			to: position(from: beginningOfDocument, offset: range.upperBound) ?? endOfDocument
		)
	}
	
	public func range(from range: UITextRange?) -> Range<Int> {
		let from = offset(from: beginningOfDocument, to: range?.start ?? endOfDocument)
		let to = offset(from: beginningOfDocument, to: range?.end ?? endOfDocument)
		return from..<to
	}
}
#endif
