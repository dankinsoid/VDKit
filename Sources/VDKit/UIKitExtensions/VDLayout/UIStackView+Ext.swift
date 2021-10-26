//
//  UIStackView+Ext.swift
//  TodoList
//
//  Created by Данил Войдилов on 28.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit

extension UIStackView {
	
	public convenience init(
		_ axis: NSLayoutConstraint.Axis,
		spacing: CGFloat = 0,
		alignment: Alignment = .fill,
		distribution: Distribution = .fill,
		@SubviewsBuilder _ subviews: () -> [SubviewProtocol]
	) {
		self.init(axis, spacing: spacing, alignment: alignment, distribution: distribution)
		subviews().forEach(add)
	}
	
	public convenience init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, alignment: Alignment = .fill, distribution: Distribution = .fill) {
		self.init()
		self.axis = axis
		self.alignment = alignment
		self.spacing = spacing
		self.distribution = distribution
	}
	
	public func removeSubviews() {
		arrangedSubviews.forEach {
			removeArrangedSubview($0)
			$0.removeFromSuperview()
		}
	}
}
