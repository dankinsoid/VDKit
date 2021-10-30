//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

extension UIWindow {
	
	@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
	public convenience init(_ windowScene: UIWindowScene, _ root: () -> UIViewController) {
		self.init(windowScene: windowScene)
		rootViewController = root()
	}

	public convenience init(_ root: () -> UIViewController) {
		self.init()
		rootViewController = root()
	}
}
#endif
