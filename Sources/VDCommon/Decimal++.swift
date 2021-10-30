//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import Foundation

extension Decimal {
	
	public var double: Double {
		(self as NSDecimalNumber).doubleValue
	}
	
	public var float: Float {
		(self as NSDecimalNumber).floatValue
	}
}
