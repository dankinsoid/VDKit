//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import CoreGraphics
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
  
  public static func all(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .all) }
  public static func top(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .top) }
  public static func bottom(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .bottom) }
  public static func leading(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .leading) }
  public static func trailing(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .trailing) }
  public static func vertical(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .vertical) }
  public static func horizontal(_ value: CGFloat) -> EdgeInsets { EdgeInsets(value, .horizontal) }
}

#if canImport(UIKit)
import UIKit
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EdgeInsets {
	
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
#endif
