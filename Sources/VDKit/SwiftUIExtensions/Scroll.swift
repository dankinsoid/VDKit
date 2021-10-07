//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 06.10.2021.
//

import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Scroll<Content: View>: UIViewRepresentable {
    public var axis: Axis.Set = .vertical
    public var showsIndicators: Bool = false
    public var content: Content
    public var contentOffset: Binding<CGPoint>?
    
//
//    /* Configures whether the scroll indicator insets are automatically adjusted by the system.
//     Default is YES.
//     */
//    @available(iOS 13.0, *)
//    public var automaticallyAdjustsScrollIndicatorInsets: Bool
//
//    public var isDirectionalLockEnabled: Bool // default NO. if YES, try to lock vertical or horizontal scrolling while dragging
//
//    public var bounces: Bool // default YES. if YES, bounces past edge of content and back again
//
//    public var isPagingEnabled: Bool // default NO. if YES, stop on multiples of view bounds
//
//    public var isScrollEnabled: Bool // default YES. turn off any dragging temporarily
//
//    public var indicatorStyle: UIScrollView.IndicatorStyle // default is UIScrollViewIndicatorStyleDefault
//
//
//    @available(iOS 11.1, *)
//    public var verticalScrollIndicatorInsets: EdgeInsets // default is UIEdgeInsetsZero.
//
//    @available(iOS 11.1, *)
//    public var horizontalScrollIndicatorInsets: EdgeInsets // default is UIEdgeInsetsZero.
//
//    @available(iOS 3.0, *)
//    public var decelerationRate: UIScrollView.DecelerationRate
//
//    public var indexDisplayMode: UIScrollView.IndexDisplayMode
//
//
//    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool) // animate at constant velocity to new offset
//
//    public func scrollRectToVisible(_ rect: CGRect, animated: Bool) // scroll so rect is just visible (nearest edges). nothing if rect completely visible
//
//
//    public func flashScrollIndicators() // displays the scroll indicators for a short time. This should be done whenever you bring the scroll view to front.
//
//
//    /*
//     Scrolling with no scroll bars is a bit complex. on touch down, we don't know if the user will want to scroll or track a subview like a control.
//     on touch down, we start a timer and also look at any movement. if the time elapses without sufficient change in position, we start sending events to
//     the hit view in the content subview. if the user then drags far enough, we switch back to dragging and cancel any tracking in the subview.
//     the methods below are called by the scroll view and give subclasses override points to add in custom behavior.
//     you can remove the delay in delivery of touchesBegan:withEvent: to subviews by setting delaysContentTouches to NO.
//     */
//
//    public var isTracking: Bool { get } // returns YES if user has touched. may not yet have started dragging
//
//    public var isDragging: Bool { get } // returns YES if user has started scrolling. this may require some time and or distance to move to initiate dragging
//
//    public var isDecelerating: Bool { get } // returns YES if user isn't dragging (touch up) but scroll view is still moving
//
//
//    public var delaysContentTouches: Bool // default is YES. if NO, we immediately call -touchesShouldBegin:withEvent:inContentView:. this has no effect on presses
//
//    public var canCancelContentTouches: Bool // default is YES. if NO, then once we start tracking, we don't try to drag if the touch moves. this has no effect on presses
//
//    /*
//     the following properties and methods are for zooming. as the user tracks with two fingers, we adjust the offset and the scale of the content. When the gesture ends, you should update the content
//     as necessary. Note that the gesture can end and a finger could still be down. While the gesture is in progress, we do not send any tracking calls to the subview.
//     the delegate must implement both viewForZoomingInScrollView: and scrollViewDidEndZooming:withView:atScale: in order for zooming to work and the max/min zoom scale must be different
//     note that we are not scaling the actual scroll view but the 'content view' returned by the delegate. the delegate must return a subview, not the scroll view itself, from viewForZoomingInScrollview:
//     */
//
//    public var minimumZoomScale: CGFloat // default is 1.0
//
//    public var maximumZoomScale: CGFloat // default is 1.0. must be > minimum zoom scale to enable zooming
//
//
//    @available(iOS 3.0, *)
//    public var zoomScale: CGFloat // default is 1.0
//
//    @available(iOS 3.0, *)
//    public func setZoomScale(_ scale: CGFloat, animated: Bool)
//
//    @available(iOS 3.0, *)
//    public func zoom(to rect: CGRect, animated: Bool)
//
//
//    public var bouncesZoom: Bool // default is YES. if set, user can go past min/max zoom while gesturing and the zoom will animate to the min/max value at gesture end
//
//
//    public var isZooming: Bool { get } // returns YES if user in zoom gesture
//
//    public var isZoomBouncing: Bool { get } // returns YES if we are in the middle of zooming back to the min/max value
//
//
//    // When the user taps the status bar, the scroll view beneath the touch which is closest to the status bar will be scrolled to top, but only if its `scrollsToTop` property is YES, its delegate does not return NO from `-scrollViewShouldScrollToTop:`, and it is not already at the top.
//    // On iPhone, we execute this gesture only if there's one on-screen scroll view with `scrollsToTop` == YES. If more than one is found, none will be scrolled.
//    public var scrollsToTop: Bool // default is YES.
//
    
    public init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public func makeUIView(context: Context) -> UIViewType {
        UIViewType(self)
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.updateUIView(self, context: context)
    }
    
    public final class UIViewType: UIScrollView, UIScrollViewDelegate {
        let hosting: UIHostingController<Content>
        var axis: Axis.Set = .vertical
        var contentOffsetBinding: Binding<CGPoint>?
        private var horizontalConstraints: [NSLayoutConstraint] = []
        private var verticalConstraints: [NSLayoutConstraint] = []
        private var canSetOffset = true
        
        public init(_ scroll: Scroll) {
            hosting = UIHostingController(rootView: scroll.content)
            self.axis = scroll.axis
            super.init(frame: .zero)
            hosting.loadViewIfNeeded()
            addSubview(hosting.view)
            setConstraints()
        }
        
        public required init?(coder: NSCoder) {
            fatalError()
        }
        
        func updateUIView(_ scroll: Scroll, context: Context) {
            let animated = context.transaction.animation != nil
            hosting.rootView = scroll.content
            showsVerticalScrollIndicator = scroll.showsIndicators && scroll.axis.contains(.vertical)
            showsHorizontalScrollIndicator = scroll.showsIndicators && scroll.axis.contains(.horizontal)
            contentOffsetBinding = scroll.contentOffset
            if let offset = contentOffsetBinding?.wrappedValue, canSetOffset, offset != contentOffset {
                setContentOffset(offset, animated: animated)
            }
            
            if scroll.axis != axis {
                self.axis = scroll.axis
                resetConstraints()
            }
        }
        
        // any offset changes
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard contentOffsetBinding != nil else { return }
            canSetOffset = false
            contentOffsetBinding?.wrappedValue = contentOffset
            canSetOffset = true
        }
        
        // any zoom scale changes
        public func scrollViewDidZoom(_ scrollView: UIScrollView) {
            
        }
        
        // called on start of dragging (may require some time and or distance to move)
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            
        }
        
        // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
        public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
        }
        
        // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
        public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            
        }
        
        public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        }
        
        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
        }
        
        // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
        public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            
        }
        
        // return a view that will be scaled. if delegate returns nil, nothing happens
        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            nil
        }
        
        public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            
        }
        
        public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            
        }
        
        public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        }
        
        private func setConstraints() {
            translatesAutoresizingMaskIntoConstraints = false
            hosting.view.translatesAutoresizingMaskIntoConstraints = false
            
            hosting.view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            hosting.view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            hosting.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            hosting.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            verticalConstraints = [
                hosting.view.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
            horizontalConstraints = [
                hosting.view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
            
            resetConstraints()
        }
        
        private func resetConstraints() {
            verticalConstraints.forEach {
                $0.isActive = axis.contains(.vertical)
            }
            horizontalConstraints.forEach {
                $0.isActive = axis.contains(.horizontal)
            }
            setNeedsLayout()
        }
    }
}

@propertyWrapper
public struct ScrollOffset<T>: DynamicProperty {
    let keyPath: KeyPath<CGPoint, T>
    
    public var wrappedValue: T
    
    public init(wrappedValue: T, _ keyPath: KeyPath<CGPoint, T>) {
        self.wrappedValue = wrappedValue
        self.keyPath = keyPath
    }
}

extension ScrollOffset where T == CGPoint {
    
    public init(wrappedValue: T) {
        self = ScrollOffset(wrappedValue: wrappedValue, \.self)
    }
    
    public init() {
        self = ScrollOffset(wrappedValue: .zero, \.self)
    }
}

extension ScrollOffset where T == CGFloat {
    
    public init(_ keyPath: KeyPath<CGPoint, T>) {
        self = ScrollOffset(wrappedValue: 0, keyPath)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Scroll_Previews: PreviewProvider {
    static var previews: some View {
        Scroll {
            Text("Text")
                .background(Color.red)
        }
    }
}
