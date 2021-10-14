//
//  IteraleBuilder.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder
public struct IterableViewBuilder {
	
	@inline(__always)
	public static func buildBlock() -> EmptyView {
		EmptyView()
	}
	
	@inline(__always)
	public static func buildBlock<F: IterableView>(_ component: F) -> F {
		component
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView>(_ f1: F1, _ f2: F2) -> Pair<F1, F2> {
		Pair(f1, f2)
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3) -> Pair<F1, Pair<F2, F3>> {
		Pair(f1, Pair(f2, f3))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4) -> Pair<F1, Pair<F2, Pair<F3, F4>>> {
		Pair(f1, Pair(f2, Pair(f3, f4)))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, F5>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, f5))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, F6>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, f6)))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, F7>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, f7))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, F8>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, f8)))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, F9>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, f9))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, F10>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, f10)))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, F11>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, f11))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, F12>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, f12)))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, F13>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, f13))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, F14>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, f14)))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView, F15: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14, _ f15: F15) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, Pair<F14, F15>>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, Pair(f14, f15))))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView, F15: IterableView, F16: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14, _ f15: F15, _ f16: F16) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, Pair<F14, Pair<F15, F16>>>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, Pair(f14, Pair(f15, f16)))))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView, F15: IterableView, F16: IterableView, F17: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14, _ f15: F15, _ f16: F16, _ f17: F17) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, Pair<F14, Pair<F15, Pair<F16, F17>>>>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, Pair(f14, Pair(f15, Pair(f16, f17))))))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView, F15: IterableView, F16: IterableView, F17: IterableView, F18: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14, _ f15: F15, _ f16: F16, _ f17: F17, _ f18: F18) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, Pair<F14, Pair<F15, Pair<F16, Pair<F17, F18>>>>>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, Pair(f14, Pair(f15, Pair(f16, Pair(f17, f18)))))))))))))))))
	}
	
	@inline(__always)
	public static func buildBlock<F1: IterableView, F2: IterableView, F3: IterableView, F4: IterableView, F5: IterableView, F6: IterableView, F7: IterableView, F8: IterableView, F9: IterableView, F10: IterableView, F11: IterableView, F12: IterableView, F13: IterableView, F14: IterableView, F15: IterableView, F16: IterableView, F17: IterableView, F18: IterableView, F19: IterableView>(_ f1: F1, _ f2: F2, _ f3: F3, _ f4: F4, _ f5: F5, _ f6: F6, _ f7: F7, _ f8: F8, _ f9: F9, _ f10: F10, _ f11: F11, _ f12: F12, _ f13: F13, _ f14: F14, _ f15: F15, _ f16: F16, _ f17: F17, _ f18: F18, _ f19: F19) -> Pair<F1, Pair<F2, Pair<F3, Pair<F4, Pair<F5, Pair<F6, Pair<F7, Pair<F8, Pair<F9, Pair<F10, Pair<F11, Pair<F12, Pair<F13, Pair<F14, Pair<F15, Pair<F16, Pair<F17, Pair<F18, F19>>>>>>>>>>>>>>>>>> {
		Pair(f1, Pair(f2, Pair(f3, Pair(f4, Pair(f5, Pair(f6, Pair(f7, Pair(f8, Pair(f9, Pair(f10, Pair(f11, Pair(f12, Pair(f13, Pair(f14, Pair(f15, Pair(f16, Pair(f17, Pair(f18, f19))))))))))))))))))
	}
	
	@inline(__always)
	public static func buildOptional<F: IterableView>(_ component: F?) -> OptionalView<F> {
		OptionalView(component)
	}
	
	@inline(__always)
	public static func buildEither<F: IterableView, S: IterableView>(first: F) -> IfViewIterable<F, S> {
		.first(first)
	}
	
	@inline(__always)
	public static func buildEither<F: IterableView, S: IterableView>(second: S) -> IfViewIterable<F, S> {
		.second(second)
	}
	
	@inline(__always)
	public static func buildArray<F: IterableView>(_ components: [F]) -> ArrayView<F> {
		ArrayView(components)
	}
	
	@inline(__always)
	public static func buildExpression<F: IterableView>(_ expression: F) -> F {
		expression
	}
	
	@inline(__always)
	public static func buildExpression<F: View>(_ expression: F) -> SingleView<F> {
		SingleView(expression)
	}
	
	@inline(__always)
	public static func buildLimitedAvailability<F: IterableView>(_ component: F) -> F {
		component
	}
}
