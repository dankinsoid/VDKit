//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BackdropView: UIViewRepresentable {
  
	public init()
	
	public func makeUIView(context: Context) -> UIBackdropView {
		UIBackdropView()
	}
	
	public func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Backdrop<Content: View>: View {
	
	public let content: Content
	
	public init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	
	public var body: some View {
		ZStack {
			BackdropView()
			content
		}
	}
}
