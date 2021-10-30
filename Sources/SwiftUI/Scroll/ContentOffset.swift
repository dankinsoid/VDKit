//
//  File.swift
//  
//
//  Created by Данил Войдилов on 07.10.2021.
//

import Foundation
import SwiftUI
import VDCoreGraphics

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ContentOffset: Hashable, Equatable, Animatable {
    public var unitPoint: UnitPoint
    public var offset: CGPoint
    
    public init(_ unitPoint: UnitPoint = .topLeading, offset: CGPoint) {
        self.unitPoint = unitPoint
        self.offset = offset
    }
    
    public static let zero = ContentOffset(.zero, offset: .zero)
    public static let center = ContentOffset(.center, offset: .zero)
    public static let leading = ContentOffset(.leading, offset: .zero)
    public static let trailing = ContentOffset(.trailing, offset: .zero)
    public static let top = ContentOffset(.top, offset: .zero)
    public static let bottom = ContentOffset(.bottom, offset: .zero)
    public static let topLeading = ContentOffset(.topLeading, offset: .zero)
    public static let topTrailing = ContentOffset(.topTrailing, offset: .zero)
    public static let bottomLeading = ContentOffset(.bottomLeading, offset: .zero)
    public static let bottomTrailing = ContentOffset(.bottomTrailing, offset: .zero)
    
    public static func zero(_ offset: CGPoint) -> ContentOffset { ContentOffset(.zero, offset: offset) }
    public static func center(_ offset: CGPoint) -> ContentOffset { ContentOffset(.center, offset: offset) }
    public static func leading(_ offset: CGFloat) -> ContentOffset { ContentOffset(.leading, offset: CGPoint(x: offset, y: 0)) }
    public static func trailing(_ offset: CGFloat) -> ContentOffset { ContentOffset(.trailing, offset: CGPoint(x: offset, y: 0)) }
    public static func top(_ offset: CGFloat) -> ContentOffset { ContentOffset(.top, offset: CGPoint(x: 0, y: offset)) }
    public static func bottom(_ offset: CGFloat) -> ContentOffset { ContentOffset(.bottom, offset: CGPoint(x: 0, y: offset)) }
    public static func topLeading(_ offset: CGPoint) -> ContentOffset { ContentOffset(.topLeading, offset: offset) }
    public static func topTrailing(_ offset: CGPoint) -> ContentOffset { ContentOffset(.topTrailing, offset: offset) }
    public static func bottomLeading(_ offset: CGPoint) -> ContentOffset { ContentOffset(.bottomLeading, offset: offset) }
    public static func bottomTrailing(_ offset: CGPoint) -> ContentOffset { ContentOffset(.bottomTrailing, offset: offset) }
    
    public static func +(_ lhs: ContentOffset, _ rhs: ContentOffset) -> ContentOffset {
        ContentOffset(UnitPoint(x: lhs.unitPoint.x + rhs.unitPoint.x, y: lhs.unitPoint.y + rhs.unitPoint.y), offset: CGPoint(x: lhs.offset.x + rhs.offset.x, y: lhs.offset.y + rhs.offset.y))
    }
    
    public static func -(_ lhs: ContentOffset, _ rhs: ContentOffset) -> ContentOffset {
        ContentOffset(UnitPoint(x: lhs.unitPoint.x - rhs.unitPoint.x, y: lhs.unitPoint.y - rhs.unitPoint.y), offset: CGPoint(x: lhs.offset.x - rhs.offset.x, y: lhs.offset.y - rhs.offset.y))
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UnitPoint: Hashable {}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func +(_ lhs: ContentOffset, _ rhs: CGPoint) -> ContentOffset {
    ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x + rhs.x, y: lhs.offset.y + rhs.y))
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func +(_ lhs: ContentOffset, _ rhs: CGFloat) -> ContentOffset {
    switch lhs.unitPoint {
    case .top, .bottom: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x, y: lhs.offset.y + rhs))
    case .leading, .trailing: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x + rhs, y: lhs.offset.y))
    default: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x + rhs, y: lhs.offset.y + rhs))
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func -(_ lhs: ContentOffset, _ rhs: CGPoint) -> ContentOffset {
    ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x - rhs.x, y: lhs.offset.y - rhs.y))
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func -(_ lhs: ContentOffset, _ rhs: CGFloat) -> ContentOffset {
    switch lhs.unitPoint {
    case .top, .bottom: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x, y: lhs.offset.y - rhs))
    case .leading, .trailing: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x - rhs, y: lhs.offset.y))
    default: return ContentOffset(lhs.unitPoint, offset: CGPoint(x: lhs.offset.x - rhs, y: lhs.offset.y - rhs))
    }
}
