//
//  UIColor++.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//

import UIKit

extension UIColor {
    
    public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    public convenience init(_ colors: UIColor...) {
        guard !colors.isEmpty else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        let components: RGBA = colors.map { $0.rgba }.reduce((0, 0, 0, 0), +)
        let cnt = CGFloat(colors.count)
        self.init(red: components.0 / cnt, green: components.1 / cnt, blue: components.2 / cnt, alpha: components.3 / cnt)
    }
    
}

fileprivate typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

fileprivate func +(_ lhs: RGBA, _ rhs: RGBA) -> RGBA {
    return (lhs.0 + rhs.0, lhs.1 + rhs.1, lhs.2 + rhs.2, lhs.3 + rhs.3)
}

extension CGColorSpace {
    
    public static var p3: CGColorSpace? {
        return CGColorSpace(name: CGColorSpace.displayP3)
    }
    
}
