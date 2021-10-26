//
//  File.swift
//  
//
//  Created by Данил Войдилов on 26.10.2021.
//

import UIKit

extension UILabel {
	public convenience init(_ text: String) {
		self.init(frame: .zero)
		self.text = text
	}
	
	public convenience init(_ text: NSAttributedString) {
		self.init(frame: .zero)
		self.attributedText = text
	}
}
