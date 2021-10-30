import Foundation
import VDBuilders

extension NSAttributedString {
    
	public static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
		let string = NSMutableAttributedString(attributedString: lhs)
		string.append(NSMutableAttributedString(attributedString: rhs))
		return string
	}
}

extension NSMutableAttributedString {
	
	public static func += (lhs: inout NSMutableAttributedString, rhs: NSAttributedString) {
		lhs = lhs + rhs
	}
	
	public static func += (lhs: inout NSMutableAttributedString, rhs: String) {
		lhs = lhs + NSMutableAttributedString(string: rhs)
	}
}

extension NSAttributedString: Collection {
    
	public typealias Index = Int
	
	public struct Element {
		let character: Character
		let attributes: [NSAttributedString.Key : Any]
	}
	
	public subscript(position: Int) -> NSAttributedString.Element {
		guard position >= startIndex && position < endIndex else {
			fatalError()
		}
		let attrs = attributes(at: position, longestEffectiveRange: nil, in: NSRange(location: position, length: 1))
		let index = string.index(string.startIndex, offsetBy: position)
		return Element(character: string[index], attributes: attrs)
	}
	
	public var count: Int {
		length
	}
	
	public func index(before i: Int) -> Int {
		i - 1
	}
	
	public func index(after i: Int) -> Int {
		i + 1
	}
	
	public var startIndex: Int {
		0
	}
	
	public var endIndex: Int {
		count
	}
}

extension NSAttributedString {
    
	public func color(_ color: UIColor?) -> NSMutableAttributedString {
		return attribute(.foregroundColor, value: color)
	}
	
	public func font(_ font: UIFont?) -> NSMutableAttributedString {
		return attribute(.font, value: font)
	}
	
	public func paragraph(_ style: NSParagraphStyle?) -> NSMutableAttributedString {
		return attribute(.paragraphStyle, value: style)
	}
	
	public func background(_ color: UIColor?) -> NSMutableAttributedString {
		return attribute(.backgroundColor, value: color)
	}
	
	public func ligature(_ value: Int = 1) -> NSMutableAttributedString {
		return attribute(.ligature, value: NSNumber(value: value))
	}
	
	public func stroke(_ color: UIColor?, width: Double = 0) -> NSMutableAttributedString {
		var attrs: [NSAttributedString.Key: Any] = [.strokeWidth: NSNumber(value: Float(width))]
		if let color = color {
			attrs[.strokeColor] = color
		}
		return attributes(attrs)
	}
	
	public func kerning(_ kerning: Double = 0) -> NSAttributedString {
		return attribute(.kern, value: NSNumber(value: Float(kerning)))
	}
	
	public func shadow(color: UIColor?, offset: CGSize = .zero, blur: CGFloat) -> NSMutableAttributedString {
		let shadow = NSShadow()
		shadow.shadowColor = color
		shadow.shadowOffset = offset
		shadow.shadowBlurRadius = blur
		return attribute(.shadow, value: shadow)
	}
	
	public func bold() -> NSMutableAttributedString {
		guard let font = attribute(.font, at: 0, longestEffectiveRange: nil, in: range) as? UIFont,
					let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) else {
			return NSMutableAttributedString(attributedString: self)
		}
		return attribute(.font, value: UIFont(descriptor: descriptor, size: font.pointSize))
	}
	
	public func italic() -> NSMutableAttributedString {
		guard let font = attribute(.font, at: 0, longestEffectiveRange: nil, in: range) as? UIFont,
					let descriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) else {
			return NSMutableAttributedString(attributedString: self)
		}
		return attribute(.font, value: UIFont(descriptor: descriptor, size: font.pointSize))
	}
	
	public func strikethrough(_ style: NSUnderlineStyle, color: UIColor? = nil) -> NSMutableAttributedString {
		var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSNumber(value: style.rawValue)]
		if let color = color {
			attrs[.strikethroughColor] = color
		}
		return attributes(attrs)
	}
	
	public func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> NSMutableAttributedString {
		var attrs: [NSAttributedString.Key: Any] = [.underlineStyle: NSNumber(value: style.rawValue)]
		if let color = color {
			attrs[.underlineColor] = color
		}
		return attributes(attrs)
	}
	
	public func baselineOffset(_ offset: Double?) -> NSMutableAttributedString {
		var number: NSNumber?
		if let offset = offset {
			number = NSNumber(value: Float(offset))
		}
		return attribute(.baselineOffset, value: number)
	}
	
	private func attribute(_ key: NSAttributedString.Key, value: Any?) -> NSMutableAttributedString {
		guard let value = value else { return NSMutableAttributedString(attributedString: self) }
		let attributed = NSMutableAttributedString(attributedString: self)
		attributed.addAttribute(key, value: value)
		return attributed
	}
	
	private func attributes(_ attrs: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
		let attributed = NSMutableAttributedString(attributedString: self)
		attributed.addAttributes(attrs)
		return attributed
	}
}

extension NSAttributedString {
	fileprivate var range: NSRange {
		return NSRange(location: 0, length: length)
	}
}

extension NSMutableAttributedString {
    
	fileprivate func addAttributes(_ attrs: [NSAttributedString.Key: Any]) {
		addAttributes(attrs, range: range)
	}
	
	fileprivate func addAttribute(_ name: NSAttributedString.Key, value: Any) {
		addAttribute(name, value: value, range: range)
	}
}

public typealias AttributedStringBuilder = ComposeBuilder<AttributedArrayInitable>

public struct AttributedArrayInitable: ArrayInitable {
	public static func create(from: [NSAttributedString]) -> NSAttributedString {
		let result = NSMutableAttributedString()
		from.forEach(result.append)
		return result
	}
}

public extension ComposeBuilder where C == AttributedArrayInitable {
	
	@inlinable
	static func buildExpression(_ text: String) -> NSAttributedString {
		NSAttributedString(string: text, attributes: [:])
	}
	
	@inlinable
	static func buildExpression(_ attr: NSAttributedString) -> NSAttributedString {
		attr
	}
}

#if canImport(UIKit)
import UIKit

public extension ComposeBuilder where C == AttributedArrayInitable {
	
	@inlinable
	static func buildExpression(_ image: UIImage) -> NSAttributedString {
		let attachment = NSTextAttachment()
		attachment.image = image
		return NSAttributedString(attachment: attachment)
	}
	
	@inlinable
	static func buildExpression(_ attachment: NSTextAttachment) -> NSAttributedString {
		NSAttributedString(attachment: attachment)
	}
}
#endif

extension NSAttributedString {
	
	public convenience init(@AttributedStringBuilder builder: () -> NSAttributedString) {
		self.init(attributedString: builder())
	}
	
	func withAttributes(_ attrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
		let copy = NSMutableAttributedString(attributedString: self)
		copy.addAttributes(attrs, range: NSRange(location: 0, length: string.count))
		return copy
	}
}
