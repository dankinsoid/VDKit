//
//  String++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension String {
    
	public func firstUppercased() -> String {
		isEmpty ? self : (first?.uppercased() ?? "") + dropFirst()
	}
	
	public var asAttributed: NSMutableAttributedString {
		NSMutableAttributedString(string: self)
	}
	
	public subscript(_ index: Int) -> Character {
		get { self[self.index(startIndex, offsetBy: index)] }
		set {
			if index < count {
				let i = self.index(startIndex, offsetBy: index)
				replaceSubrange(i...i, with: [newValue])
			} else {
				append(newValue)
			}
		}
	}
	
	public subscript<R: RangeExpression>(_ range: R) -> String where R.Bound == Int {
		get { String(self[range.convert(for: self)]) }
		set {
			replaceSubrange(range.convert(for: self).clamped(to: startIndex..<endIndex), with: newValue)
		}
	}
	
	public var range: Range<String.Index> { startIndex..<endIndex }
	
	public func commonSuffix(with aString: String) -> String {
		var suffix = ""
		var first = self
		var second = aString
		while let symbol = first.last, !second.isEmpty, first.last == second.last {
			first.removeLast()
			second.removeLast()
			suffix.insert(symbol, at: suffix.startIndex)
		}
		return suffix
	}
	
	public var onlyNumbers: String {
		String(filter { $0.isNumber })
	}
	
	public var base64: String {
		Data(utf8).base64EncodedString()
	}
	
	public var isEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailPredicate.evaluate(with: self)
	}
}

extension StringProtocol {
	
	public var string: String {
		String(self)
	}
}

public extension CharacterSet {
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy(contains)
	}
}
