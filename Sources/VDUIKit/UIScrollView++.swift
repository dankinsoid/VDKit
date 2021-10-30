//
//  UIScrollView++.swift
//  MusicImport
//
//  Created by crypto_user on 20.02.2020.
//  Copyright © 2020 Данил Войдилов. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIScrollView {
	
	public var contentEdge: UIEdgeInsets {
		UIEdgeInsets(
			top: -contentOffset.y - adjustedContentInset.top,
			left: -contentOffset.x - adjustedContentInset.left,
			bottom: frame.height + contentOffset.y - contentSize.height - adjustedContentInset.bottom,
			right: frame.width + contentOffset.x - contentSize.width - adjustedContentInset.right
		)
	}
	
	public var bounceEdge: UIEdgeInsets {
		UIEdgeInsets(
			top: -contentOffset.y - adjustedContentInset.top,
			left: -contentOffset.x - adjustedContentInset.left,
			bottom: contentOffset.y + adjustedContentInset.top + min(0, frame.height - contentSize.height - adjustedContentInset.bottom - adjustedContentInset.top),
			right: contentOffset.x + adjustedContentInset.left + min(0, frame.width - contentSize.width - adjustedContentInset.right - adjustedContentInset.left)
		)
	}
	
	public var adjustedSize: CGSize {
		CGSize(
			width: frame.width - adjustedContentInset.left - adjustedContentInset.right,
			height: frame.height - adjustedContentInset.top - adjustedContentInset.bottom
		)
	}
}

extension UIEdgeInsets {
	public init(_ top: CGFloat,
							_ h: (CGFloat, CGFloat),
							_ bottom: CGFloat) {
		self = UIEdgeInsets(top: top, left: h.0, bottom: bottom, right: h.1)
	}
}
#endif
