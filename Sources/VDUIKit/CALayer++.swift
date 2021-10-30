//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import UIKit

extension CALayer {
	public var superlayers: [CALayer] {
		superlayer.map { [$0] + $0.superlayers } ?? []
	}
	
	public var transformInWindow: CATransform3D {
		([self] + superlayers).reversed().reduce(.identity) { $0.concatenating($1.transform)
		}
	}
}
