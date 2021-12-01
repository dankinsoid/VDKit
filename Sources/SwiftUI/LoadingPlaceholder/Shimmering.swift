//
//  SwiftUIView.swift
//  
//
//  Created by Данил Войдилов on 21.11.2021.
//

import SwiftUI
import BindGeometry
#if canImport(UIKit)
import UIKit
private let screenSize = UIScreen.main.bounds.size
#elseif canImport(Cocoa)
import Cocoa
private let screenSize = NSScreen.main?.frame.size ?? .zero
#else
private let screenSize = CGSize.zero
#endif

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Shimmering: View {
	
	@State private var progress: Double = 0
	@State private var frame: CGRect = .zero
	@Environment(\.shimmeringGlareColor) private var glareColor: Color
	@Environment(\.shimmeringBackgroundColor) private var backgroundColor: Color
	@Environment(\.shimmeringDuration) private var fullDuration: Double
	@Environment(\.shimmeringGlareWidth) private var gradientWidth: Double
	private var gradientK: Double { 2 + gradientWidth }
	private let roundCorners: Bool
	
	public init(roundCorners: Bool = true) {
		self.roundCorners = roundCorners
	}
	
	public var body: some View {
		LinearGradient(
			stops: [
				Gradient.Stop(color: glareColor.opacity(0), location: 0),
				Gradient.Stop(color: glareColor.opacity(0), location: 1 / gradientK),
				Gradient.Stop(color: glareColor, location: (1 + gradientWidth / 2) / gradientK),
				Gradient.Stop(color: glareColor.opacity(0), location: (1 + gradientWidth) / gradientK),
				Gradient.Stop(color: glareColor.opacity(0), location: 1)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
			.padding(
				EdgeInsets(
					top: -(frame.minY + screenSize.height * (1 + gradientWidth)),
					leading: -(frame.minX + screenSize.width * (1 + gradientWidth)),
					bottom: -(screenSize.height * (1 + gradientWidth) - frame.maxY),
					trailing: -(screenSize.width * (1 + gradientWidth) - frame.maxX)
				)
			)
			.offset(
				x: progress * screenSize.width * (1 + gradientWidth),
				y: progress * screenSize.height * (1 + gradientWidth)
			)
			.background(backgroundColor)
			.cornerRadius(roundCorners ? min(frame.width, frame.height) / 2 : 0)
			.clipped()
			.bindFrame(in: .global, to: $frame)
			.onAppear {
				let mod = CACurrentMediaTime().truncatingRemainder(dividingBy: fullDuration)
				let duration = fullDuration - mod
				progress = mod / fullDuration
				withAnimation(.linear(duration: duration)) {
					progress = 1
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(Int(duration * 1_000_000))) {
					progress = 0
					withAnimation(.linear(duration: fullDuration).repeatForever(autoreverses: false)) {
						progress = 1 - progress
					}
				}
			}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum ShimmeringGlareColorKey: EnvironmentKey {
	static var defaultValue: Color { .white.opacity(0.5) }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var shimmeringGlareColor: Color {
		get { self[ShimmeringGlareColorKey.self] }
		set { self[ShimmeringGlareColorKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum ShimmeringBackColorKey: EnvironmentKey {
	static var defaultValue: Color { .accentColor.opacity(0.5) }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var shimmeringBackgroundColor: Color {
		get { self[ShimmeringBackColorKey.self] }
		set { self[ShimmeringBackColorKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum ShimmeringDurationKey: EnvironmentKey {
	static var defaultValue: Double { 1 }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var shimmeringDuration: Double {
		get { self[ShimmeringDurationKey.self] }
		set { self[ShimmeringDurationKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private enum ShimmeringWidthKey: EnvironmentKey {
	static var defaultValue: Double { 0.3 }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
	public var shimmeringGlareWidth: Double {
		get { self[ShimmeringWidthKey.self] }
		set { self[ShimmeringWidthKey.self] = newValue }
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func shimmering(glareColor: Color) -> some View {
		environment(\.shimmeringGlareColor, glareColor)
	}
	public func shimmering(backgroundColor: Color) -> some View {
		environment(\.shimmeringBackgroundColor, backgroundColor)
	}
	public func shimmering(duration: Double) -> some View {
		environment(\.shimmeringDuration, duration)
	}
	public func shimmering(glareRelativeWidth: Double) -> some View {
		environment(\.shimmeringGlareWidth, glareRelativeWidth)
	}
}

