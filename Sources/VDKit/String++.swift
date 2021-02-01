//
//  String++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension String {
    
	public func firstUppercased() -> String {
		return (first?.uppercased() ?? "") + dropFirst()
	}
	
	public var asAttributed: NSMutableAttributedString {
		return NSMutableAttributedString(string: self)
	}
    
}
