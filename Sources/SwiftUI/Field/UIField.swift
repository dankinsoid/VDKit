//
//  File.swift
//  
//
//  Created by Данил Войдилов on 27.11.2021.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
open class UIField<Input: View>: UITextField, UITextFieldDelegate {
	public var onCommit: () -> Void = {}
	public var onDelete: () -> Void = {}
	public var onEditingChange: (Bool) -> Void = { _ in }
	public var onChange: (String) -> Void = { _ in }
	public var onChangeSelection: (Range<Int>) -> Void = { _ in }
	public var resignOnCommit = true
	var isUpdating = false
	
	private var hostingInput: UIHostingController<Input>? {
		didSet {
			let vc = KeyboardViewController()
			vc.hosting = hostingInput
			_inputViewController = vc
		}
	}
	
	private var _inputViewController : UIInputViewController?
	
	override open var inputViewController: UIInputViewController? {
		get { _inputViewController }
		set { _inputViewController = newValue }
	}
	
	public var edgeInsets: UIEdgeInsets = .init() {
		didSet { if oldValue != edgeInsets { setNeedsLayout() } }
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		afterInit()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		afterInit()
	}
	
	private func afterInit() {
		delegate = self
		setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
		DispatchQueue.main.async {[self] in
			isUpdating = true
			onChangeSelection(selectedRange)
			isUpdating = false
		}
	}
	
	open func textFieldShouldClear(_ textField: UITextField) -> Bool {
		true
	}
	
	open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		defer {
			onCommit()
			if resignOnCommit {
				resignFirstResponder()
			}
		}
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
	
	func setInput(view: Input) {
		guard Input.self != EmptyInputView.self else { return }
		if let hostingInput = hostingInput {
			hostingInput.rootView = view
		} else {
			hostingInput = SelfSizingHostingController(rootView: view)
		}
	}
	
	var selectedRange: Range<Int> {
		get { range(from: selectedTextRange) }
		set { selectedTextRange = textRange(from: newValue) }
	}
	
	func setTextAndCursor(_ string: String, selected: UITextRange? = nil) {
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
	
	func range(from range: UITextRange?) -> Range<Int> {
		let from = offset(from: beginningOfDocument, to: range?.start ?? endOfDocument)
		let to = offset(from: beginningOfDocument, to: range?.end ?? endOfDocument)
		return from..<to
	}
	
	func textRange(from range: Range<Int>) -> UITextRange? {
		textRange(
			from: position(from: beginningOfDocument, offset: range.lowerBound) ?? endOfDocument,
			to: position(from: beginningOfDocument, offset: range.upperBound) ?? endOfDocument
		)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UIField {
	
	private final class SelfSizingHostingController: UIHostingController<Input> {
		
		override func viewDidLoad() {
			super.viewDidLoad()
			view.backgroundColor = .clear
		}
		
		override func viewDidLayoutSubviews() {
			super.viewDidLayoutSubviews()
			self.view.invalidateIntrinsicContentSize()
		}
	}
	
	private final class KeyboardViewController: UIInputViewController {
		
		var hosting: UIHostingController<Input>? {
			didSet {
				guard let vc = hosting else { return }
				loadViewIfNeeded()
				addChild(vc)
				vc.view.translatesAutoresizingMaskIntoConstraints = false
				view.addSubview(vc.view)
				view.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
				view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
				view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
				view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
			}
		}
		
		override func viewDidLoad() {
			super.viewDidLoad()
			inputView?.translatesAutoresizingMaskIntoConstraints = false
			inputView?.allowsSelfSizing = true
		}
	}
}
#endif
