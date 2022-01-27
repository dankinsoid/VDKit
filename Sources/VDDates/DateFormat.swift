//
//  File.swift
//  
//
//  Created by Данил Войдилов on 27.01.2022.
//

import Foundation

public struct DateFormat: MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, ExpressibleByStringInterpolation, Equatable, Hashable, Codable {
	public typealias FormatInput = Date
	public typealias FormatOutput = String
	
	public var elements: [Element]
	public var startIndex: Int { elements.startIndex }
	public var endIndex: Int { elements.endIndex }
	
	public var format: String {
		elements.map({ $0.format }).joined()
	}
	
	public var parseStrategy: Strategy {
		Strategy(format)
	}
	
	public init(arrayLiteral elements: Element...) {
		self.elements = elements
	}
	
	public init<T: Collection>(_ elements: T) where T.Element == Element {
		self.elements = Array(elements)
	}
	
	public init(stringInterpolation: StringInterpolation) {
		elements = stringInterpolation.elements
	}
	
	public init(stringLiteral value: String) {
		elements = [Element(value)]
	}
	
	public subscript(position: Int) -> Element {
		get { elements[position] }
		set { elements[position] = newValue }
	}
	
	public func index(after i: Int) -> Int {
		elements.index(after: i)
	}
	
	public func format(_ value: Date) -> String {
		value.string(format)
	}
	
	public func date(from string: String) -> Date? {
		try? parseStrategy.parse(string)
	}
	
	public enum Element: ExpressibleByStringLiteral, Equatable, Hashable, Codable {
		case string(String), component(Calendar.Component, style: Style), custom(String)
		
		public var string: String? {
			if case .string(let string) = self {
				return string
			}
			return nil
		}
		
		public var component: Calendar.Component? {
			if case .component(let component, _) = self {
				return component
			}
			return nil
		}
		
		public var style: Style? {
			if case .component(_, let style) = self {
				return style
			}
			return nil
		}
		
		public enum Style: String, Codable, Hashable {
			case short, full, spellOut, abbreviated, narrow
		}
		
		public var format: String {
			switch self {
			case .string(let string):
				return "'\(string)'"
			case .custom(let format):
				return format
			case .component(let component, let style):
				switch component {
				case .era:
					switch style {
					case .short, .narrow: return "G"
					case .abbreviated: return "GGG"
					case .full, .spellOut: return "GGGG"
					}
				case .year:
					switch style {
					case .short, .narrow: return "yy"
					case .abbreviated: return "y"
					case .full, .spellOut: return "yyyy"
					}
				case .month:
					switch style {
					case .short: return "M"
					case .full: return "MM"
					case .abbreviated: return "MMM"
					case .spellOut: return "MMMM"
					case .narrow: return "MMMMM"
					}
				case .day:
					switch style {
					case .short: return "d"
					default: return "dd"
					}
				case .hour:
					switch style {
					case .short, .narrow: return "h"
					case .full: return "hh"
					case .abbreviated: return "H"
					default: return "HH"
					}
				case .minute:
					switch style {
					case .short, .narrow: return "m"
					default: return "mm"
					}
				case .second:
					switch style {
					case .short: return "s"
					default: return "ss"
					}
				case .weekday, .weekdayOrdinal:
					switch style {
					case .short: return "E"
					case .full, .spellOut: return "EEEE"
					case .abbreviated: return "E"
					case .narrow: return "EEEEE"
					}
				case .quarter:
					switch style {
					case .short: return "Q"
					case .full, .abbreviated, .narrow: return "QQQ"
					case .spellOut: return "QQQQ"
					}
				case .weekOfMonth: return "W"
				case .weekOfYear: return "w"
				case .yearForWeekOfYear:
					switch style {
					case .short, .narrow: return "YY"
					case .abbreviated: return "Y"
					case .full, .spellOut: return "YYYY"
					}
				case .nanosecond:
					switch style {
					case .short, .narrow: return "SSS"
					case .full, .spellOut, .abbreviated: return "SSSS"
					}
				case .timeZone, .calendar:
					switch style {
					case .short: return "Z"
					case .full: return "zzzz"
					case .abbreviated: return "ZZZZZ"
					case .spellOut: return "zzzz"
					case .narrow: return "zzz"
					}
				@unknown default: return ""
				}
			}
		}
		
		public init(_ component: Calendar.Component, style:Style) {
			self = .component(component, style: style)
		}
		
		public init(_ string: String) {
			self = .string(string)
		}
		
		public init(stringLiteral value: String.StringLiteralType) {
			self = Element(value)
		}
		
		//		public func format(_ value: Int) -> String {
		//			guard let component = component else {
		//				return string ?? "\(value)"
		//			}
		//			guard let date = Date(components: [component: value]) else {
		//
		//			}
		//			let formatter = DateComponentsFormatter()
		//			formatter.allowedUnits = [.weekOfYear]
		//		formatter.unitsStyle.rawValue
		//			formatter.
		//			formatter.string(from: [component: value])
		//			return date.string(format)
		//		}
	}
	
	public struct StringInterpolation: StringInterpolationProtocol {
		public typealias StringLiteralType = String
		public var elements: [Element]
		
		public init(literalCapacity: Int, interpolationCount: Int) {
			elements = []
			elements.reserveCapacity(literalCapacity + interpolationCount)
		}
		
		public mutating func appendLiteral(_ literal: String) {
			elements.append(Element(literal))
		}
		
		public mutating func appendInterpolation(_ element: Element) {
			elements.append(element)
		}
		
		public mutating func appendInterpolation(_ component: Element, style: DateFormat.Element.Style) {
			elements.append(.component(component, style: style))
		}
	}
	
	public static func ==(_ lhs: DateFormat, _ rhs: DateFormat) -> Bool {
		lhs.count == rhs.count && lhs.elements == rhs.elements
	}
}

extension DateComponentsFormatter.UnitsStyle: Decodable {}
extension DateComponentsFormatter.UnitsStyle: Encodable {}

extension DateFormat {
	
	public struct Strategy {
		public typealias ParseInput = FormatOutput
		public typealias ParseOutput = FormatInput
		
		public var format: String
		
		public init(_ format: String) {
			self.format = format
		}
		
		public func parse(_ value: DateFormat.FormatOutput) throws -> DateFormat.FormatInput {
			if let result = Date(from: value, format: format) {
				return result
			}
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid date format \(format)", underlyingError: nil))
		}
	}
}

extension DateFormat.Element {
	public static var a: DateFormat.Element { .custom("a") }
	public static var G: DateFormat.Element { .init(.era, style: .short) }
	public static var GGG: DateFormat.Element { .init(.era, style: .abbreviated) }
	public static var GGGG: DateFormat.Element { .init(.era, style: .spellOut) }
	public static var yy: DateFormat.Element { .init(.year, style: .short) }
	public static var y: DateFormat.Element { .init(.year, style: .abbreviated) }
	public static var year: DateFormat.Element { .y }
	public static var yyyy: DateFormat.Element { .init(.year, style: .full) }
	public static var M: DateFormat.Element { .init(.month, style: .short) }
	public static var MM: DateFormat.Element { .init(.month, style: .full) }
	public static var MMM: DateFormat.Element { .init(.month, style: .abbreviated) }
	public static var MMMM: DateFormat.Element { .init(.month, style: .spellOut) }
	public static var month: DateFormat.Element { .MMMM }
	public static var MMMMM: DateFormat.Element { .init(.month, style: .narrow) }
	public static var d: DateFormat.Element { .init(.day, style: .short) }
	public static var day: DateFormat.Element { .d }
	public static var dd: DateFormat.Element { .init(.day, style: .full) }
	public static var h: DateFormat.Element { .init(.hour, style: .short) }
	public static var hh: DateFormat.Element { .init(.hour, style: .full) }
	public static var H: DateFormat.Element { .init(.hour, style: .abbreviated) }
	public static var HH: DateFormat.Element { .init(.hour, style: .spellOut) }
	public static var m: DateFormat.Element { .init(.minute, style: .short) }
	public static var mm: DateFormat.Element { .init(.minute, style: .full) }
	public static var s: DateFormat.Element { .init(.second, style: .short) }
	public static var ss: DateFormat.Element { .init(.second, style: .full) }
	public static var E: DateFormat.Element { .init(.weekday, style: .short) }
	public static var EEEE: DateFormat.Element { .init(.weekday, style: .full) }
	public static var EEEEE: DateFormat.Element { .init(.weekday, style: .narrow) }
	public static var Q: DateFormat.Element { .init(.quarter, style: .short) }
	public static var QQQ: DateFormat.Element { .init(.quarter, style: .full) }
	public static var QQQQ: DateFormat.Element { .init(.quarter, style: .spellOut) }
	public static var W: DateFormat.Element { .init(.weekOfMonth, style: .short) }
	public static var w: DateFormat.Element { .init(.weekOfYear, style: .short) }
	public static var YY: DateFormat.Element { .init(.yearForWeekOfYear, style: .short) }
	public static var Y: DateFormat.Element { .init(.yearForWeekOfYear, style: .abbreviated) }
	public static var YYYY: DateFormat.Element { .init(.yearForWeekOfYear, style: .full) }
	public static var SSS: DateFormat.Element { .init(.nanosecond, style: .short) }
	public static var SSSS: DateFormat.Element { .init(.nanosecond, style: .full) }
	public static var Z: DateFormat.Element { .init(.timeZone, style: .short) }
	public static var zzzz: DateFormat.Element { .init(.timeZone, style: .full) }
	public static var ZZZZZ: DateFormat.Element { .init(.timeZone, style: .abbreviated) }
	public static var zzz: DateFormat.Element { .init(.timeZone, style: .narrow) }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension DateFormat.Strategy: ParseStrategy {}

/// A type that can convert a given data type into a representation.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension DateFormat: FormatStyle, ParseableFormatStyle {}

///// A type that can convert a given data type into a representation.
//@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//extension DateFormat.Element: FormatStyle {
//	public typealias FormatInput = Int
//	public typealias FormatOutput = String
//}
