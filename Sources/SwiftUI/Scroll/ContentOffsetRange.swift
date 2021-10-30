//
//  File.swift
//  
//
//  Created by Данил Войдилов on 08.10.2021.
//

import Foundation
import SwiftUI
import VDCommon

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct ContentOffsetRange: Hashable, Equatable, Animatable {
    public var lowerBound: ContentOffset
    public var upperBound: ContentOffset
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func ...(_ lhs: ContentOffset, _ rhs: ContentOffset) -> ContentOffsetRange {
    ContentOffsetRange(lowerBound: lhs, upperBound: rhs)
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public prefix func ...(_ rhs: ContentOffset) -> ContentOffsetRange {
    ContentOffsetRange(lowerBound: .zero, upperBound: rhs)
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public postfix func ...(_ lhs: ContentOffset) -> ContentOffsetRange {
    ContentOffsetRange(lowerBound: lhs, upperBound: .bottomTrailing)
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func ±(_ lhs: ContentOffset, _ rhs: CGPoint) -> ContentOffsetRange {
    ContentOffsetRange(lowerBound: lhs - rhs, upperBound: lhs + rhs)
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public func ±(_ lhs: ContentOffset, _ rhs: CGFloat) -> ContentOffsetRange {
    ContentOffsetRange(lowerBound: lhs - rhs, upperBound: lhs + rhs)
}
