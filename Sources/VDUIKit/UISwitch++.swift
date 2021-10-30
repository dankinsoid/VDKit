//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

extension UISwitch {
	
	public var offTintColor: UIColor? {
		get { subviews.first?.subviews.first?.backgroundColor }
		set { subviews.first?.subviews.first?.backgroundColor = newValue }
	}
}
#endif
