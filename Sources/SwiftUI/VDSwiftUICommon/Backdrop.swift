//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Backdrop: UIViewRepresentable {
  
	public init() {}
	
	public func makeUIView(context: Context) -> UIViewType {
		UIViewType()
	}
	
	public func updateUIView(_ uiView: UIViewType, context: Context) {}
	
	public final class UIViewType: UIView {
		
		public override class var layerClass: AnyClass {
			NSClassFromString("CABackdropLayer") ?? CALayer.self
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Backdrop_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			HStack {
				Color.red
				Color.blue
				Color.green
				Color.purple
			}
			Text("Top text")
				.background(Backdrop())
		}
	}
}
#endif
