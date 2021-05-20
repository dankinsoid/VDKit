//
//  File.swift
//  
//
//  Created by Данил Войдилов on 11.01.2021.
//

import Foundation
import UIKit

extension CATransform3D {
	
	public static var identity: CATransform3D { CATransform3DIdentity }
	
	public var affine: CGAffineTransform {
		CATransform3DGetAffineTransform(self)
	}
	
	public static func scale(x: CGFloat, y: CGFloat, z: CGFloat = 1) -> CATransform3D {
		CATransform3DIdentity.scaled(x: x, y: y, z: z)
	}
	
	public static func scale(_ xy: CGFloat) -> CATransform3D {
		CATransform3DIdentity.scaled(xy)
	}
	
	public static func translate(x: CGFloat, y: CGFloat, z: CGFloat = 0) -> CATransform3D {
		CATransform3DIdentity.translated(x: x, y: y, z: z)
	}
	
	public static func translate(_ xy: CGPoint) -> CATransform3D {
		CATransform3DIdentity.translated(xy)
	}
	
	public static func rotate(_ angle: CGFloat, x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 1) -> CATransform3D {
		CATransform3DIdentity.rotated(angle, x: x, y: y, z: z)
	}
	
	public func scaled(x: CGFloat, y: CGFloat, z: CGFloat = 1) -> CATransform3D {
		CATransform3DScale(self, x, y, z)
	}
	
	public func scaled(_ xy: CGFloat) -> CATransform3D {
		CATransform3DScale(self, xy, xy, 1)
	}
	
	public func translated(x: CGFloat, y: CGFloat, z: CGFloat = 0) -> CATransform3D {
		CATransform3DTranslate(self, x, y, z)
	}
	
	public func translated(_ xy: CGPoint) -> CATransform3D {
		CATransform3DTranslate(self, xy.x, xy.y, 0)
	}
	
	public func rotated(_ angle: CGFloat, x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 1) -> CATransform3D {
		CATransform3DRotate(self, angle, x, y, z)
	}
	
	public var inverted: CATransform3D {
		CATransform3DInvert(self)
	}
	
	public func concatenating(_ other: CATransform3D) -> CATransform3D {
		CATransform3DConcat(self, other)
	}
	
	public func added(_ other: CATransform3D) -> CATransform3D {
		let new = CATransform3DConcat(self, other)
		return CATransform3D(
			m11: new.m11, m12: new.m12, m13: new.m13, m14: new.m14,
			m21: new.m21, m22: new.m22, m23: new.m23, m24: new.m24,
			m31: new.m31, m32: new.m32, m33: new.m33, m34: new.m34,
			m41: m41 + other.m41, m42: m42 + other.m42, m43: m43 + other.m43, m44: new.m44
		)
	}
}

extension CGAffineTransform {
	
	public var transform3d: CATransform3D {
		CATransform3DMakeAffineTransform(self)
	}
	
	public var offset: CGPoint {
		get { CGPoint(x: tx, y: ty) }
		set {
			tx = newValue.x
			ty = newValue.y
		}
	}
	
	public var scale: CGSize {
		CGSize(
			width: c == 0 ? a : (a > 0 ? 1 : -1) * sqrt(pow(a, 2) + pow(c, 2)),
			height: b == 0 ? d : (d > 0 ? 1 : -1) * sqrt(pow(b, 2) + pow(d, 2))
		)
	}
	
	public var angle: CGFloat {
		atan2(b, a)
	}
	
	public func added(_ other: CGAffineTransform) -> CGAffineTransform {
		let scale1 = scale
		let scale2 = other.scale
		var result = CGAffineTransform.identity
			.rotated(by: angle + other.angle)
			.scaledBy(x: scale1.width * scale2.width, y: scale1.height * scale2.height)
		result.tx = tx + other.tx
		result.ty = ty + other.ty
		return result
	}
}

extension CATransform3D: Equatable {
	
	private var ms: [CGFloat] { [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44] }
	
	public static func ==(_ lhs: CATransform3D, _ rhs: CATransform3D) -> Bool {
		lhs.ms == rhs.ms
	}
}
