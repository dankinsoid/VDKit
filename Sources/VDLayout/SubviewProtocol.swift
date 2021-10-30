//
//  SubviewProtocol.swift
//  TodoList
//
//  Created by Данил Войдилов on 28.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit
import VDKitRuntime
import VDChain

public protocol SubviewProtocol {
	func createViewToAdd() -> UIView
}

extension UIView: SubviewProtocol {
	public func createViewToAdd() -> UIView { self }
}

extension UIViewController: SubviewProtocol {
	
	public func createViewToAdd() -> UIView {
		loadViewIfNeeded()
		view.onMovedToWindow {[weak self] in
			guard let `self` = self else { return }
			$0.superview?.vc?.addChild(self)
		}
		return view
	}
}

extension UIView {
	
	fileprivate var vc: UIViewController? {
		(next as? UIViewController) ?? (next as? UIView)?.vc
	}
}

extension Chain: SubviewProtocol where Value: SubviewProtocol {
	
	public func createViewToAdd() -> UIView {
		apply().createViewToAdd()
	}
}

extension UIView {
	
	public convenience init(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) {
		self.init()
		subviews().forEach(add)
	}
	
	public func add(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) {
		subviews().forEach(add)
	}
	
	public func with(_ subviews: [SubviewProtocol]) -> Self {
		subviews.forEach(add)
		return self
	}
	
	public func with(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) -> Self {
		with(subviews())
	}
	
	public func callAsFunction(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) -> Self {
		with(subviews())
	}
	
	public func add(subview: SubviewProtocol) {
		let view = subview.createViewToAdd()
		view.translatesAutoresizingMaskIntoConstraints = false
		if let stack = self as? UIStackView {
			stack.addArrangedSubview(view)
		} else {
			addSubview(view)
		}
	}
	
	func onMovedToWindow(_ action: @escaping (UIView) -> Void) {
		if window == nil {
			let cancel = CancelWrapper()
			cancel.cancel = try? onMethodInvoked(#selector(UIView.didMoveToWindow)) {[weak self] _ in
				guard cancel.cancel != nil, self?.window != nil, let `self` = self else { return }
				action(self)
				cancel.cancel?()
				cancel.cancel = nil
			}
		} else {
			action(self)
		}
	}
}

extension UIViewController {
	
	public func add(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) {
		subviews().forEach(add)
	}
	
	public func with(_ subviews: [SubviewProtocol]) -> Self {
		subviews.forEach(add)
		return self
	}
	
	public func with(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) -> Self {
		with(subviews())
	}
	
	public func callAsFunction(@SubviewsBuilder _ subviews: () -> [SubviewProtocol]) -> Self {
		with(subviews())
	}
	
	public func add(subview: SubviewProtocol) {
		loadViewIfNeeded()
		view.add(subview: subview)
	}
}

final class CancelWrapper {
	var cancel: (() -> Void)?
}

extension UIColor: SubviewProtocol {
	public func createViewToAdd() -> UIView {
		let view = UIView()
		view.backgroundColor = self
		return view
	}
}

extension UIImage: SubviewProtocol {
	public func createViewToAdd() -> UIView {
		let view = UIImageView(image: self)
		view.contentMode = .scaleAspectFit
		return view
	}
}

extension String: SubviewProtocol {
	public func createViewToAdd() -> UIView {
		let result = UILabel()
		result.text = self
		return result
	}
}
