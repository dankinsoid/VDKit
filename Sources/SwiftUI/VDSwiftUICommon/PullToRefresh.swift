//
//  File.swift
//  
//
//  Created by Данил Войдилов on 01.12.2021.
//

#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI
import UIKit

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public func pullToRefresh(_ isRefreshing: Binding<Bool>, accent: Color = .accentColor, title: NSAttributedString? = nil, action: @escaping () -> Void) -> some View {
		overlay(PullToRefresh(isRefreshing: isRefreshing, tint: accent, title: title, action: action).frame(width: 0, height: 0))
	}
	
	public func pullToRefresh(_ isRefreshing: Binding<Bool>, accent: Color = .accentColor, title: String, action: @escaping () -> Void) -> some View {
		pullToRefresh(isRefreshing, accent: accent, title: NSAttributedString(string: title), action: action)
	}
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private struct PullToRefresh: UIViewRepresentable {
	@Binding var isRefreshing: Bool
	var tint: Color
	var title: NSAttributedString?
	var action: () -> Void
	
	func makeUIView(context: Context) -> UIViewType {
		let result = UIViewType()
		result.isUserInteractionEnabled = false
		result.isHidden = true
		return result
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		uiView.refreshControl.tintColor = tint.ui
		uiView.refreshControl.attributedTitle = title
		uiView.action = {
			isRefreshing = true
			action()
		}
		uiView.findScroll()
		if uiView.isAdded, isRefreshing != uiView.refreshControl.isRefreshing {
			isRefreshing ? uiView.refreshControl.beginRefreshing() : uiView.refreshControl.endRefreshing()
		}
	}
	
	final class UIViewType: UIView {
		let refreshControl = UIRefreshControl()
		private weak var scroll: UIScrollView?
		var action: () -> Void = {}
		var isAdded: Bool {
			scroll?.refreshControl === refreshControl
		}
		
		init() {
			super.init(frame: .zero)
			refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		override func didMoveToWindow() {
			super.didMoveToWindow()
			findScroll()
		}
		
		func findScroll() {
			print("isAdded", isAdded)
			guard !isAdded else { return }
			if let scroll = superview?.superview?.allSubviews().compactMap({ $0 as? UIScrollView }).first(where: { $0.refreshControl == nil }) {
				add(to: scroll)
			}
		}
		
		private func add(to scroll: UIScrollView) {
			guard scroll.refreshControl == nil else { return }
			scroll.refreshControl = refreshControl
			self.scroll = scroll
		}
		
		@objc private func refresh(refreshControl: UIRefreshControl) {
			action()
		}
	}
}

private extension UIView {
	
	func allSubviews() -> [UIView] {
		var result = subviews
		for subview in subviews {
			result += subview.allSubviews()
		}
		return result
	}
}
#endif
