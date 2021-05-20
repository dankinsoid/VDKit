//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension TextAlignment {
	public var ns: NSTextAlignment {
		switch self {
		case .leading:	return .left
		case .center:		return .center
		case .trailing:	return .right
		}
	}
}

extension NSTextAlignment {
	
	@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
	public var swiftUi: TextAlignment {
		switch self {
		case .left:				return .leading
		case .center:			return .center
		case .right:			return .trailing
		case .justified:	return .center
		case .natural:		return .leading
		@unknown default:	return .leading
		}
	}
}
