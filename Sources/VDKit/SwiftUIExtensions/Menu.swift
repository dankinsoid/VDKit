//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.10.2021.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
extension View {
  
  public func menu(_ isPresented: Binding<Bool>, edge: Edge? = nil, insets: EdgeInsets = .zero, items: [MenuItem]) -> some View {
  	background(
    	MenuWrapper(items: items, edge: edge, insets: insets, isPresented: isPresented)
    )
  }
  
  public func menu(_ isPresented: Binding<Bool>, edge: Edge? = nil, insets: EdgeInsets = .zero, items: MenuItem...) -> some View {
    menu(isPresented, edge: edge, insets: insets, items: items)
  }
  
  public func menu(_ isPresented: Binding<Bool>, edge: Edge? = nil, insets: EdgeInsets = .zero, @ArrayBuilder<MenuItem> items: () -> [MenuItem]) -> some View {
    menu(isPresented, edge: edge, insets: insets, items: items())
  }
  
  public func menu<G: Gesture>(on gesture: G, edge: Edge? = nil, insets: EdgeInsets = .zero, items: [MenuItem]) -> some View {
    modifier(MenuModifier(gesture: gesture, items: items, edge: edge, insets: insets))
  }
  
  public func menu<G: Gesture>(on gesture: G, edge: Edge? = nil, insets: EdgeInsets = .zero, items: MenuItem...) -> some View {
    menu(on: gesture, edge: edge, insets: insets, items: items)
  }
  
  public func menu<G: Gesture>(on gesture: G, edge: Edge? = nil, insets: EdgeInsets = .zero, @ArrayBuilder<MenuItem> items: () -> [MenuItem]) -> some View {
    menu(on: gesture, edge: edge, insets: insets, items: items())
  }
}

@available(iOS 13.0, *)
private struct MenuModifier<G: Gesture>: ViewModifier {
  
  var gesture: G
  let items: [MenuItem]
  let edge: Edge?
  let insets: EdgeInsets
  @State var isPresented = false
  
  func body(content: Content) -> some View {
    content
      .gesture(
        gesture.onEnded { _ in
          isPresented.toggle()
      	}
      )
      .menu($isPresented, edge: edge, insets: insets, items: items)
  }
}

public struct MenuItem {
  public var title: String
  public var action: () -> Void
  
  public init(_ title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
}

@available(iOS 13.0, *)
private struct MenuWrapper: UIViewRepresentable {
  
  let items: [MenuItem]
  let edge: Edge?
  let insets: EdgeInsets
  @Binding var isPresented: Bool
  
  func makeUIView(context: Context) -> UIViewType {
    UIViewType()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.edge = edge
    uiView.items = Array(items.prefix(30))
    uiView.onHide = {[_isPresented] in
      if _isPresented.wrappedValue {
        _isPresented.wrappedValue = false
      }
    }
    if isPresented != UIMenuController.shared.isMenuVisible {
      if isPresented {
        uiView.showMenu()
      } else {
        UIMenuController.shared.hideMenu()
        uiView.resignFirstResponder()
      }
    }
  }
  
  final class UIViewType: UIView {
    
    var onHide: (() -> Void)?
    var items: [MenuItem] = []
    var edge: Edge?
    var insets: EdgeInsets = .zero
    private let prefix = "menuSelector"
    
    init() {
      super.init(frame: .zero)
      backgroundColor = .clear
      isUserInteractionEnabled = false
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.willHideEditMenu),
        name: UIMenuController.didHideMenuNotification,
        object: nil
      )
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    override var canBecomeFirstResponder: Bool {
      true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
      var string = NSStringFromSelector(action)
      guard string.hasPrefix(prefix) else { return false }
      string.removeFirst(prefix.count)
      if let i = Int(string), i < 30 {
        return true
      }
      return false
    }
    
    @objc private func menuSelector0() { menuSelector(0) }
    @objc private func menuSelector1() { menuSelector(1) }
    @objc private func menuSelector2() { menuSelector(2) }
    @objc private func menuSelector3() { menuSelector(3) }
    @objc private func menuSelector4() { menuSelector(4) }
    @objc private func menuSelector5() { menuSelector(5) }
    @objc private func menuSelector6() { menuSelector(6) }
    @objc private func menuSelector7() { menuSelector(7) }
    @objc private func menuSelector8() { menuSelector(8) }
    @objc private func menuSelector9() { menuSelector(9) }
    @objc private func menuSelector10() { menuSelector(10) }
    @objc private func menuSelector11() { menuSelector(11) }
    @objc private func menuSelector12() { menuSelector(12) }
    @objc private func menuSelector13() { menuSelector(13) }
    @objc private func menuSelector14() { menuSelector(14) }
    @objc private func menuSelector15() { menuSelector(15) }
    @objc private func menuSelector16() { menuSelector(16) }
    @objc private func menuSelector17() { menuSelector(17) }
    @objc private func menuSelector18() { menuSelector(18) }
    @objc private func menuSelector19() { menuSelector(19) }
    @objc private func menuSelector20() { menuSelector(20) }
    @objc private func menuSelector21() { menuSelector(21) }
    @objc private func menuSelector22() { menuSelector(22) }
    @objc private func menuSelector23() { menuSelector(23) }
    @objc private func menuSelector24() { menuSelector(24) }
    @objc private func menuSelector25() { menuSelector(25) }
    @objc private func menuSelector26() { menuSelector(26) }
    @objc private func menuSelector27() { menuSelector(27) }
    @objc private func menuSelector28() { menuSelector(28) }
    @objc private func menuSelector29() { menuSelector(29) }
    
    private func menuSelector(_ i: Int) {
      guard items.count > i else { return }
      items[i].action()
    }
    
    @objc private func willHideEditMenu() {
      onHide?()
    }
    
    func showMenu() {
      guard !UIMenuController.shared.isMenuVisible else { return }
      switch edge {
      case .leading:
        UIMenuController.shared.arrowDirection = .right
      case .trailing:
        UIMenuController.shared.arrowDirection = .left
      case .top:
        UIMenuController.shared.arrowDirection = .down
      case .bottom:
        UIMenuController.shared.arrowDirection = .up
      case .none:
        UIMenuController.shared.arrowDirection = .default
      }
      
      UIMenuController.shared.menuItems = items.enumerated().map {
        UIMenuItem(title: $0.element.title, action: NSSelectorFromString(prefix + "\($0.offset)"))
      }
			DispatchQueue.main.async {[self] in
				becomeFirstResponder()
				UIMenuController.shared.showMenu(from: self, rect: bounds.inset(by: insets.ui))
			}
    }
  }
}
