//
//  UIButton++.swift
//  Pods-UIKitExtensions_Tests
//
//  Created by Daniil on 10.08.2019.
//

#if canImport(UIKit)
import UIKit
import ObjectiveC

fileprivate var buttonTargetKey = "buttonTargetKey"

extension UIControl {
    
    public var tap: () -> () {
        get { self[.touchUpInside] }
        set { self[.touchUpInside] = newValue }
    }
    
    public subscript(event: Event) -> () -> () {
        get {
            targets[event.rawValue]?.action ?? {}
        }
        set {
            let target = ButtonTarget(newValue)
            targets[event.rawValue] = target
            addTarget(target, action: #selector(target.objcAction), for: event)
        }
    }
    
    private var targets: [UInt: ButtonTarget] {
        get {
            let result = objc_getAssociatedObject(self, &buttonTargetKey) as? [UInt: ButtonTarget]
            return result ?? [:]
        } set {
            objc_setAssociatedObject(self, &buttonTargetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

fileprivate final class ButtonTarget {
    let action: () -> ()
    
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    @objc func objcAction() {
        action()
    }
    
}

public extension UIButton {
    
	func setBackground(color: UIColor, for state: UIControl.State) {
		setBackgroundImage(UIImage(color: color), for: state)
	}
	
	var font: UIFont? {
		get { titleLabel?.font }
		set { titleLabel?.font = newValue }
	}
    
}
#endif
