//
//  UIFont++.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//

#if canImport(UIKit)
import UIKit

@available(iOS 11.0, *)
extension UIFont {
	
	public static var scale: CGFloat {
		UIFont.systemFont(ofSize: systemFontSize).scaled.pointSize / systemFontSize
	}
	
	public var scaled: UIFont {
		UIFontMetrics.default.scaledFont(for: self)
	}
}

@available(iOS 11.0, *)
extension UILabel {
	
	@IBInspectable
	public var dynamicFontSize: CGFloat {
		get { return self.font.pointSize * (font.pointSize / font.scaled.pointSize) }
		set { self.font = self.font.withSize(newValue).scaled }
	}
}

@available(iOS 11.0, *)
extension UIButton {
    
	@IBInspectable
	public var dynamicFontSize: CGFloat {
		get {
			guard let label = titleLabel else { return UIFont.systemFontSize }
			return label.font.pointSize * (label.font.pointSize / label.font.scaled.pointSize)
		}
		set {
			guard let label = titleLabel else { return }
			label.font = label.font.withSize(newValue).scaled
		}
	}
}

@available(iOS 11.0, *)
extension UITextView {
    
	@IBInspectable
	public var dynamicFontSize: CGFloat {
		get {
			guard let font = self.font else { return UIFont.systemFontSize }
			return font.pointSize * (font.pointSize / font.scaled.pointSize)
		}
		set { self.font = self.font?.withSize(newValue).scaled }
	}
}

@available(iOS 11.0, *)
extension UITextField {
    
	@IBInspectable
	public var dynamicFontSize: CGFloat {
		get {
			guard let font = self.font else { return UIFont.systemFontSize }
			return font.pointSize * (font.pointSize / font.scaled.pointSize)
		}
		set { self.font = self.font?.withSize(newValue).scaled }
	}
}
#endif
