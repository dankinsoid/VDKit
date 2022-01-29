//
//  CustomPicker.swift
//  DateField
//
//  Created by Данил Войдилов on 27.01.2022.
//

#if canImport(UIKit)
import Foundation
import VDCommon
import UIKit

final class CustomPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource, Textable {
	private(set) weak var selectionView: UIView?
	
	var items: [String] = [] {
		didSet {
			reload()
		}
	}
	var menuItems: [String] = []
	
	var createLabel: () -> CustomLabel = CustomLabel.init {
		didSet {
			reload()
		}
	}
	var textColor: UIColor! = ._label {
		didSet {
			if oldValue != textColor {
				update()
			}
		}
	}
	var fullText: String? { items[safe: selectedRow(inComponent: 0)] }
	var text: String? {
		get {
			_text
		}
		set {
			set(text: newValue, animated: false)
		}
	}
	var textFrame: CGRect {
		guard let view = view(forRow: selectedRow(inComponent: 0), forComponent: 0) as? Textable else {
			return bounds
		}
		return view.convert(view.textFrame, to: self)
	}
	
	private var _text: String?
	var font: UIFont = .systemFont(ofSize: 12) {
		didSet {
			if oldValue != font {
				update()
				invalidateIntrinsicContentSize()
			}
		}
	}
	var onSelect: (String) -> Void = { _ in }
	var placeholderColor: UIColor = UIColor._label.withAlphaComponent(0.5) {
		didSet {
			if placeholderColor != oldValue {
				update()
			}
		}
	}
	
	override var intrinsicContentSize: CGSize {
		CGSize(
			width: UIView.noIntrinsicMetric,
			height: ("|" as NSString).size(withAttributes: [.font: font]).height * 3.75
		)
	}
	
	private func selectOrReload(_ i: Int, animated: Bool) {
		if selectedRow(inComponent: 0) == i {
			reload()
		}
		selectRow(i, inComponent: 0, animated: animated)
	}
	
	func set(text: String?, animated: Bool) {
		let isBackspaced = (text ?? "").count < (_text ?? "").count && _text?.hasPrefix(text ?? "") == true
		guard !isBackspaced else {
			_text = items.first
			selectOrReload(0, animated: animated)
			return
		}
		let lower = text?.lowercased() ?? ""
		let allLowercased = items.map { $0.lowercased() }.enumerated()
		let matched = allLowercased.filter({ $0.element.hasPrefix(lower) }).nilIfEmpty ?? allLowercased.filter({ $0.element.contains(lower) })
		if matched.count == 1 {
			_text = items[matched[0].offset]
			selectOrReload(matched[0].offset, animated: animated)
		} else if let i = matched.first?.offset {
			let range = matched[0].element.intRange(of: lower) ?? 0..<matched[0].element.count
			_text = items[i][range]
			selectOrReload(i, animated: animated)
		}
	}
	
	func reload() {
		let selected = selectedRow(inComponent: 0)
		reloadComponent(0)
		selectRow(selected, inComponent: 0, animated: false)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		afterInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		afterInit()
	}
	
	private func afterInit() {
		findSelection()
		delegate = self
		dataSource = self
		
		if #available(iOS 13.0, *) {
			let interaction = UIContextMenuInteraction(delegate: self)
			addInteraction(interaction)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		findSelection()
		if #available(iOS 15.0, *) {} else {
			clipsToBounds = false
			allSubviews().forEach {
				$0.clipsToBounds = false
			}
		}
	}
	
	private func findSelection() {
		guard selectionView == nil else { return }
		selectionView = allSubviews().first(
			where: { $0.layer.cornerRadius > 0 && ($0.backgroundColor ?? .clear) != .clear }
		)
		updateSelection()
	}
	
	private func updateSelection() {
		selectionView?.alpha = 0
		selectionView?.isHidden = true
	}
	
	static let rowHeight: CGFloat = 63
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		items.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		items[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		_text = items[row]
		update()
		onSelect(items[row])
	}
	
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		items.map {
			($0 as NSString).size(withAttributes: [.font: font]).width + font.pointSize / 8
		}.max() ?? 40
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		items.map {
			($0 as NSString).size(withAttributes: [.font: font]).height
		}.max() ?? 40
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let label = (view as? CustomLabel) ?? createLabel()
		update(label: label, row: row)
		return label
	}
	
	func update() {
		items.indices.compactMap { i in
			(view(forRow: i, forComponent: 0) as? CustomLabel).map { (i, $0) }
		}.forEach { args in
			update(label: args.1, row: args.0)
		}
	}
	
	private func update(label: CustomLabel, row: Int) {
		label.textColor = textColor
		label.placeholderColor = placeholderColor
		label.placeholder = items.first
		if !items[row].isEmpty, let common = items[row].lowercased().intRange(of: _text?.lowercased() ?? "") {
			let text = NSMutableAttributedString(string: items[row])
			var ranges: [NSRange] = []
			if common.lowerBound > 0 {
				ranges.append(NSRange(location: 0, length: common.lowerBound + 1))
			}
			if common.upperBound < items[row].count {
				ranges.append(NSRange(location: common.upperBound, length: items[row].count - common.upperBound))
			}
			ranges.forEach {
				text.addAttributes([.foregroundColor: placeholderColor], range: $0)
			}
			label.attributedText = text
		} else {
			label.text = items[row]
		}
	}
}

@available(iOS 13.0, *)
extension CustomPicker: UIContextMenuInteractionDelegate {
	
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		guard !items.isEmpty, menuItems.count == items.count else { return nil }
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {[weak self] elements in
			let actions = self?.menuItems.enumerated().map { args in
				UIAction(title: args.element) { _ in
					self?.selectOrReload(args.offset, animated: true)
					self?.pickerView(self!, didSelectRow: args.offset, inComponent: 0)
				}
			} ?? []
			if #available(iOS 15.0, *) {
				return UIMenu(title: "", image: nil, identifier: nil, options: .singleSelection, children: actions)
			} else {
				return UIMenu(title: "", image: nil, identifier: nil, options: [], children: actions)
			}
		}
	}
}

extension String {
	
	func intRange(of substring: String) -> Range<Int>? {
		guard let range = range(of: substring) else { return nil }
		return distance(from: startIndex, to: range.lowerBound)..<distance(from: startIndex, to: range.upperBound)
	}
}
#endif
