//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import Foundation

extension Mirror {
	
	public static func description(of value: Any) -> String {
		let mirror = Mirror(reflecting: value)
		if mirror.children.isEmpty {
			return "\(value)"
		} else {
			return "\(type(of: value))(" + mirror.children.map { "\($0.label ?? ""): " + description(of: $0.value) }.joined(separator: ", ") + ")"
		}
	}
	
	var dictionary: [String?: Any] {
		Dictionary(children.map { ($0.label, $0.value) }, uniquingKeysWith: { _, p in p })
	}
}
