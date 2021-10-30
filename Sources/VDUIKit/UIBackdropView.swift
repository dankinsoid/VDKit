//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import UIKit

open class UIBackdropView: UIView {
	
	open override class var layerClass: AnyClass {
		NSClassFromString("CABackdropLayer") ?? CALayer.self
	}
}
#endif
