//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 06.10.2021.
//

import SwiftUI
import UIKit

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    
    public func uiGesture<Gesture: UIGestureRecognizer>(_ gesture: @escaping @autoclosure () -> Gesture, update: @escaping (Gesture) -> Void) -> some View {
        GesturesView(content: self, create: gesture, update: update)
    }
    
    public func uiGesture<Gesture: UIGestureRecognizer>(_ gesture: @escaping () -> Gesture, update: @escaping (Gesture) -> Void) -> some View {
        GesturesView(content: self, create: gesture, update: update)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct GesturesView<Content: View, Gesture: UIGestureRecognizer>: UIViewControllerRepresentable {
    
    let content: Content
    let create: () -> Gesture
    let update: (Gesture) -> Void
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let view = UIViewControllerType(rootView: content)
        view.add(gesture: create())
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.rootView = content
        uiViewController.update = update
    }
    
    final class UIViewControllerType: UIHostingController<Content> {
        
        var update: ((Gesture) -> Void)?
        
        @objc func gesture(sender: UIGestureRecognizer) {
            guard let gestuer = sender as? Gesture else { return }
            update?(gestuer)
        }
        
        func add(gesture: Gesture) {
            loadViewIfNeeded()
            gesture.addTarget(view!, action: #selector(gesture(sender:)))
            view.addGestureRecognizer(gesture)
        }
    }
}
