//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.05.2021.
//

import Foundation
import SwiftUI
import VDMirror

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	static var bodyString: String {
		if Body.self == Never.self {
			return "Never"
		} else {
			return String(describing: Body.self) + "." + Body.bodyString
		}
	}
	
	public var viewTag: AnyHashable? {
		guard Self.bodyString.contains("TagValueTraitKey") else { return nil }
		return _tag
	}
	
	private var _tag: AnyHashable? {
		if let tag = Mirror(reflecting: self).recursive(path: ["modifier", "value", "tagged"]) as? AnyHashable {
			return tag
		}
		return body._tag
	}
}
