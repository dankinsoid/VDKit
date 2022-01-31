//
//  UIDateField.swift
//  DateField
//
//  Created by Данил Войдилов on 27.01.2022.
//

#if canImport(UIKit)
import Foundation
import UIKit
import VDDates
import VDUIKit

open class UIDateField: UIControl, UIKeyInput, UITextInputTraits {
	
	public var spacing: CGFloat {
		get { stack.spacing }
		set { stack.spacing = newValue }
	}
	
//	private let caret = UIView()
	
	public var edgeInsets: UIEdgeInsets {
		get {
			UIEdgeInsets(
				top: stackTop?.constant ?? 0,
				left: stackLeading?.constant ?? 0,
				bottom: stackTop?.constant ?? 0,
				right: -(stackTrailing?.constant ?? 0)
			)
		}
		set {
			guard newValue != edgeInsets else { return }
			stackTop?.constant = max(newValue.top, newValue.bottom)
			stackLeading?.constant = newValue.left
			stackTrailing?.constant = -newValue.right
			setNeedsLayout()
		}
	}
	
	open var format: DateFormat {
		get { _format }
		set {
			set(format: newValue, style: _style)
		}
	}
	open var font: UIFont = .systemFont(ofSize: 16) {
		didSet {
			if oldValue != font {
				views.forEach {
					$0.font = font
				}
				invalidateIntrinsicContentSize()
				setNeedsLayout()
			}
		}
	}
	open var placeholderColor: UIColor {
		get { _placeholderColor }
		set {
			guard newValue != _placeholderColor else { return }
			_placeholderColor = newValue
			views.forEach {
				$0.placeholderColor = newValue
			}
		}
	}
	private var _placeholderColor: UIColor = ._label.withAlphaComponent(0.5)
	
	open override var tintColor: UIColor! {
		didSet {
			if isFirstResponder, oldValue != tintColor {
				updateTextColors()
			}
		}
	}
	
	private var _format: DateFormat = "\(.day) \(.month) \(.year)"
	open var style: [Calendar.Component: ComponentStyle] {
		get { _style }
		set {
			set(format: _format, style: newValue)
		}
	}
	private var _style: [Calendar.Component: ComponentStyle] = [:]
	open var isEditing: Bool {
		get { isFirstResponder }
		set {
			guard newValue != isFirstResponder else { return }
			_ = newValue ? superBecomeResponder() : superResignResponder()
		}
	}
	open var onEditingChange: (Bool) -> Void = { _ in }
	open var onChange: (Date?, [Calendar.Component: Int]) -> Void = { _, _ in }
	
	open var dateComponents: [Calendar.Component: Int] {
		get {
			Dictionary(
				format.enumerated()
					.compactMap { args in
						args.element.component.flatMap { comp in
							value(for: args.offset, full: true).map { (comp, $0) }
						}
					},
				uniquingKeysWith: { _, p in p }
			)
		}
		set {
			set(components: newValue)
		}
	}
	
	public var date: Date? {
		get {
			_date
		}
		set {
			set(date: newValue)
		}
	}
	public var text: String {
		views.compactMap({ $0.text }).joined()
	}
	public var isEmpty: Bool {
		!format.indices.contains {
			view($0).text != empty($0)
		}
	}
	private var _date: Date?
	private var needReset = true
	
	open var keyboardType: UIKeyboardType {
		get {
			let format = format(_currentIndex)
			return format.component.flatMap {
				_style[$0]?.keyboard
			} ?? format.defaultStyle.keyboard
		}
		set {
			if let component = format(_currentIndex).component {
				_style[component, default: format(_currentIndex).defaultStyle].keyboard = newValue
				reloadInputViews()
			}
		}
	}
	
	open var textContentType: UITextContentType! {
		get {
			if #available(iOS 15.0, *) {
				return _textContentType ?? .dateTime
			} else {
				return _textContentType ?? .name
			}
		}
		set {
			_textContentType = newValue
		}
	}
	private var _textContentType: UITextContentType?
	
	private var _currentIndex: Int = 0
	private let stack = UIStackView()
	private weak var stackLeading: NSLayoutConstraint?
	private weak var stackTrailing: NSLayoutConstraint?
	private weak var stackTop: NSLayoutConstraint?
	private var views: [Textable] = []
	private var wasConfigured = false
	var needUpdate = true
	open override var canBecomeFirstResponder: Bool { true }
	
	open var textColor: UIColor {
		get { _textColor }
		set {
			guard _textColor != newValue else { return }
			_textColor = newValue
			views.forEach {
				$0.textColor = newValue
			}
		}
	}
	private var _textColor: UIColor = ._label
	
	open override var intrinsicContentSize: CGSize {
		CGSize(
			width: UIView.noIntrinsicMetric,
			height: ("|" as NSString).size(withAttributes: [.font: font]).height * 2.5
		)
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		afterInit()
	}
	
	public init(format: DateFormat, style: [Calendar.Component: ComponentStyle] = [:]) {
		self._format = format
		self._style = style
		super.init(frame: .zero)
		afterInit()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		afterInit()
	}
	
	open func afterInit() {
		contentPriority.vertical.hugging = .defaultHigh
		contentPriority.horizontal.both = .defaultLow
		clipsToBounds = true
		configureStack()
		configureRecongnizer()
		configureViews()
	}
	
	open func set(format: DateFormat, style: [Calendar.Component: ComponentStyle] = [:]) {
		guard !wasConfigured || format != _format || style != _style else { return }
		self._format = format
		self._style = style
		configureViews()
	}
	
	open func set(components: [Calendar.Component: Int], merge: Bool = true, animated: Bool = true) {
		format.enumerated().forEach {
			if let comp = $0.element.component {
				if let value = components[comp] {
					view($0.offset).set(text: text(for: comp, format: $0.element.format, value: value), isBackspaced: false, animated: animated)
				} else if !merge {
					view($0.offset).set(text: empty($0.offset), isBackspaced: false, animated: animated)
				}
			}
		}
		if isFilled {
			_date = Date(components: DateComponents(rawValue: components))
		} else {
			_date = nil
		}
	}
	
	open func set(date: Date?, animated: Bool = true) {
		if _date != date || date == nil {
			set(components: date?.components().rawValue ?? [:], merge: false, animated: animated)
		}
	}
	
	open var hasText: Bool {
		views.enumerated().contains { view in
			let empty = self.empty(view.offset)
			return (view.element.text?.nilIfEmpty ?? empty) != empty
		}
	}
	
	open var isFilled: Bool {
		!format.enumerated().filter({ $0.element.string == nil }).contains {
			!isFilled(at: $0.offset, full: false)
		}
	}
	
	open func insertText(_ text: String) {
		let maxLength = self.format(_currentIndex).maxLenght
		changeText(isBackspaced: false) { current in
			if self.needReset {
				current = String(text.prefix(maxLength ?? text.count))
			} else {
				current += text
			}
		}
		needReset = false
		if isFilled(at: _currentIndex, full: true) {
			increaseCurrent()
		}
	}
	
	open func deleteBackward() {
		changeText(isBackspaced: true) {[self] current in
			guard !current.isEmpty else {
				if _currentIndex > 0 {
					decreaseCurrent()
					deleteBackward()
				}
				return
			}
			needReset = false
			current.removeLast()
		}
	}
	
	open func setColors(text: UIColor, placeholder: UIColor, tint: UIColor) {
		guard text != _textColor || placeholder != _placeholderColor || tintColor != tint else {
			return
		}
		_textColor = text
		_placeholderColor = placeholder
		super.tintColor = tint
		updateTextColors()
	}
	
	private func changeText(isBackspaced: Bool, _ action: @escaping (inout String) -> Void) {
		let empty = self.empty(_currentIndex)
		let _action: (inout String) -> Void = {
			var value = $0 == empty ? "" : $0
			action(&value)
			$0 = value.nilIfEmpty ?? empty
		}
		let view = self.view(_currentIndex)
		var current = view.text ?? ""
		_action(&current)
		view.set(text: current, isBackspaced: isBackspaced, animated: false)
		updateTextColors()
		notify()
	}
	
	private func configureViews() {
		wasConfigured = true
		stack.arrangedSubviews.forEach {
			stack.removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
		views = format.enumerated().map { createView(for: $0.element, i: $0.offset) }
		views.forEach(stack.addArrangedSubview)
		updateTextColors()
	}
	
	private func configureStack() {
		stack.axis = .horizontal
		stack.alignment = .center
		addSubview(stack)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stackLeading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		stackTrailing = stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
		stackTrailing?.priority = .defaultHigh
		stackTop = stack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
		stackTop?.priority = .defaultHigh
		[stackLeading, stackTrailing, stackTop, stack.centerYAnchor.constraint(equalTo: centerYAnchor)].forEach {
			$0?.isActive = true
		}
	}
	
	private func configureRecongnizer() {
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(recognized))
		recognizer.delegate = self
		addGestureRecognizer(recognizer)
	}
	
	@objc func recognized(_ recognizer: UITapGestureRecognizer) {
		switch recognizer.state {
		case .ended:
			onTouchUpInside(location: recognizer.location(in: self))
		default:
			break
		}
	}
	
	private func onTouchUpInside(location: CGPoint) {
		if !isFirstResponder {
			becomeFirstResponder()
		}
		
		if var i = views.firstIndex(where: {
			let rect = $0.convert($0.bounds, to: self)
			return CGRect(x: rect.minX, y: 0, width: rect.width, height: frame.height).contains(location)
		}) {
			while i > 0, format(i).string != nil {
				i -= 1
			}
			while i <= _format.count - 1, format(i).string != nil {
				i += 1
			}
			set(index: i)
		}
	}
	
//	private func configureCaret() {
//		caret.isHidden = true
//		caret.translatesAutoresizingMaskIntoConstraints = false
//		addSubview(caret)
//	}
//
//	private func setCaretFrame() {
//		guard !views.isEmpty, !caret.isHidden else { return }
//		layoutIfNeeded()
//		caret.frame.size.height = ("|" as NSString).size(withAttributes: [.font: font]).height
//		caret.frame.size.width = 2
//		caret.layer.cornerRadius = 1
//		let currentView = view(_currentIndex)
//		let textFrame = currentView.convert(currentView.textFrame, to: self)
//		let text = (currentView.text == empty(_currentIndex) ? "" : currentView.text) ?? ""
//		let textWidth = (text as NSString).size(withAttributes: [.font: font]).width
//		caret.frame.origin.y = (frame.height - caret.frame.height) / 2
//		caret.frame.origin.x = textFrame.minX + textWidth
//	}
	
	private func createView(for element: DateFormat.Element, i: Int) -> Textable {
		switch element {
		case .component(let component, _):
			if let array = component.allCases {
				let picker = CustomPicker()
				picker.translatesAutoresizingMaskIntoConstraints = false
				picker.set(textColor: _textColor, placeholderColor: _placeholderColor)
				picker.contentPriority.horizontal.both = .defaultLow
				picker.createLabel = {[weak self] in
					self?.label("", placeholder: self?.empty(i)) ?? CustomLabel()
				}
				picker.font = font
				let emptyString = empty(i)
				picker.items = [emptyString] + array.map {
					text(for: component, format: element.format, value: $0)
				}
				picker.menuItems = [emptyString] + array.map {
					text(for: component, format: DateFormat.Element.component(component, style: .spellOut).format, value: $0)
				}
				picker.onSelect = {[weak self] string in
					guard let self = self else { return }
					if !self.set(index: i) {
						self.updateTextColors()
					}
					self.notify()
				}
				picker.widthAnchor.constraint(equalToConstant: picker.pickerView(picker, widthForComponent: 0)).isActive = true
				return picker
			} else {
				let empty = empty(i)
				return label(empty, placeholder: empty)
			}
		case .string(let text):
			return label(text, placeholder: nil)
		case .custom:
			let empty = empty(i)
			return label(empty, placeholder: empty)
		}
	}
	
	private func increaseCurrent(from value: Int? = nil) {
		var i = (value ?? _currentIndex) + 1
		while i < _format.count, _format[i].string != nil {
			i += 1
		}
		set(index: i)
	}
	
	private func decreaseCurrent(from value: Int? = nil) {
		var i = (value ?? _currentIndex) - 1
		while i >= 0, _format[i].string != nil {
			i -= 1
		}
		set(index: i)
	}
	
	@discardableResult
	private func set(index: Int) -> Bool {
		let i = max(0, min(index, format.count - 1))
		if !format.isEmpty, index >= format.count, isFilled {
			resignFirstResponder()
			_currentIndex = i
			return false
		}
		guard _currentIndex != i else { return false }
		needReset = true
		let oldKeyboard = keyboardType
		_currentIndex = i
		if isFirstResponder, keyboardType != oldKeyboard {
			superResignResponder()
			superBecomeResponder(setIndex: false)
		}
//		setCaretFrame()
		updateTextColors()
		return true
	}
	
	private func format(_ i: Int) -> DateFormat.Element {
		_format[safe: i] ?? .string("")
	}
	
	private func view(_ i: Int) -> Textable {
		views[safe: i] ?? CustomLabel()
	}
	
	private func updateTextColors() {
		let constants = format.enumerated()
		for (offset, element) in constants {
			let isHighlighted = isFirstResponder && offset == _currentIndex
			let color = isHighlighted ? tintColor : textColor
			let plcColor = (isHighlighted ? color?.withAlphaComponent(0.5) : placeholderColor) ?? .clear
			let view = view(offset)
			if element.string == nil || offset == 0 || isFilled(at: offset - 1, full: false) {
				view.set(textColor: color, placeholderColor: plcColor)
			} else {
				view.set(textColor: plcColor, placeholderColor: plcColor)
			}
		}
	}
	
	private func isFilled(at i: Int, full: Bool) -> Bool {
		guard i >= 0, i < views.count else { return false }
		let format = format(i)
		let view = view(i)
		if view.text == empty(i) {
			return false
		}
		if let maxLenght = format.maxLenght, (view.text?.count ?? 0) >= maxLenght {
			return true
		}
		if let value = value(for: i, full: false) {
			let onlyNumbers = view.text?.onlyNumbers == view.text
			if full, onlyNumbers, let comp = format.component, let max = comp.maxValue {
				return value * 10 > max
			} else {
				return !full || !onlyNumbers
			}
		}
		return false
	}
	
	private func empty(_ i: Int) -> String {
		let f = format(i)
		return f.component.flatMap({ _style[$0]?.empty }) ?? f.defaultStyle.empty
	}
	
	private func label(_ text: String, placeholder: String?) -> CustomLabel {
		let label = CustomLabel()
		label.textColor = textColor
		label.text = text
		label.textAlignment = .center
		label.font = font
		label.lineBreakMode = .byClipping
		label.contentPriority.horizontal.both = .required
		label.placeholderColor = placeholderColor
		label.placeholder = placeholder
		return label
	}
	
	private func value(for i: Int, full: Bool) -> Int? {
		value(i: i, text: (full ? view(i).fullText : view(i).text) ?? "")
	}
	
	private func value(i: Int, text: String) -> Int? {
		guard let component = format(i).component else {
			return Int(text)
		}
		if empty(i) == text {
			return nil
		}
		return Date(from: text, format: format(i).format)?.component(component)
	}
	
	private func text(for component: Calendar.Component, format: String, value: Int) -> String {
		(Date(components: [component: value]) ?? defaultDate(for: component, value: value)).string(format)
	}
	
	private func defaultDate(for component: Calendar.Component, value: Int) -> Date {
		var result = Date()
		result.set(value, component)
		return result
	}
	
	private func notify() {
		if isFilled {
			_date = Date(components: DateComponents(rawValue: dateComponents))
		} else {
			_date = nil
		}
		onChange(_date, dateComponents)
//		setCaretFrame()
	}

	@discardableResult
	override open func becomeFirstResponder() -> Bool {
		let isResponder = isFirstResponder
		let result = superBecomeResponder()
		if result, !isResponder {
			onEditingChange(true)
		}
		return result
	}
	
	@discardableResult
	override open func resignFirstResponder() -> Bool {
		let isResponder = isFirstResponder
		let result = superResignResponder()
		if result, isResponder {
			onEditingChange(false)
		}
		return result
	}
	
	@discardableResult
	private func superResignResponder() -> Bool {
		let result = super.resignFirstResponder()
		updateTextColors()
		needReset = true
		return result
	}
	
	@discardableResult
	private func superBecomeResponder(setIndex: Bool = true) -> Bool {
		let result = super.becomeFirstResponder()
		if setIndex {
			let i = views.enumerated().first(where: { $0.element.text == empty($0.offset) })?.offset ?? 0
			if !set(index: i) {
				updateTextColors()
			}
		}
		return result
	}
	
	public struct ComponentStyle: Equatable {
		public var keyboard: UIKeyboardType = .numberPad
		public var empty: String = "-"
	}
}

extension UIDateField: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
#endif
