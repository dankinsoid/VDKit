//
//  CG++.swift
//  Challenger
//
//  Created by Daniil on 10.05.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

import CoreGraphics
import QuartzCore

public protocol PareProtocol {
  associatedtype Left
  associatedtype Right
  var pare: (Left, Right) { get }
  init(pare: (Left, Right))
}

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
  
  public var minXminY: CGPoint { origin }
  public var minXmaxY: CGPoint { CGPoint(x: minX, y: maxY) }
  public var maxXminY: CGPoint { CGPoint(x: maxX, y: minY) }
  public var maxXmaxY: CGPoint { CGPoint(x: maxX, y: maxY) }
  
  public var midXminY: CGPoint { CGPoint(x: midX, y: minY) }
  public var midXmaxY: CGPoint { CGPoint(x: midX, y: maxY) }
  public var maxXmidY: CGPoint { CGPoint(x: maxX, y: midY) }
  public var minXmidY: CGPoint { CGPoint(x: minX, y: midY) }
  
  public static func between(_ lhs: CGPoint, _ rhs: CGPoint) -> CGRect {
    CGRect(
      origin: CGPoint(
        x: min(lhs.x, rhs.x),
        y: min(lhs.y, rhs.y)
      ),
      size: CGSize(
        width: abs(lhs.x - rhs.x),
        height: abs(lhs.y - rhs.y)
      )
    )
  }
  
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

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGRect {
  public subscript(_ unionPoint: UnitPoint) -> CGPoint {
    CGPoint(
      x: minX + unionPoint.x * width,
      y: minY + unionPoint.y * height
    )
  }
}
#endif

public enum HorizontalEdge {
  case left, right
}

public enum VerticalEdge {
  case top, bottom
}

extension CGPoint: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		x.hash(into: &hasher)
		y.hash(into: &hasher)
	}
}

extension CGSize: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		width.hash(into: &hasher)
		height.hash(into: &hasher)
	}
}
