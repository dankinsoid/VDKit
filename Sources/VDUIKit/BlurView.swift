//
//  BlurView.swift
//  MusicImport
//
//  Created by Данил Войдилов on 05.07.2019.
//  Copyright © 2019 Данил Войдилов. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class BlurEffectView: UIVisualEffectView {
	
	@IBInspectable open var blurColor: UIColor? {
		get { return subviews.filter { $0.backgroundColor != nil }.last?.backgroundColor }
		set {
			if let color = newValue {
				style = .custom(color)
			} else {
				style = .light
			}
		}
	}
	
	public enum Style {
		case light, dark, extraLight, custom(UIColor)
		
		var defaultStyle: UIBlurEffect.Style {
			switch self {
			case .dark: return .dark
			case .extraLight: return .extraLight
			default: return .light
			}
		}
	}
	
	open var style: Style {
		didSet {
			if case .custom(let color) = style {
				setColor(color)
			} else {
				super.effect = UIBlurEffect(style: style.defaultStyle)
			}
		}
	}
	
	public init(style: Style) {
		self.style = style
		super.init(effect: UIBlurEffect(style: style.defaultStyle))
	}
	
	public convenience init(color: UIColor?) {
		self.init(style: .custom(color ?? .clear))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		self.style = .light
		super.init(coder: aDecoder)
	}
	
	override open func addSubview(_ view: UIView) {
		if case .custom(let color) = style, view.backgroundColor != nil {
			view.backgroundColor = color
		}
		super.addSubview(view)
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		if case .custom(let color) = style {
			setColor(color)
		}
	}
	
	private func setColor(_ color: UIColor) {
		subviews.filter { $0.backgroundColor != nil }.last?.backgroundColor = color
	}
	
}
#endif
