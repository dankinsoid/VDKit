//
//  File.swift
//  
//
//  Created by Данил Войдилов on 09.02.2021.
//

import Foundation

@_functionBuilder
public struct ArrayBuilder {
	
	public static func buildBlock() {}
	
	public static func buildBlock<T>(_ values: T...) -> [T] {
		values
	}
	
}
