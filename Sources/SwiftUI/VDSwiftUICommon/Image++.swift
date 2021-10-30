//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image: _ExpressibleByImageLiteral {
	public init(imageLiteralResourceName path: String) {
		self = Image(path)
	}
}
