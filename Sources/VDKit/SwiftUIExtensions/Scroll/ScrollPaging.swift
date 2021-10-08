//
//  File.swift
//  
//
//  Created by Данил Войдилов on 07.10.2021.
//

import Foundation
import UIKit
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ScrollPaging {
    case fullSize, custom(willEndDragging: (inout ContentFrame, _ velocity: CGPoint) -> Void)
    
    public static var `default`: ScrollPaging { .fullSize }
    
    public static func pages(size pageSize: @escaping (CGSize) -> CGSize) -> ScrollPaging {
        .custom { frame, _ in
            let page = pageSize(frame.frameSize)
            var offset = frame.zero
            if page.width > 0 {
                offset.x = round(offset.x / page.width) * page.width
            }
            if page.height > 0 {
                offset.y = round(offset.y / page.height) * page.height
            }
            frame.zero = offset
        }
    }
    
    public static func sticks(_ offsets: Set<Stick>) -> ScrollPaging {
        .custom { frame, _ in
            let offset = frame.zero
            if let stick = offsets
                .first(where: { stick in
                    let range = stick.range
                    let rect = CGRect.between(frame.point(for: range.lowerBound), frame.point(for: range.upperBound))
                    return (rect.minY...rect.maxY) ~= offset.y && rect.height > 0 ||
                    (rect.minX...rect.maxX) ~= offset.x && rect.width > 0
                }) {
                stick.point(for: &frame)
            }
        }
    }
    
    public static func sticks(_ offsets: Stick...) -> ScrollPaging {
        sticks(Set(offsets))
    }
    
    public var isFullSize: Bool {
        if case .fullSize = self { return true }
        return false
    }
    
    public var willEndDragging: ((inout ContentFrame, _ velocity: CGPoint) -> Void)? {
        if case .custom(let willEndDragging) = self { return willEndDragging }
        return nil
    }
    
    public enum Stick: Hashable {
        case centerOf(ContentOffsetRange), edgesOf(ContentOffsetRange)
        
        public var range: ContentOffsetRange {
            switch self {
            case .centerOf(let contentOffsetRange):
                return contentOffsetRange
            case .edgesOf(let contentOffsetRange):
                return contentOffsetRange
            }
        }
        
        public func point(for frame: inout ContentFrame) {
            let offset = frame.zero
            func distance(_ point: CGPoint) -> CGFloat {
                abs(point.y - offset.y) + abs(point.x - offset.x)
            }
            switch self {
            case .centerOf(let range):
                let point1 = frame.point(for: range.lowerBound)
                let point2 = frame.point(for: range.upperBound)
                frame.zero = (point1 + point2) / 2
            case .edgesOf(let range):
                let point1 = frame.point(for: range.lowerBound)
                let point2 = frame.point(for: range.upperBound)
                frame.zero = distance(point1) < distance(point2) ? point1 : point2
            }
        }
    }
}
