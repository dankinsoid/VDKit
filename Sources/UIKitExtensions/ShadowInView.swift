//
//  ShadowInView.swift
//  MusicImport
//
//  Created by Daniil on 12.04.2020.
//  Copyright © 2020 Данил Войдилов. All rights reserved.
//

import UIKit

open class ViewShadowIn: UIView {
    private let view = InnerShadow()
    
    @IBInspectable
    public final var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            view.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public final var inShadowRadius: CGFloat {
        get { view.shadowRadius }
        set { view.shadowRadius = newValue }
    }
    
    @IBInspectable
    public final var inShadowColor: UIColor {
        get { view.layer.shadowColor.map(UIColor.init) ?? .clear }
        set { view.layer.shadowColor = newValue.cgColor }
    }
    
    @IBInspectable
    public final var inShadowOffset: CGSize {
        get { view.layer.shadowOffset }
        set { view.layer.shadowOffset = newValue }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        afterInit()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        afterInit()
    }
    
    private func afterInit() {
        backgroundColor = .clear
        addSubview(view)
        clipsToBounds = true
        view.frame = bounds
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
    override open func addSubview(_ view: UIView) {
        super.addSubview(view)
        bringSubviewToFront(self.view)
    }
    
}

open class InnerShadow: UIView {
    private let view = UIView()
    private let maskLayer = CAShapeLayer()
    
    @IBInspectable
    public final var shadowRadius: CGFloat = 0 {
        didSet { setShadow() }
    }
    
    @IBInspectable
    public final var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            view.layer.cornerRadius = newValue
            setShadow()
        }
    }
    
    override public var backgroundColor: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        afterInit()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        afterInit()
    }
    
    private func afterInit() {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        super.backgroundColor = .clear
        addSubview(view)
        view.backgroundColor = MI.Colors.background
        view.layer.mask = maskLayer
        setShadow()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }
    
    private func setShadow() {
        layer.shadowRadius = shadowRadius
        view.frame = CGRect(x: -shadowRadius * 2, y: -shadowRadius * 2, width: frame.width + 4 * shadowRadius, height: frame.height + 4 * shadowRadius)
        maskLayer.fillRule = .evenOdd
        maskLayer.frame = view.layer.bounds
        maskLayer.path = shadowPath()
    }
    
    private func shadowPath() -> CGPath {
        let size = view.frame.size
        let rect = CGRect(x: shadowRadius * 2, y: shadowRadius * 2, width: size.width - 4 * shadowRadius, height: size.height - 4 * shadowRadius)
        let path = CGMutablePath()
        path.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius - 1).cgPath)
        path.addPath(UIBezierPath(rect: CGRect(origin: .zero, size: size)).cgPath)
        return path
    }
}
