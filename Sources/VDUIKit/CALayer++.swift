//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import QuartzCore

extension CALayer {
	public var superlayers: [CALayer] {
		superlayer.map { [$0] + $0.superlayers } ?? []
	}
	
	public var transformInWindow: CATransform3D {
		([self] + superlayers).reversed().reduce(CATransform3DIdentity) { CATransform3DConcat($0, $1.transform) }
	}
}
