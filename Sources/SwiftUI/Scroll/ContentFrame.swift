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
public struct ContentFrame: Hashable, Equatable, Animatable {
    public var offset: ContentOffset
    public let contentSize: CGSize
    public let frameSize: CGSize
    
    public var contentFrame: CGRect {
        CGRect(origin: .zero - self[.zero], size: contentSize)
    }
    
    public var maxOffset: CGPoint {
        CGPoint(x: max(0, contentSize.width - frameSize.width), y: max(0, contentSize.height - frameSize.height))
    }
    
    public init(offset: ContentOffset, contentSize: CGSize, frameSize: CGSize) {
        self.offset = offset
        self.contentSize = contentSize
        self.frameSize = frameSize
    }
    
    public subscript(_ unit: UnitPoint) -> CGPoint {
        get {
            point(unit, for: offset)
        }
        set {
            offset = ContentOffset(unit, offset: newValue)
        }
    }
    
    
    public static var zero: ContentFrame { .init(offset: .zero, contentSize: .zero, frameSize: .zero) }
    
    public var zero: CGPoint { get { self[.zero] } set { self[.zero] = newValue } }
    public var center: CGPoint { get { self[.center] } set { self[.center] = newValue } }
    public var leading: CGFloat { get { self[.leading].x } set { self[.leading].x = newValue } }
    public var trailing: CGFloat { get { self[.trailing].x } set { self[.trailing].x = newValue } }
    public var top: CGFloat { get { self[.top].y } set { self[.top].y = newValue } }
    public var bottom: CGFloat { get { self[.bottom].y } set { self[.bottom].y = newValue } }
    public var topLeading: CGPoint { get { self[.topLeading] } set { self[.topLeading] = newValue } }
    public var topTrailing: CGPoint { get { self[.topTrailing] } set { self[.topTrailing] = newValue } }
    public var bottomLeading: CGPoint { get { self[.bottomLeading] } set { self[.bottomLeading] = newValue } }
    public var bottomTrailing: CGPoint { get { self[.bottomTrailing] } set { self[.bottomTrailing] = newValue } }
    
    public func zeroOffset(for unitPoint: UnitPoint) -> CGPoint {
        CGPoint(
            x: (contentSize.width - frameSize.width) * unitPoint.x,
            y: (contentSize.height - frameSize.height) * unitPoint.y
        )
    }
    
    public func point(_ unit: UnitPoint = .zero, for offset: ContentOffset) -> CGPoint {
        if unit == offset.unitPoint {
            return offset.offset
        }
        return zeroOffset(for: offset.unitPoint) + offset.offset - zeroOffset(for: unit)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UIScrollView {
    
    var contentFrame: ContentFrame {
        frame(for: contentOffset)
    }
    
    var offset: ContentOffset {
        offset(contentOffset)
    }
    
    var fullContentSize: CGSize {
        CGSize(
            width: contentSize.width + adjustedContentInset.left + adjustedContentInset.right,
            height: contentSize.height + adjustedContentInset.top + adjustedContentInset.bottom
        )
    }
    
    func frame(for point: CGPoint) -> ContentFrame {
        ContentFrame(
            offset: offset(point),
            contentSize: fullContentSize,
            frameSize: bounds.size
        )
    }
    
    func frame(for offset: ContentOffset) -> ContentFrame {
        ContentFrame(
            offset: offset,
            contentSize: fullContentSize,
            frameSize: bounds.size
        )
    }
    
    func offset(_ point: CGPoint) -> ContentOffset {
        ContentOffset(
            .zero,
            offset: CGPoint(
                x: point.x + adjustedContentInset.left,
                y: point.y + adjustedContentInset.top
            )
        )
    }
    
    func point(_ offset: ContentOffset) -> CGPoint {
        point(frame(for: offset))
    }
    
    func point(_ frame: ContentFrame) -> CGPoint {
        let offset = frame.zero
        return CGPoint(
            x: offset.x - adjustedContentInset.left,
            y: offset.y - adjustedContentInset.top
        )
    }
    
    func set(offset: ContentOffset, animated: Bool) {
        setContentOffset(point(offset), animated: animated)
    }
}
