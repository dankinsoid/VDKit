//
//  UIView++.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//

import UIKit

fileprivate var viewTargetKey = "viewRecognizerTargetKey"

extension UIView {
	
	public var x: CGFloat {
		get { frame.origin.x }
		set { frame.origin.x = newValue }
	}
	public var y: CGFloat {
		get { frame.origin.y }
		set { frame.origin.y = newValue }
	}
	public var width: CGFloat {
		get { frame.size.width }
		set { frame.size.width = newValue }
	}
	public var height: CGFloat {
		get { frame.size.height }
		set { frame.size.height = newValue }
	}
	
	
	public var vc: UIViewController? {
		(next as? UIViewController) ?? (next as? UIView)?.vc
	}
	
	public var onTap: () -> () {
		get { tapViewTarget.action }
		set {
			let target = tapViewTarget
			target.action = newValue
			let recognizer = (gestureRecognizers?.first(where: { $0.name == viewTargetKey }) as? UITapGestureRecognizer) ?? UITapGestureRecognizer()
			recognizer.name = viewTargetKey
			if recognizer.view !== self {
				addGestureRecognizer(recognizer)
			}
			recognizer.addTarget(target, action: #selector(target.objcAction))
		}
	}
	
	private var tapViewTarget: ViewTarget {
		get {
			let result = (objc_getAssociatedObject(self, &viewTargetKey) as? ViewTarget) ?? ViewTarget({})
			objc_setAssociatedObject(self, &viewTargetKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return result
		} set {
			objc_setAssociatedObject(self, &viewTargetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	public func allSubviews() -> [UIView] {
		var result = subviews
		for subview in subviews {
			result += subview.allSubviews()
		}
		return result
	}
	
	public func allSubviews<T: UIView>(of type: T.Type) -> [T] {
		return allSubviews().compactMap({ $0 as? T })
	}
	
	public func setEdgesToSuperview(leading: CGFloat? = 0, trailing: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0) {
		guard let sv = superview else { return }
		translatesAutoresizingMaskIntoConstraints = false
		if let l = leading {
			NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: sv, attribute: .leading, multiplier: 1, constant: l).isActive = true
		}
		if let t = trailing {
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: sv, attribute: .trailing, multiplier: 1, constant: t).isActive = true
		}
		if let t = top {
			NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: sv, attribute: .top, multiplier: 1, constant: t).isActive = true
		}
		if let b = bottom {
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: sv, attribute: .bottom, multiplier: 1, constant: b).isActive = true
		}
	}
	
	public func addSubviews(_ views: [UIView]) {
		views.forEach(addSubview)
	}
	
	public func addSubviews(_ views: UIView...) {
		addSubviews(views)
	}
	
}

fileprivate final class ViewTarget {
	var action: () -> ()
	
	init(_ action: @escaping () -> ()) {
		self.action = action
	}
	
	@objc func objcAction() {
		action()
	}
	
}

extension UIViewController {
	public var vcForPresent: UIViewController {
		presentedViewController?.vcForPresent ?? presentedViewController ?? self
	}
}

