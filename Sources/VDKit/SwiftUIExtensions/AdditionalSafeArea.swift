//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 15.08.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct AdditionalSafeAreaView<Content: View>: UIViewControllerRepresentable {
  
    let content: Content
    let edges: EdgeInsets

    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let result = UIHostingController(rootView: content)
        updateInsets(result)
        return result
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        updateInsets(uiViewController)
    }
    
    private func updateInsets(_ uiViewController: UIHostingController<Content>) {
        uiViewController.additionalSafeAreaInsets = edges.ui
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AdditionalSafeAreaModifier: ViewModifier {
    
    public let insets: EdgeInsets
    
    public init(_ insets: EdgeInsets) {
        self.insets = insets
    }
    
    public func body(content: Content) -> some View {
        AdditionalSafeAreaView(content: content, edges: insets)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    public func additionalSafeArea(_ insets: EdgeInsets) -> some View {
        modifier(AdditionalSafeAreaModifier(insets))
    }
    
    
    public func additionalSafeArea(_ edges: Edge.Set = .all, _ length: CGFloat = 0) -> some View {
        additionalSafeArea(EdgeInsets(length, edges))
    }
}
