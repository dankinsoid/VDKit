//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

extension UIRectCorner {
	public static var top: UIRectCorner { [.topRight, .topLeft] }
	public static var right: UIRectCorner { [.topRight, .bottomRight] }
	public static var left: UIRectCorner { [.topLeft, .bottomLeft] }
	public static var bottom: UIRectCorner { [.bottomRight, .bottomLeft] }
}
#endif
