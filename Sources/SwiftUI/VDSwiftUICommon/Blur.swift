//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Blur: View {
	
	public var radius: CGFloat
	public var opaque: Bool
	
	public init(radius: CGFloat = 3.0, opaque: Bool = false) {
		self.radius = radius
		self.opaque = opaque
	}
	
	public var body: some View {
		Backdrop()
			.blur(radius: radius, opaque: opaque)
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
			Text("Top text")
				.background(Blur())
		}
	}
}
