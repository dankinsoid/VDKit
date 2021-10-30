//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.10.2021.
//

import UIKit
import SwiftUI
import VDSwiftUICommon

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Pages<C: Comparable, Page: View>: UIViewControllerRepresentable {
  
  let before: (C) -> C?
  let after: (C) -> C?
  let page: (C) -> Page
  let scrollDirection: Axis
  let transitionStyle: UIPageViewController.TransitionStyle
  @StateOrBinding var currentPage: C
  
  public init(scrollDirection: Axis = .horizontal, transitionStyle: UIPageViewController.TransitionStyle = .scroll, currentPage: Binding<C>, @ViewBuilder pages: @escaping (C) -> Page, before: @escaping (C) -> C?, after: @escaping (C) -> C?) {
    self = .init(scrollDirection: scrollDirection, transitionStyle: transitionStyle, currentPage: .binding(currentPage), pages: pages, before: before, after: after)
  }
  
  public init(scrollDirection: Axis = .horizontal, transitionStyle: UIPageViewController.TransitionStyle = .scroll, initialPage: C, @ViewBuilder pages: @escaping (C) -> Page, before: @escaping (C) -> C?, after: @escaping (C) -> C?) {
    self = .init(scrollDirection: scrollDirection, transitionStyle: transitionStyle, currentPage: .state(initialPage), pages: pages, before: before, after: after)
  }
  
  init(scrollDirection: Axis, transitionStyle: UIPageViewController.TransitionStyle, currentPage: StateOrBinding<C>, @ViewBuilder pages: @escaping (C) -> Page, before: @escaping (C) -> C?, after: @escaping (C) -> C?) {
    self.before = before
    self.after = after
    page = pages
    self.scrollDirection = scrollDirection
    self.transitionStyle = transitionStyle
    self._currentPage = currentPage
  }
  
  public func makeUIViewController(context: Context) -> UIPageView {
    let flow = UIPageView(before: before, after: after, page: page, currentPageBinding: $currentPage, navigationOrientation: scrollDirection.navigationDirection, transitionStyle: transitionStyle)
    flow.loadViewIfNeeded()
    flow.setViewControllers([PageHosting(view: page(currentPage), element: currentPage)], direction: .forward, animated: false)
    flow.view.backgroundColor = .clear
    return flow
  }
  
  public func updateUIViewController(_ uiViewController: UIPageView, context: Context) {
    uiViewController.currentPageBinding = $currentPage
    uiViewController.before = before
    uiViewController.after = after
    uiViewController.page = page
    if let vc = uiViewController.viewControllers?.first as? PageHosting<Page, C>, vc.element == currentPage {
      vc.rootView = page(vc.element)
    } else {
      let animated = uiViewController.viewControllers?.isEmpty == false && context.transaction.animation != nil
      let current =  (uiViewController.viewControllers?.first as? PageHosting<Page, C>)?.element
      uiViewController.setViewControllers([PageHosting(view: page(currentPage), element: currentPage)], direction: (current ?? currentPage) < currentPage ? .forward : .reverse, animated: animated)
    }
  }
  
  public final class UIPageView: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var before: (C) -> C?
    var after: (C) -> C?
    var page: (C) -> Page
    var currentPageBinding: Binding<C>?
    
    init(before: @escaping (C) -> C?, after: @escaping (C) -> C?, page: @escaping (C) -> Page, currentPageBinding: Binding<C>?, navigationOrientation: NavigationOrientation, transitionStyle: TransitionStyle) {
      self.before = before
      self.after = after
      self.page = page
      self.currentPageBinding = currentPageBinding
      super.init(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
      fatalError()
    }
    
    public override func viewDidLoad() {
      super.viewDidLoad()
      delegate = self
      dataSource = self
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
      guard let hosting = viewController as? PageHosting<Page, C> else { return nil }
      return before(hosting.element).map { PageHosting(view: page($0), element: $0) }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      guard let hosting = viewController as? PageHosting<Page, C> else { return nil }
      return after(hosting.element).map { PageHosting(view: page($0), element: $0) }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
      guard completed, let hosting = viewControllers?.first as? PageHosting<Page, C> else { return }
      currentPageBinding?.wrappedValue = hosting.element
    }
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pages {
  
  public init<D: Collection>(_ data: D, scrollDirection: Axis = .horizontal, transitionStyle: UIPageViewController.TransitionStyle = .scroll, currentIndex: Binding<C>, @ViewBuilder pages: @escaping (D.Element) -> Page) where D.Index == C {
    self = .init(scrollDirection: scrollDirection, transitionStyle: transitionStyle, currentPage: .binding(currentIndex)) {
      pages(data[$0])
    } before: {
      $0 > data.startIndex ? data.index($0, offsetBy: -1) : nil
    } after: {
      let next = data.index(after: $0)
      return next < data.endIndex ? next : nil
    }
  }
  
  public init<D: Collection>(_ data: D, scrollDirection: Axis = .horizontal, transitionStyle: UIPageViewController.TransitionStyle = .scroll, initialIndex: C, @ViewBuilder pages: @escaping (D.Element) -> Page) where D.Index == C {
    self = .init(scrollDirection: scrollDirection, transitionStyle: transitionStyle, currentPage: .state(initialIndex)) {
      pages(data[$0])
    } before: {
      $0 > data.startIndex ? data.index($0, offsetBy: -1) : nil
    } after: {
      let next = data.index(after: $0)
      return next < data.endIndex ? next : nil
    }
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Axis {
  
  var navigationDirection: UIPageViewController.NavigationOrientation {
    switch self {
    case .horizontal:
      return .horizontal
    case .vertical:
      return .vertical
    }
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private final class PageHosting<Content: View, Element>: UIHostingController<Content> {
  var element: Element
  
  init(view: Content, element: Element) {
    self.element = element
    super.init(rootView: view)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
