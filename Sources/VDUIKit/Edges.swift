//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

#if canImport(UIKit)
import Foundation
import UIKit

public enum Edges: Int8, CaseIterable {
	
	case top = 1, leading = 2, bottom = 4, trailing = 8
	
	public struct Set: OptionSet {
		public static let top = Set(.top)
		public static let leading = Set(.leading)
		public static let bottom = Set(.bottom)
		public static let trailing = Set(.trailing)
		public static let all = Edges.Set(Edges.allCases)
		public static let horizontal: Edges.Set = [.leading, .trailing]
		public static let vertical: Edges.Set = [.top, .bottom]
		
		public let rawValue: Int8
		
		public init(_ e: Edges) {
			rawValue = e.rawValue
		}
		
		public init(_ e: [Edges]) {
			self = Edges.Set(e.map(Set.init))
		}
		
		public init(rawValue: Int8) {
			self.rawValue = rawValue
		}
	}
}

extension Edges {
	public static var left: Edges { .leading }
	public static var right: Edges { .trailing }
	
	public var axe: NSLayoutConstraint.Axis {
		switch self {
		case .bottom, .top: return .vertical
		case .leading, .trailing: return .horizontal
		}
	}
	
	public var opposite: Edges {
		switch self {
		case .leading: return .trailing
		case .bottom: return .top
		case .top: return .bottom
		case .trailing: return .leading
		}
	}
}

extension UIRectEdge {
	public init(_ edge: Edges) {
		switch edge {
		case .leading: 	self = .left
		case .bottom: 	self = .bottom
		case .top: 			self = .top
		case .trailing: self = .right
		}
	}
}

extension UIEdgeInsets {
	public subscript(_ edge: Edges) -> CGFloat {
		switch edge {
		case .leading: 	return right
		case .bottom: 	return top
		case .top: 			return bottom
		case .trailing: return left
		}
	}
}

extension CACornerMask {
	public static func edge(_ edge: Edges) -> CACornerMask {
		switch edge {
		case .leading: 	return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
		case .bottom: 	return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
		case .top: 			return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		case .trailing: return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
		}
	}
}
#endif
