//
//  CG++.swift
//  Challenger
//
//  Created by Daniil on 10.05.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import UIKit

extension UIView.ContentMode {
    
    public func frame(of rect: CGRect, in frame: CGRect) -> CGRect {
        let ratio = rect.height == 0 ? 0 : rect.width / rect.height
        var fitHSize = CGSize(width: 0, height: min(rect.height, frame.height))
        fitHSize.width = ratio * fitHSize.height
        var fitWSize = CGSize(width: min(rect.width, frame.width), height: 0)
        fitWSize.height = ratio == 0 ? frame.height : fitWSize.width / ratio
        let fitSize = CGSize(width: min(fitHSize.width, fitWSize.width), height:  min(fitHSize.height, fitWSize.height))
        let fillSize = CGSize(width: max(fitHSize.width, fitWSize.width), height:  max(fitHSize.height, fitWSize.height))
        let bounds = CGRect(origin: .zero, size: frame.size)
        switch self {
        case .scaleToFill:      return frame
        case .scaleAspectFit:   return CGRect(origin: bounds.center - fitSize / 2, size: fitSize)
        case .scaleAspectFill:  return CGRect(origin: bounds.center - fillSize / 2, size: fillSize)
        case .redraw:           return rect
        case .center:           return CGRect(origin: bounds.center - rect.size / 2, size: rect.size)
        case .top:              return CGRect(origin: CGPoint(x: bounds.center.x - rect.width / 2, y: 0), size: rect.size)
        case .bottom:           return CGRect(origin: CGPoint(x: bounds.center.x - rect.width / 2, y: frame.height), size: rect.size)
        case .left:             return CGRect(origin: CGPoint(x: 0, y: bounds.center.y - rect.height / 2), size: rect.size)
        case .right:            return CGRect(origin: CGPoint(x: frame.width, y: bounds.center.y - rect.height / 2), size: rect.size)
        case .topLeft:          return CGRect(origin: bounds.corner(.top, .left), size: rect.size)
        case .topRight:         return CGRect(origin: bounds.corner(.top, .right), size: rect.size)
        case .bottomLeft:       return CGRect(origin: bounds.corner(.bottom, .left), size: rect.size)
        case .bottomRight:      return CGRect(origin: bounds.corner(.bottom, .right), size: rect.size)
        @unknown default:       return rect
        }
    }
    
}

public protocol PareProtocol {
    associatedtype Left
    associatedtype Right
    var pare: (Left, Right) { get }
    init(pare: (Left, Right))
}
/*
public protocol NumericPare: Numeric, PareProtocol where Left: Numeric, Right: Numeric, Left.IntegerLiteralType: FixedWidthInteger, Right.IntegerLiteralType: FixedWidthInteger, Left.Magnitude == Left, Right.Magnitude == Right {
    associatedtype IntegerLiteralType = Int
    associatedtype Magnitude = Left.
}

extension NumericPare {
    public var magnitude: Int {
        let (l, r) = pare
        return Self.init(pare: (l.magnitude, r.magnitude))
    }
    
    public init(integerLiteral value: Int) {
        self = Self.init(pare: (Left(integerLiteral: Left.IntegerLiteralType.init(value)), Right(integerLiteral: Right.IntegerLiteralType.init(value))))
    }
    
    public init?<T: BinaryInteger>(exactly source: T) {
        guard let left = Left(exactly: source), let right = Right(exactly: source) else { return nil }
        self = Self.init(pare: (left, right))
    }
    
    public static func +(lhs: Self, rhs: Self) -> Self {
        let (l, r) = (lhs.pare, rhs.pare)
        return Self.init(pare: (l.0 + r.0, l.1 + r.1))
    }
    
    public static func *(lhs: Self, rhs: Self) -> Self {
        let (l, r) = (lhs.pare, rhs.pare)
        return Self.init(pare: (l.0 * r.0, l.1 * r.1))
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        let (l, r) = (lhs.pare, rhs.pare)
        return Self.init(pare: (l.0 - r.0, l.1 - r.1))
    }
    
    public static func *=(lhs: inout Self, rhs: Self) { lhs = lhs * rhs }
    public static func -=(lhs: inout Self, rhs: Self) { lhs = lhs - rhs }
    public static func +=(lhs: inout Self, rhs: Self) { lhs = lhs + rhs }
    public static func ==(lhs: Self, rhs: Self) -> Bool { lhs.pare == rhs.pare }
}
*/

extension PareProtocol {
    
    public init<R: PareProtocol>(_ other: R) where Left == R.Left, Right == R.Right {
        self = Self.init(pare: other.pare)
    }
    
}

extension PareProtocol where Right == Left {
    
    public init(square: Left) {
        self = Self.init(pare: (square, square))
    }
    
}

public func +<L: PareProtocol, R: PareProtocol>(_ lhs: L, _ rhs: R) -> L where L.Left == R.Left, L.Left: Numeric, L.Right == R.Right, L.Right: Numeric {
    let (l, r) = (lhs.pare, rhs.pare)
    return L.init(pare: (l.0 + r.0, l.1 + r.1))
}

public func -<L: PareProtocol, R: PareProtocol>(_ lhs: L, _ rhs: R) -> L where L.Left == R.Left, L.Left: Numeric, L.Right == R.Right, L.Right: Numeric {
    let (l, r) = (lhs.pare, rhs.pare)
    return L.init(pare: (l.0 - r.0, l.1 - r.1))
}

extension PareProtocol where Left: Numeric, Left == Right {
    
    public static prefix func -(_ rhs: inout Self) -> Self {
        let r = rhs.pare
        return Self(pare: (-1 * r.0, -1 * r.1))
    }
    
    public static func +(_ lhs: Self, _ rhs: Self) -> Self {
        let (l, r) = (lhs.pare, rhs.pare)
        return Self(pare: (l.0 + r.0, l.1 + r.1))
    }
    
    public static func -(_ lhs: Self, _ rhs: Self) -> Self {
        let (l, r) = (lhs.pare, rhs.pare)
        return Self(pare: (l.0 - r.0, l.1 - r.1))
    }
    
    public static func +(_ lhs: Self, _ rhs: Left) -> Self {
        let l = lhs.pare
        return Self(pare: (l.0 + rhs, y: l.1 + rhs))
    }
    
    public static func -(_ lhs: Self, _ rhs: Left) -> Self {
        let l = lhs.pare
        return Self(pare: (l.0 - rhs, y: l.1 - rhs))
    }
    
    public static func *(_ lhs: Self, _ rhs: Left) -> Self {
        let l = lhs.pare
        return Self(pare: (l.0 * rhs, y: l.1 * rhs))
    }
    
    public static func +(_ lhs: Left, _ rhs: Self) -> Self {
        let r = rhs.pare
        return Self(pare: (lhs + r.0, y: lhs + r.1))
    }
    
    public static func -(_ lhs: Left, _ rhs: Self) -> Self {
        let r = rhs.pare
        return Self(pare: (lhs - r.0, y: lhs - r.1))
    }
    
    public static func *(_ lhs: Left, _ rhs: Self) -> Self {
        let r = rhs.pare
        return Self(pare: (lhs * r.0, y: lhs * r.1))
    }
    
}

extension PareProtocol where Left: FloatingPoint, Left == Right {
        
    public static func /(_ lhs: Self, _ rhs: Left) -> Self {
        let l = lhs.pare
        return Self(pare: (l.0 / rhs, y: l.1 / rhs))
    }
    
    public static func /(_ lhs: Left, _ rhs: Self) -> Self {
        let r = rhs.pare
        return Self(pare: (lhs / r.0, y: lhs / r.1))
    }
}

extension CGPoint: PareProtocol {
    
    public var pare: (CGFloat, CGFloat) { (x, y) }
    
    public init(pare: (CGFloat, CGFloat)) {
        self = CGPoint(x: pare.0, y: pare.1)
    }
    
}

extension CGSize: PareProtocol {
    
    public var pare: (CGFloat, CGFloat) { (width, height) }
    
    public init(pare: (CGFloat, CGFloat)) {
        self = CGSize(width: pare.0, height: pare.1)
    }
    
}

extension CGRect {
    
    public var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }
    
    public func corner(_ horizontal: HorizontalEdge, _ vertical: VerticalEdge) -> CGPoint {
        var result = origin
        if horizontal == .right {
            result.x += width
        }
        if vertical == .bottom {
            result.y += height
        }
        return result
    }
    
    public func corner(_ vertical: VerticalEdge, _ horizontal: HorizontalEdge) -> CGPoint {
        corner(horizontal, vertical)
    }

}

public enum HorizontalEdge {
    case left, right
}

public enum VerticalEdge {
    case top, bottom
}
    
