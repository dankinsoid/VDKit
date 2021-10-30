//
//  File.swift
//  
//
//  Created by Данил Войдилов on 07.10.2021.
//

import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    public struct Scroll {
        /// default `true`. if `true`, try to lock vertical or horizontal scrolling while dragging
        public var isDirectionalLockEnabled: Bool = true
        public var decelerationRate: UIScrollView.DecelerationRate = .normal
        public var verticalScrollIndicatorInsets: EdgeInsets = EdgeInsets()
        public var horizontalScrollIndicatorInsets: EdgeInsets = EdgeInsets()
        /// default is `true`. if `false`, we immediately call -touchesShouldBegin:withEvent:inContentView:. this has no effect on presses
        public var delaysContentTouches: Bool = true
        /// default is `true`. if `false`, then once we start tracking, we don't try to drag if the touch moves. this has no effect on presses
        public var canCancelContentTouches: Bool = true
        public var adjustSafeArea: Bool = true
        public var keyboardDismissMode: UIScrollView.KeyboardDismissMode = .interactive
        /// default is `true`. if set, user can go past min/max zoom while gesturing and the zoom will animate to the min/max value at gesture end
        public var bouncesZoom: Bool = true
        public var indexDisplayMode: UIScrollView.IndexDisplayMode = .automatic
//        public var indicatorStyle: UIScrollView.IndicatorStyle?
        
        public init () {}
    }
    
    public var scroll: Scroll {
			get { self[ScrollKey.self] }
			set { self[ScrollKey.self] = newValue }
    }
	
	private enum ScrollKey: EnvironmentKey {
		static var defaultValue: EnvironmentValues.Scroll { .init() }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    public func scroll(isDirectionalLockEnabled: Bool) -> some View {
        environment(\.scroll.isDirectionalLockEnabled, isDirectionalLockEnabled)
    }
    
    public func scroll(decelerationRate: UIScrollView.DecelerationRate) -> some View {
        environment(\.scroll.decelerationRate, decelerationRate)
    }
    
    public func scroll(verticalScrollIndicatorInsets: EdgeInsets) -> some View {
        environment(\.scroll.verticalScrollIndicatorInsets, verticalScrollIndicatorInsets)
    }
    
    public func scroll(horizontalScrollIndicatorInsets: EdgeInsets) -> some View {
        environment(\.scroll.horizontalScrollIndicatorInsets, horizontalScrollIndicatorInsets)
    }
    
    public func scroll(delaysContentTouches: Bool) -> some View {
        environment(\.scroll.delaysContentTouches, delaysContentTouches)
    }
    
    public func scroll(canCancelContentTouches: Bool) -> some View {
        environment(\.scroll.canCancelContentTouches, canCancelContentTouches)
    }
    
    public func scroll(keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> some View {
        environment(\.scroll.keyboardDismissMode, keyboardDismissMode)
    }
    
    public func scroll(adjustSafeArea: Bool) -> some View {
        environment(\.scroll.adjustSafeArea, adjustSafeArea)
    }
    
    public func scroll(bouncesZoom: Bool) -> some View {
        environment(\.scroll.bouncesZoom, bouncesZoom)
    }
    
    public func scroll(indexDisplayMode: UIScrollView.IndexDisplayMode) -> some View {
        environment(\.scroll.indexDisplayMode, indexDisplayMode)
    }
}
