//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import UIKit
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: _ExpressibleByColorLiteral {
	
	public init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
		self = Color(.displayP3, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
	}
	
	public var ui: UIColor {
		if #available(iOS 14.0, *) {
			return UIColor(self)
		} else {
			if self == .clear { return .clear }
			let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
			var hexNumber: UInt64 = 0
			var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
			
			let result = scanner.scanHexInt64(&hexNumber)
			if result {
				r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
				g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
				b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
				a = CGFloat(hexNumber & 0x000000ff) / 255
			}
			return UIColor(red: r, green: g, blue: b, alpha: a)
		}
	}
}
