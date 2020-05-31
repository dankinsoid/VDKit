//
//  CheckMarkView.swift
//  SuccessAlert
//
//  Created by Данил Войдилов on 14.04.2018.
//  Copyright © 2018 Данил Войдилов. All rights reserved.
//

import UIKit

open class CheckMarkView: BezierAnimatedView {
    open override var bezier: UIBezierPath {
        let path = UIBezierPath()
        let halfWidth = lineWidth / 2
        path.move(to: CGPoint(x: halfWidth, y: frame.height / 2))
        path.addLine(to: CGPoint(x: frame.width * 0.35, y: frame.height - halfWidth))
        path.addLine(to: CGPoint(x: frame.width - halfWidth, y: halfWidth))
        return path
    }
    
}

