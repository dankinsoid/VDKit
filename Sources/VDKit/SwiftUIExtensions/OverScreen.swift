//
//  File.swift
//  
//
//  Created by Данил Войдилов on 23.10.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func overScreen() -> some View {
		OverScreen(content: self)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct OverScreen<Content: View>: UIViewControllerRepresentable {
	
	let content: Content
	
	func makeUIViewController(context: Context) -> UIViewControllerType {
		UIViewControllerType(rootView: content)
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		uiViewController.rootView = content
	}
	
	final class UIViewControllerType: UIHostingController<Content> {
		
		override func viewDidLoad() {
			super.viewDidLoad()
			view.layer.transform = .translate(x: 0, y: 0, z: 1)
			view.layer.zPosition = 2
		}
		
		override func didMove(toParent parent: UIViewController?) {
			super.didMove(toParent: parent)
			view.window?.bringSubviewToFront(view)
		}
		
		override func viewDidLayoutSubviews() {
			super.viewDidLayoutSubviews()
			view.window?.bringSubviewToFront(view)
		}
	}
	
	final class UIViewType: UIView {
		
		override func didMoveToSuperview() {
			super.didMoveToSuperview()
			window?.bringSubviewToFront(self)
		}
		
		override func didMoveToWindow() {
			super.didMoveToWindow()
			window?.bringSubviewToFront(self)
		}
	}
}
