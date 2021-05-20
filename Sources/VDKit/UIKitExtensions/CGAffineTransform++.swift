//
//  File.swift
//  
//
//  Created by Данил Войдилов on 05.02.2021.
//

import UIKit

extension CGAffineTransform {
	
	public static func scale<F: BinaryFloatingPoint>(_ x: F, _ y: F) -> CGAffineTransform {
		CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y))
	}
	
	public static func scale<F: BinaryFloatingPoint>(_ k: F) -> CGAffineTransform {
		let f = CGFloat(k)
		return CGAffineTransform(scaleX: f, y: f)
	}
	
	public static func rotate<F: BinaryFloatingPoint>(_ angle: F) -> CGAffineTransform {
		CGAffineTransform(rotationAngle: CGFloat(angle))
	}
	
	public static func translate<F: BinaryFloatingPoint>(_ x: F, _ y: F) -> CGAffineTransform {
		CGAffineTransform(translationX: CGFloat(x), y: CGFloat(y))
	}
}

extension CATransform3D {
	
	public static func rotate<F: BinaryFloatingPoint>(_ angle: F, x: F = 0, y: F = 1, z: F = 0) -> CATransform3D {
		CATransform3DRotate(CATransform3DIdentity, CGFloat(angle), CGFloat(x), CGFloat(y), CGFloat(z))
	}
}
