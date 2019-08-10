//
//  CG++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension CGRect {
    
    public var center: CGPoint {
        return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
    }
    
}
