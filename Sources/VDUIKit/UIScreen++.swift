//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

extension UIScreen {
	/// The corner radius of the display. Uses a private property of `UIScreen`,
	/// and may report 0 if the API changes.
	public var cornerRadius: CGFloat {
		guard let cornerRadius = self.value(forKey: "_displayCornerRadius") as? CGFloat else {
			return 0
		}
		return cornerRadius
	}
}
#endif
