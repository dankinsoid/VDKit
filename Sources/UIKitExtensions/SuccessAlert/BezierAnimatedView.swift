//
//  BezierAnimatedView.swift
//  SuccessAlert
//
//  Created by Данил Войдилов on 14.04.2018.
//  Copyright © 2018 Данил Войдилов. All rights reserved.
//

import UIKit

@IBDesignable
open class BezierAnimatedView: UIView, AnimatedViewProtocol {
    weak private var shapeLayer: CAShapeLayer?
    @IBInspectable open var lineWidth: CGFloat = 9
    //@IBInspectable open var tintColor: UIColor = #colorLiteral(red: 0.3489781618, green: 0.3490435183, blue: 0.3489740491, alpha: 1)
    open var bezierBlock: ((BezierAnimatedView) -> UIBezierPath)? = nil
    open var bezier: UIBezierPath {
        return bezierBlock?(self) ?? UIBezierPath()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(aspectRatio: CGSize, lineWidth: CGFloat = 9, color: UIColor = #colorLiteral(red: 0.3489781618, green: 0.3490435183, blue: 0.3489740491, alpha: 1), bezier: ((BezierAnimatedView) -> UIBezierPath)? = nil) {
        super.init(frame: CGRect(origin: .zero, size: aspectRatio))
        self.bezierBlock = bezier
        self.tintColor = color
        self.lineWidth = lineWidth
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func drawAnimation(_ block: (() -> ())? = nil) {
        self.shapeLayer?.removeFromSuperlayer()
        let shapeLayer = getLayer()
        CATransaction.begin()
        CATransaction.setCompletionBlock(block)
        layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.3
        shapeLayer.add(animation, forKey: "BezierViewAnimation")
        self.shapeLayer = shapeLayer
        CATransaction.commit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.shapeLayer?.removeFromSuperlayer()
        self.shapeLayer = getLayer()
        layer.addSublayer(shapeLayer!)
    }
    
    private func getLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = bezier.cgPath
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        return shapeLayer
    }
    
}
