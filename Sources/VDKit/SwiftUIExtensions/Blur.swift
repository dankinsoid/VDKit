//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Blur<Content: View>: View {
	
	public let content: Content
	public var radius: CGFloat
	public var opaque: Bool
	
	public init(radius: CGFloat = 3.0, opaque: Bool = false, @ViewBuilder content: () -> Content) {
		self.content = content()
		self.radius = radius
		self.opaque = opaque
	}
	
	public var body: some View {
		ZStack {
			BackdropView()
				.blur(radius: radius, opaque: opaque)
			content
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Blur_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			HStack {
				Color.red
				Color.blue
				Color.green
			}
			Blur {
				Text("Top text")
			}
		}
	}
}
