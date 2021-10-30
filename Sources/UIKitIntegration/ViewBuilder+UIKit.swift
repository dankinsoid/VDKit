//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.10.2021.
//

import Foundation
import UIKit
import SwiftUI
import VDLayout

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ViewBuilder {
	
	@inline(__always)
	public static func buildExpression<V: View>(_ expression: V) -> V {
		expression
	}
	
	@inline(__always)
	public static func buildExpression<V: SubviewProtocol>(_ expression: @escaping @autoclosure () -> V) -> some View {
		UIKitView {
			expression().createViewToAdd()
		}
		.edgesIgnoringSafeArea(.all)
	}
	
	@inline(__always)
	public static func buildExpression<V: UIViewController>(_ expression: @escaping @autoclosure () -> V) -> some View {
		UIKitView(expression)
			.edgesIgnoringSafeArea(.all)
	}
}
