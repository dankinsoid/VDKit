//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.10.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    public func smallPopover<T: View>(_ isAppear: Binding<Bool>, size: CGSize? = nil, insets: EdgeInsets = .zero, @ViewBuilder content: () -> T) -> some View {
        background(
            Popover(content: content(), size: size, insets: insets, isAppear: isAppear)
        )
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct Popover<T: View>: UIViewControllerRepresentable {
    
    let content: T
    let size: CGSize?
    let insets: EdgeInsets
    @Binding var isAppear: Bool
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType(content: content, size: size, insets: insets.ui)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.content = content
        uiViewController.size = size
        uiViewController.insets = insets.ui
        uiViewController.popover?.rootView = content
        if let size = size {
            uiViewController.popover?.preferredContentSize = size
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
        var content: T
        var size: CGSize?
        var insets: UIEdgeInsets
        var onHide: (() -> Void)?
        weak var popover: UIHostingController<T>?
        
        init(content: T, size: CGSize?, insets: UIEdgeInsets) {
            self.content = content
            self.size = size
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
            popupVC.popoverPresentationController?.sourceRect = view?.bounds.inset(by: insets) ?? .zero
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
        
        final class Hosting: UIHostingController<T> {
            var onDeinit: (() -> Void)?
            
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
