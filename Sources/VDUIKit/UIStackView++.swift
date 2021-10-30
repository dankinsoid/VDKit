//
//  UIStackView++.swift
//  Challenger
//
//  Created by Daniil on 04.05.2020.
//  Copyright © 2020 Daniil. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIStackView {
    
    public func update<T, V: UIView>(items: [T], create: () -> V, update: (T, V, Int) -> ()) {
        let dif = arrangedSubviews.count - items.count
        arrangedSubviews.suffix(max(0, dif)).reversed().forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        if dif < 0 {
            for _ in 0..<abs(dif) { addArrangedSubview(create()) }
        }
        zip(items, arrangedSubviews.compactMap { $0 as? V }).enumerated().forEach {
            update($0.element.0, $0.element.1, $0.offset)
        }
    }
}
#endif
