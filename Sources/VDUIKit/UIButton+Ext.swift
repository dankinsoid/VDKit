//
//  UIButton+Ext.swift
//  TodoList
//
//  Created by George Prokopenko on 24/06/2020.
//  Copyright © 2020 Magic Solutions. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIButton {
	
	public convenience init(type: ButtonType, _ event: Event = .touchUpInside, _ onTap: @escaping () -> Void) {
		self.init(type: type)
		self[event] = onTap
	}
	
	public var title: String? {
		get { title(for: .normal) }
		set { setTitle(newValue, for: .normal) }
	}
	
	public var titles: UIControl.States<String> {
		UIControl.States(get: title, set: setTitle)
	}
	
	public var image: UIImage? {
		get { image(for: .normal) }
		set { setImage(newValue, for: .normal) }
	}
	
	public var images: UIControl.States<UIImage> {
		UIControl.States(get: image, set: setImage)
	}
	
	public var backgroundImage: UIImage? {
		get { backgroundImage(for: .normal) }
		set { setBackgroundImage(newValue, for: .normal) }
	}
	
	public var backgroundImages: UIControl.States<UIImage> {
		UIControl.States(get: backgroundImage, set: setBackgroundImage)
	}
	
	public var titleColor: UIColor? {
		get { titleColor(for: .normal) }
		set { setTitleColor(newValue, for: .normal) }
	}
	
	public var titleColors: UIControl.States<UIColor> {
		UIControl.States(get: titleColor, set: setTitleColor)
	}
	
	public func setHorizontalInsets(left: CGFloat, iconButton: CGFloat, right: CGFloat) {
		titleEdgeInsets.right = right
		titleEdgeInsets.left = -titleEdgeInsets.right
		imageEdgeInsets.right = iconButton + right
		imageEdgeInsets.left = -imageEdgeInsets.right
		contentEdgeInsets.left = iconButton + right + left
	}
}
#endif
