//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.10.2021.
//

#if canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
  
  public func smallPopover<T: View>(_ isPresented: Binding<Bool>, edge: Edge? = nil, color: Color? = nil, size: CGSize? = nil, insets: EdgeInsets = .zero, @ViewBuilder content: () -> T) -> some View {
    background(
      Popover(content: content(), color: color, size: size, insets: insets, edge: edge, isAppear: isPresented)
    )
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct Popover<T: View>: UIViewControllerRepresentable {
  
  let content: T
  let color: Color?
  let size: CGSize?
  let insets: EdgeInsets
	let edge: Edge?
  @Binding var isAppear: Bool
	@Environment(\.self) private var environments
	private var view: AllEnvironments<T> {
		AllEnvironments(environments: environments, content: content)
	}
  
  func makeUIViewController(context: Context) -> UIViewControllerType {
    UIViewControllerType(content: view, color: color, size: size, insets: insets.ui)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    uiViewController.content = view
    uiViewController.size = size
    uiViewController.insets = insets.ui
		uiViewController.edge = edge
		uiViewController.color = color
    uiViewController.popover?.rootView = view
    if let size = size {
      uiViewController.popover?.preferredContentSize = size
    }
    if let color = color {
      uiViewController.popover?.popoverPresentationController?.backgroundColor = color.ui
    }
    uiViewController.onHide = {
      isAppear = false
    }
    if isAppear {
      uiViewController.showPopover(animated: context.transaction.animation != nil)
    } else {
      uiViewController.popover?.dismiss(animated: context.transaction.animation != nil, completion: nil)
    }
  }
  
  final class UIViewControllerType: UIViewController, UIPopoverPresentationControllerDelegate {
    var content: AllEnvironments<T>
    var color: Color?
    var size: CGSize?
    var insets: UIEdgeInsets
		var edge: Edge?
    var onHide: (() -> Void)?
    weak var popover: Hosting?
    
    init(content: AllEnvironments<T>, color: Color?, size: CGSize?, insets: UIEdgeInsets) {
      self.content = content
      self.size = size
      self.color = color
      self.insets = insets
      super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .clear
      view.isUserInteractionEnabled = false
    }
    
    func showPopover(animated: Bool) {
      guard popover == nil else { return }
      let popupVC = Hosting(rootView: content)
      popupVC.modalPresentationStyle = .popover
      if let size = size {
        popupVC.preferredContentSize = size
      } else {
        popupVC.preferredContentSize = popupVC.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      }
      popupVC.popoverPresentationController?.delegate = self
      popupVC.popoverPresentationController?.sourceView = view
			
			switch edge {
			case .leading:
				popupVC.popoverPresentationController?.permittedArrowDirections = .right
			case .trailing:
				popupVC.popoverPresentationController?.permittedArrowDirections = .left
			case .top:
				popupVC.popoverPresentationController?.permittedArrowDirections = .down
			case .bottom:
				popupVC.popoverPresentationController?.permittedArrowDirections = .up
			case .none:
				popupVC.popoverPresentationController?.permittedArrowDirections = .any
			}
			
			popupVC.popoverPresentationController?.permittedArrowDirections = .left
      popupVC.popoverPresentationController?.sourceRect = view?.bounds.inset(by: insets) ?? .zero
      if let color = color {
        popupVC.popoverPresentationController?.backgroundColor = color.ui
      }
      popupVC.onDeinit = onHide
      popover = popupVC
      present(popupVC, animated: animated, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
      .none
    }
    
    final class Hosting: UIHostingController<AllEnvironments<T>> {
      var onDeinit: (() -> Void)?
      
      override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
      }
      
      override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
      }
      
      deinit {
        onDeinit?()
      }
    }
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct AllEnvironments<Content: View>: View {
	var environments: EnvironmentValues
	var content: Content
	
	var body: some View {
		content
			.environment(\.self, environments)
	}
}
#endif
