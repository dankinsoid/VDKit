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
@propertyWrapper
public struct ScrollOffset<T>: DynamicProperty {
    public let keyPath: WritableKeyPath<ContentFrame, T>
    public let updateOnScroll: Bool
    @StateObject private var delegate = OffsetDelegate()
    
    public var wrappedValue: T {
        get { delegate.frame[keyPath: keyPath] }
        nonmutating set {
            var frame = delegate.frame
            frame[keyPath: keyPath] = newValue
            delegate.settedOffset = frame.offset
            delegate.updater.toggle()
        }
    }
    
    public var projectedValue: Binding<T> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    var setScroll: (UIScrollView) -> Void {
        { delegate.scroll = $0 }
    }
    
    var scrollBinding: Binding<ContentOffset?> {
        Binding(
            get: { self.delegate.settedOffset },
            set: { _ in
                delegate.settedOffset = nil
                if updateOnScroll {
                    self.delegate.updater.toggle()
                }
            }
        )
    }
    
    public init(_ keyPath: WritableKeyPath<ContentFrame, T>, updateOnScroll: Bool = false) {
        self.keyPath = keyPath
        self.updateOnScroll = updateOnScroll
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ScrollOffset where T == ContentFrame {

    public init(updateOnScroll: Bool = false) {
        self = ScrollOffset(\.self, updateOnScroll: updateOnScroll)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ScrollOffset where T == CGPoint {
    
    public init(_ unitPoint: UnitPoint = .zero, updateOnScroll: Bool = false) {
        self = ScrollOffset(\.[unitPoint], updateOnScroll: updateOnScroll)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private final class OffsetDelegate: ObservableObject {
    weak var scroll: UIScrollView?
    
    @Published var updater = true
    
    var frame: ContentFrame {
        scroll?.frame(for: scroll?.contentOffset ?? .zero) ?? .zero
    }
    
    var settedOffset: ContentOffset?
    
    func frame(offset: ContentOffset) -> ContentFrame {
        var result = frame
        result.offset = offset
        return result
    }
}
