//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.01.2022.
//

#if canImport(UIKit)
import UIKit

extension UIColor {
	static var _label: UIColor {
		if #available(iOS 13.0, *) {
			return .label
		} else {
			return .black
		}
	}
}
#endif
