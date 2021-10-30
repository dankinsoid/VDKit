//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 06.10.2021.
//

#if canImport(UIKit)
import SwiftUI
import UIKit
import VDSwiftUICommon

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Scroll<Content: View>: UIViewRepresentable {
  public var axis: Axis.Set
  public var alignment: Alignment
  public var showsIndicators: Bool
  public let content: Content
  private let scrollBinding: Binding<ContentOffset?>?
  private let setScroll: ((UIScrollView) -> Void)?
  public var bounces: Bool
  public var zoomScale: Binding<Double>?
  public var zoomScaleRange: ClosedRange<Double>
  public var paging: ScrollPaging?
  public var flashScrollIndicators: Bool
  public var onScrolling: ((Bool, ContentFrame) -> Void)?
  public var onDecelerating: ((Bool) -> Void)?
  public var onDragging: ((Bool) -> Void)?
  
  public init<T>(
    _ axis: Axis.Set = .vertical,
    alignment: Alignment = .topLeading,
    showsIndicators: Bool = false,
    offset: ScrollOffset<T>,
    bounces: Bool = true,
    paging: ScrollPaging? = nil,
    zoomScale: Binding<Double>? = nil,
    zoomScaleRange: ClosedRange<Double> = 1...1,
    flashScrollIndicators: Bool = false,
    onScrolling: ((Bool, ContentFrame) -> Void)? = nil,
    onDecelerating: ((Bool) -> Void)? = nil,
    onDragging: ((Bool) -> Void)? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self = Scroll(axis: axis, alignment: alignment, showsIndicators: showsIndicators, content: content(), scrollBinding: offset.scrollBinding, setScroll: offset.setScroll, bounces: bounces, zoomScale: zoomScale, zoomScaleRange: zoomScaleRange, paging: paging, flashScrollIndicators: flashScrollIndicators, onScrolling: onScrolling, onDecelerating: onDecelerating, onDragging: onDragging)
  }
  
  public init(
    _ axis: Axis.Set = .vertical,
    alignment: Alignment = .topLeading,
    showsIndicators: Bool = false,
    bounces: Bool = true,
    paging: ScrollPaging? = nil,
    zoomScale: Binding<Double>? = nil,
    zoomScaleRange: ClosedRange<Double> = 1...1,
    flashScrollIndicators: Bool = false,
    onScrolling: ((Bool, ContentFrame) -> Void)? = nil,
    onDecelerating: ((Bool) -> Void)? = nil,
    onDragging: ((Bool) -> Void)? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self = Scroll(axis: axis, alignment: alignment, showsIndicators: showsIndicators, content: content(), scrollBinding: nil, setScroll: nil, bounces: bounces, zoomScale: zoomScale, zoomScaleRange: zoomScaleRange, paging: paging, flashScrollIndicators: flashScrollIndicators, onScrolling: onScrolling, onDecelerating: onDecelerating, onDragging: onDragging)
  }
  
  private init(
    axis: Axis.Set,
    alignment: Alignment,
    showsIndicators: Bool,
    content: Content,
    scrollBinding: Binding<ContentOffset?>?,
    setScroll: ((UIScrollView) -> Void)?,
    bounces: Bool,
    zoomScale: Binding<Double>?,
    zoomScaleRange: ClosedRange<Double>,
    paging: ScrollPaging?,
    flashScrollIndicators: Bool,
    onScrolling: ((Bool, ContentFrame) -> Void)?,
    onDecelerating: ((Bool) -> Void)?,
    onDragging: ((Bool) -> Void)?
  ) {
    self.axis = axis
    self.alignment = alignment
    self.showsIndicators = showsIndicators
    self.content = content
    self.scrollBinding = scrollBinding
    self.setScroll = setScroll
    self.bounces = bounces
    self.zoomScale = zoomScale
    self.zoomScaleRange = zoomScaleRange
    self.paging = paging
    self.flashScrollIndicators = flashScrollIndicators
    self.onScrolling = onScrolling
    self.onDecelerating = onDecelerating
    self.onDragging = onDragging
  }
  
  public func makeUIView(context: Context) -> UIViewType {
    UIViewType(self, content: content)
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.updateUIView(self, context: context)
  }
  
  public final class UIViewType: UIScrollView, UIScrollViewDelegate {
    let hosting: UIHostingController<ContentView>
    var axis: Axis.Set
    var alignment: Alignment
    var contentOffsetBinding: Binding<ContentOffset?>?
    var zoomBinding: Binding<Double>?
    var willEndDragging: ((inout ContentFrame, _ velocity: CGPoint) -> Void)?
    var onDragging: ((Bool) -> Void)?
    var onDecelerating: ((Bool) -> Void)?
    var onScrolling: ((Bool, ContentFrame) -> Void)?
    private var canNotifyDidScroll = false
    private let container = UIView()
    private(set) var isScrolling = false
    private var horizontalConstraint = NSLayoutConstraint()
    private var verticalConstraint = NSLayoutConstraint()
    private var widthConstraint = NSLayoutConstraint()
    private var heightConstraint = NSLayoutConstraint()
    private var alignmentConstraints: [NSLayoutConstraint] = []
    
    public init(_ scroll: Scroll, content: Content) {
      hosting = SelfSizingHostingController(rootView: ContentView(content: content, axis: scroll.axis))
      self.axis = scroll.axis
      self.alignment = scroll.alignment
      super.init(frame: .zero)
      delegate = self
      update(scroll)
      hosting.loadViewIfNeeded()
      setConstraints()
    }
    
    public required init?(coder: NSCoder) {
      fatalError()
    }
    
    func updateUIView(_ scroll: Scroll, context: UIViewRepresentableContext<Scroll>) {
      scroll.setScroll?(self)
      hosting.rootView = update(content: scroll.content, axis: scroll.axis)
      let animated = context.transaction.animation != nil
      update(scroll)
      isScrollEnabled = context.environment.isEnabled
      decelerationRate = context.environment.scroll.decelerationRate
      isDirectionalLockEnabled = context.environment.scroll.isDirectionalLockEnabled
      verticalScrollIndicatorInsets = context.environment.scroll.verticalScrollIndicatorInsets.ui
      horizontalScrollIndicatorInsets = context.environment.scroll.horizontalScrollIndicatorInsets.ui
      delaysContentTouches = context.environment.scroll.delaysContentTouches
      canCancelContentTouches = context.environment.scroll.canCancelContentTouches
      keyboardDismissMode = context.environment.scroll.keyboardDismissMode
      bouncesZoom = context.environment.scroll.bouncesZoom
      contentInsetAdjustmentBehavior = context.environment.scroll.adjustSafeArea ? .automatic : .never
      indicatorStyle = context.environment.colorScheme == .dark ? .white : .black
      indexDisplayMode = context.environment.scroll.indexDisplayMode
      if scroll.flashScrollIndicators {
        flashScrollIndicators()
      }
      if let offset = contentOffsetBinding?.wrappedValue, offset != self.offset {
        set(offset: offset, animated: animated)
      }
      
      if scroll.alignment != alignment {
        alignment = scroll.alignment
        resetAlignmentConstraints()
      }
      
      if scroll.axis != axis {
        axis = scroll.axis
        resetConstraints()
      }
      if let scale = scroll.zoomScale?.wrappedValue, scale != zoomScale {
        setZoomScale(scale, animated: animated)
      }
    }
    
    private func update(_ scroll: Scroll) {
      onDragging = scroll.onDragging
      onDecelerating = scroll.onDecelerating
      onScrolling = scroll.onScrolling
      contentOffsetBinding = scroll.scrollBinding
      showsVerticalScrollIndicator = scroll.showsIndicators && scroll.axis.contains(.vertical)
      showsHorizontalScrollIndicator = scroll.showsIndicators && scroll.axis.contains(.horizontal)
      bounces = scroll.bounces
      alwaysBounceVertical = scroll.bounces && scroll.axis.contains(.vertical)
      alwaysBounceHorizontal = scroll.bounces && scroll.axis.contains(.horizontal)
      isPagingEnabled = scroll.paging?.isFullSize == true
      willEndDragging = scroll.paging?.willEndDragging
      maximumZoomScale = scroll.zoomScaleRange.upperBound
      minimumZoomScale = scroll.zoomScaleRange.lowerBound
      zoomBinding = scroll.zoomScale
    }
    
    // any offset changes
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
      guard canNotifyDidScroll else { return }
      if contentOffsetBinding?.wrappedValue != offset {
        contentOffsetBinding?.wrappedValue = offset
      }
      if !isScrolling {
        isScrolling = true
      }
      onScrolling?(true, contentFrame)
    }
    
    // any zoom scale changes
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
      if zoomBinding?.wrappedValue != zoomScale {
        zoomBinding?.wrappedValue = zoomScale
      }
    }
    
    // called on start of dragging (may require some time and or distance to move)
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      onDragging?(true)
    }
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      onDragging?(false)
      if !decelerate, isScrolling {
        isScrolling = false
        onScrolling?(false, contentFrame)
      }
    }
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      guard let willEndDragging = willEndDragging else { return }
      var frame = scrollView.frame(for: targetContentOffset.pointee)
      willEndDragging(&frame, velocity)
      targetContentOffset.pointee = point(frame)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
      onDecelerating?(true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      if isScrolling {
        isScrolling = false
        onScrolling?(false, contentFrame)
      }
      onDecelerating?(false)
    }
    
    // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
      if isScrolling {
        isScrolling = false
        onScrolling?(false, contentFrame)
      }
    }
    
    // return a view that will be scaled. if delegate returns nil, nothing happens
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      maximumZoomScale > minimumZoomScale ? container : nil
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {}
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {}
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {}
    
    private func setConstraints() {
      container.translatesAutoresizingMaskIntoConstraints = false
      addSubview(container)
      container.addSubview(hosting.view)
      hosting.view.translatesAutoresizingMaskIntoConstraints = false
      
      container.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
      container.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
      container.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor).isActive = true
      container.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor).isActive = true
      
      hosting.view.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor).isActive = true
      hosting.view.heightAnchor.constraint(lessThanOrEqualTo: container.heightAnchor).isActive = true
      
      widthConstraint = container.widthAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.widthAnchor)
      heightConstraint = container.heightAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.heightAnchor)
      
      widthConstraint.isActive = true
      heightConstraint.isActive = true
      
      verticalConstraint = hosting.view.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)
      horizontalConstraint = hosting.view.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor)
      
      resetAlignmentConstraints()
      resetConstraints()
    }
    
    override public func adjustedContentInsetDidChange() {
      super.adjustedContentInsetDidChange()
      resetConstraints()
    }
    
    private func resetConstraints() {
      widthConstraint.constant = -(adjustedContentInset.left + adjustedContentInset.right)
      heightConstraint.constant = -(adjustedContentInset.top + adjustedContentInset.bottom)
      verticalConstraint.constant = -(adjustedContentInset.left + adjustedContentInset.right)
      horizontalConstraint.constant = -(adjustedContentInset.top + adjustedContentInset.bottom)
      
      horizontalConstraint.isActive = !axis.contains(.vertical)
      verticalConstraint.isActive = !axis.contains(.horizontal)
      setNeedsLayout()
    }
    
    private func resetAlignmentConstraints() {
      alignmentConstraints.forEach { $0.isActive = false }
      alignmentConstraints = []
      switch alignment.vertical {
      case .top:
        alignmentConstraints.append(container.topAnchor.constraint(equalTo: hosting.view.topAnchor))
      case .center:
        alignmentConstraints.append(container.centerYAnchor.constraint(equalTo: hosting.view.centerYAnchor))
      case .bottom:
        alignmentConstraints.append(container.bottomAnchor.constraint(equalTo: hosting.view.bottomAnchor))
      case .firstTextBaseline:
        alignmentConstraints.append(container.firstBaselineAnchor.constraint(equalTo: hosting.view.firstBaselineAnchor))
      case .lastTextBaseline:
        alignmentConstraints.append(container.lastBaselineAnchor.constraint(equalTo: hosting.view.lastBaselineAnchor))
      default:
        break
      }
      switch alignment.horizontal {
      case .leading:
        alignmentConstraints.append(container.leadingAnchor.constraint(equalTo: hosting.view.leadingAnchor))
      case .center:
        alignmentConstraints.append(container.centerXAnchor.constraint(equalTo: hosting.view.centerXAnchor))
      case .trailing:
        alignmentConstraints.append(container.trailingAnchor.constraint(equalTo: hosting.view.trailingAnchor))
      default:
        break
      }
      NSLayoutConstraint.activate(alignmentConstraints)
    }
    
    override public func layoutSubviews() {
      super.layoutSubviews()
      setInitialOffset()
    }
    
    private func setInitialOffset() {
      guard !canNotifyDidScroll, window != nil else { return }
      canNotifyDidScroll = true
      switch (alignment.vertical, alignment.horizontal) {
      case (.top, .leading):
        set(offset: .topLeading, animated: false)
      case (.top, .trailing):
        set(offset: .topTrailing, animated: false)
      case (.bottom, .leading):
        set(offset: .bottomLeading, animated: false)
      case (.bottom, .trailing):
        set(offset: .bottomTrailing, animated: false)
      case (.center, .leading):
        set(offset: .leading, animated: false)
      case (.center, .trailing):
        set(offset: .trailing, animated: false)
      case (.center, .center):
        set(offset: .center, animated: false)
      case (.top, .center):
        set(offset: .top, animated: false)
      case (.bottom, .center):
        set(offset: .bottom, animated: false)
      default:
        return
      }
    }
    
    private func update(content: Content, axis: Axis.Set) -> ContentView {
      ContentView(content: content, axis: axis)
    }
    
    struct ContentView: View {
      var content: Content
      var axis: Axis.Set
      
      var body: some View {
        content
          .frame(
            minWidth: axis.contains(.horizontal) ? nil : 0,
            maxWidth: axis.contains(.horizontal) ? nil : .infinity,
            minHeight: axis.contains(.vertical) ? nil : 0,
            maxHeight: axis.contains(.vertical) ? nil : .infinity
          )
      }
    }
    
    final class SelfSizingHostingController<Content>: UIHostingController<Content> where Content: View {
      
      override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
      }
      
      override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
      }
    }
  }
}
#endif
