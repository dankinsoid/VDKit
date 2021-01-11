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
		
}
