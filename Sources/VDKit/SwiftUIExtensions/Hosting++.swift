//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UIHostingController {
	public convenience init(@ViewBuilder _ builder: () -> Content) {
		self.init(rootView: builder())
	}
}
