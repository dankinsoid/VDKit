//
//  Animation++.swift
//  Pods-UIKitExtensions_Tests
//
//  Created by Daniil on 10.08.2019.
//

#if canImport(UIKit)
import UIKit

extension CAPropertyAnimation {
    
    public convenience init<V: CALayer, T>(keyPath: KeyPath<V, T>) {
        self.init(keyPath: keyPath._kvcKeyPathString)
    }
    
}

extension UIView {
    
    @discardableResult
    public static func animate(_ duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], _ animations: @escaping () -> (), completion: ((Bool) -> ())? = nil) -> StepAnimation {
        let animation = StepAnimation()
        let result = animation.then(duration, delay: delay, options: options, animations, completion: completion)
        animation.nextBlock?()
        return result
    }
    
    @discardableResult
    public func animate(_ duration: TimeInterval, delay: TimeInterval = 0, usingSpringWithDamping damping: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIView.AnimationOptions = [], _ animations: @escaping () -> (), completion: ((Bool) -> ())? = nil) -> StepAnimation {
        let animation = StepAnimation()
        let result = animation.then(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations, completion: completion)
        animation.nextBlock?()
        return result
    }
    
    public final class StepAnimation {
        
        fileprivate var nextBlock: (() -> ())?
        
        fileprivate init() {}
        
        @discardableResult
        public func then(_ duration: TimeInterval, delay: TimeInterval = 0, usingSpringWithDamping damping: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIView.AnimationOptions = [], _ animations: @escaping () -> (), completion: ((Bool) -> ())? = nil) -> StepAnimation {
            let result = StepAnimation()
            nextBlock = {
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: animations) { success in
                    completion?(success)
                    result.nextBlock?()
                }
            }
            return result
        }
        
        @discardableResult
        public func then(_ duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], _ animations: @escaping () -> (), completion: ((Bool) -> ())? = nil) -> StepAnimation {
            let result = StepAnimation()
            nextBlock = {
                UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations) { success in
                    completion?(success)
                    result.nextBlock?()
                }
            }
            return result
        }
        
    }
    
}
#endif
