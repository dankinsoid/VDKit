//
//  UIView+LayoutPriority.swift
//  TodoList
//
//  Created by Данил Войдилов on 28.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIView {
	
	public var contentPriority: ContentLayoutPriority { ContentLayoutPriority(view: self) }
	
	public struct ContentLayoutPriority {
		fileprivate let view: UIView
		public var vertical: AxisLayoutPriority { self[for: .vertical] }
		public var horizontal: AxisLayoutPriority { self[for: .horizontal] }
		public var both: AxisLayoutPriority { self[for: .both] }
		
		public subscript(for axis: NSLayoutConstraint.AxisSet) -> AxisLayoutPriority {
			AxisLayoutPriority(view: view, axis: axis.axis)
		}
		
		public subscript(_ direction: LayoutPriorityDirectionSet, for axis: NSLayoutConstraint.AxisSet) -> UILayoutPriority {
			get { self[for: axis][direction] }
			nonmutating set { self[for: axis][direction] = newValue }
		}
	}
	
	public struct AxisLayoutPriority {
		fileprivate let view: UIView
		fileprivate let axis: [NSLayoutConstraint.Axis]
		
		public var hugging: UILayoutPriority {
			get { self[.hugging] }
			nonmutating set { self[.hugging] = newValue }
		}
		public var compression: UILayoutPriority {
			get { self[.compression] }
			nonmutating set { self[.compression] = newValue }
		}
		public var both: UILayoutPriority {
			get { self[.both] }
			nonmutating set { self[.both] = newValue }
		}
		
		public subscript(_ direction: LayoutPriorityDirectionSet) -> UILayoutPriority {
			get {
				var result: [UILayoutPriority] = []
				if direction.contains(.compression) { result += axis.map(view.contentCompressionResistancePriority) }
				if direction.contains(.hugging) { result += axis.map(view.contentHuggingPriority) }
				return result.max() ?? .defaultHigh
			}
			nonmutating set {
				if direction.contains(.compression) { axis.forEach { view.setContentCompressionResistancePriority(newValue, for: $0) } }
				if direction.contains(.hugging) { axis.forEach { view.setContentHuggingPriority(newValue, for: $0) } }
			}
		}
	}
	
	@frozen
	public enum LayoutPriorityDirection: UInt8, CaseIterable {
		case hugging, compression
	}
	
	public struct LayoutPriorityDirectionSet: OptionSet {
		public var rawValue: UInt8
		public var directions: [LayoutPriorityDirection] {
			LayoutPriorityDirection.allCases.filter { contains(LayoutPriorityDirectionSet($0)) }
		}
		
		public init(rawValue: UInt8) {
			self.rawValue = rawValue
		}
		
		public init(_ direction: LayoutPriorityDirection) {
			rawValue = direction.rawValue
		}
		
		public static var hugging: LayoutPriorityDirectionSet { LayoutPriorityDirectionSet(.hugging) }
		public static var compression: LayoutPriorityDirectionSet { LayoutPriorityDirectionSet(.compression) }
		public static var both: LayoutPriorityDirectionSet { [.hugging, .compression] }
	}
}

extension NSLayoutConstraint {
	
	public struct AxisSet: OptionSet {
		public var rawValue: Int
		public var axis: [Axis] {
			[Axis.vertical, Axis.horizontal].filter { contains(AxisSet($0)) }
		}
		
		public init(rawValue: Int) {
			self.rawValue = rawValue
		}
		
		public init(_ direction: Axis) {
			rawValue = direction.rawValue
		}
		
		public static var vertical: AxisSet { AxisSet(.vertical) }
		public static var horizontal: AxisSet { AxisSet(.horizontal) }
		public static var both: AxisSet { [.horizontal, .vertical] }
	}	
}

extension UILayoutPriority: ExpressibleByFloatLiteral {
	
	public init(floatLiteral value: Float) {
		self = UILayoutPriority(value)
	}
	
	public static func custom(_ raw: Float) -> UILayoutPriority {
		UILayoutPriority(raw)
	}
}
#endif
