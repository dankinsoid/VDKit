////
////  File.swift
////  
////
////  Created by Данил Войдилов on 19.10.2021.
////
//
//import SwiftUI
//
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//extension View {
//  
//  public func innerShadow(color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
//    modifier(InnerShadowModifier(color: color, radius: radius, offset: CGPoint(x: x, y: y)))
//  }
//}
//
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//public struct InnerShadowModifier: ViewModifier {
//  
//  public var color: Color
//  public var radius: CGFloat
//  public var offset: CGPoint
//  
//  public init(color: Color, radius: CGFloat, offset: CGPoint) {
//    self.color = color
//    self.radius = radius
//    self.offset = offset
//  }
//  
//  public func body(content: Content) -> some View {
//    if #available(iOS 15.0, *) {
//      content
//        .overlay(
//          Rectangle()
//            .mask {
//              content
//                .compositingGroup()
//                .luminanceToAlpha()
//            }
//            .shadow(color: color, radius: radius, x: offset.x, y: offset.y)
//        )
//    } else {
//      content
//    }
//  }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//struct InnerShadow_Previews: PreviewProvider {
//  
//  static var previews: some View {
//    Color.red
//      .innerShadow(radius: 10)
//  }
//}
