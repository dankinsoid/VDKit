//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import UIKit
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets {
	
    public static var zero: EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
	public init(_ value: CGFloat, _ edges: Edge.Set) {
		self = .init(
			top: edges.contains(.top) ? value : 0,
			leading: edges.contains(.leading) ? value : 0,
			bottom: edges.contains(.bottom) ? value : 0,
			trailing: edges.contains(.trailing) ? value : 0
		)
	}
	
	public var ui: UIEdgeInsets {
		UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
	}
}

extension UIEdgeInsets {
	
	@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
	public var swiftUi: EdgeInsets {
		EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
	}
}
