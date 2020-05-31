//
//  NSLayoutConstraint_Extension.swift
//  SuccessAlert
//
//  Created by Данил Войдилов on 14.04.2018.
//  Copyright © 2018 Данил Войдилов. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    convenience public init(aspectRatio: CGFloat, item: Any) {
        self.init(item: item, attribute: .width, relatedBy: .equal, toItem: item, attribute: .height, multiplier: aspectRatio, constant: 0)
    }
    
    convenience public init(aspectRatio: CGSize, item: Any) {
        self.init(item: item, attribute: .width, relatedBy: .equal, toItem: item, attribute: .height, multiplier: aspectRatio.width / aspectRatio.height, constant: 0)
    }
}
