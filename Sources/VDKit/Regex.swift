//
//  File.swift
//  
//
//  Created by Данил Войдилов on 31.05.2021.
//

import Foundation

@dynamicMemberLookup
public struct Regex: ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
	public var symbol: String
	public var description: String { symbol }
	
	public static subscript(_ regex: SymbolsSet...) -> Regex {
		Regex(regex)
	}
	
	public init() {
		symbol = ""
	}
	
	public init(_ symbol: String) {
		self.symbol = symbol
	}
	
	public init(stringLiteral value: String) {
		symbol = value
	}
	
	public init(arrayLiteral elements: SymbolsSet...) {
		self.init(elements)
	}
	
	public init(_ elements: [SymbolsSet]) {
		symbol = "[\(elements.map({ $0.regex }).joined())]"
	}
	
	public var any: Regex { Regex(".") }
	public var digit: Regex { Regex("\\d") }
	public var notDigit: Regex { Regex("\\D") }
	public var space: Regex { Regex("\\s") }
	public var notSpace: Regex { Regex("\\S") }
	public var wordChar: Regex { Regex("\\w") }
	public var notWordChar: Regex { Regex("\\W") }
	public var nextLine: Regex { Regex("\\n") }
	public var carriageReturn: Regex { Regex("\\r") }
	public var wordEdge: Regex { Regex("\\b") }
	public var notWordEdge: Regex { Regex("\\B") }
	public var previous: Regex { Regex("\\G") }
	public var textBegin: Regex { Regex("^") }
	public var textEnd: Regex { Regex("$") }
	
	public var repeats: Regex { Regex("*") }
	
	public func repeats(_ count: Int) -> Regex {
		Regex(symbol + "{\(count)}")
	}
	
	public func repeats(_ range: ClosedRange<Int>) -> Regex {
		Regex(symbol + "{\(range.lowerBound),\(range.upperBound)}")
	}
	
	public func repeats(_ range: PartialRangeFrom<Int>) -> Regex {
		Regex(symbol + "{\(range.lowerBound),}")
	}
	
	public func repeats(_ range: PartialRangeThrough<Int>) -> Regex {
		Regex(symbol + "{,\(range.upperBound)}")
	}
	
	//1-9
	public func found(_ number: Int) -> Regex {
		Regex(symbol + "\\\(number)")
	}
	
	public func look(_ look: Look, _ regex: Regex) -> Regex {
		Regex("(\(look.rawValue)\(regex))")
	}
	
	public func look(_ look: Look, @RegexBuilder _ builder: () -> Regex) -> Regex {
		self.look(look, builder())
	}
	
	public func string(_ string: String) -> Regex {
		Regex(symbol + (string.count > 1 ? "\\Q\(string)\\E" : string.regexShielding))
	}
	
	public static func +(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex(lhs.symbol + rhs.symbol)
	}
	
	public static func |(_ lhs: Regex, _ rhs: Regex) -> Regex {
		Regex("\(lhs.symbol)|\(rhs.symbol)")
	}
	
	public subscript(_ regex: SymbolsSet...) -> Regex {
		Regex(symbol + Regex(regex).symbol)
	}
	
	public subscript(dynamicMember string: String) -> Regex {
		Regex(symbol + (string.count > 1 ? "(\(string))" : string))
	}
	
	public func callAsFunction(_ input: Regex) -> Regex {
		Regex(symbol + "(\(input.symbol)")
	}
	
	public func callAsFunction(_ input: () -> Int) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> ClosedRange<Int>) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> PartialRangeFrom<Int>) -> Regex {
		repeats(input())
	}
	
	public func callAsFunction(_ input: () -> PartialRangeThrough<Int>) -> Regex {
		repeats(input())
	}
	
	func reg() {
		_ = Regex().gr("a"|"e").y+.r
		_ = Regex().gr["a","b"].ydfd{0...}.any+
		_ = Regex().gr["a","b"].ydfd{0}.any+
		
		let regex: Regex = "\(Regex["A"-"Z",0-9,"a"-"z","._%+-"])@\(Regex["A"-"Z",0-9,"a"-"z","."]).\(Regex["A"-"Z","a"-"z"].repeats(2...64))"
		
		Regex["A"-"Z",0-9,"a"-"z","._%+-"]
			.string("@")["A"-"Z",0-9,"a"-"z","."]
			.string(".")["A"-"Z","a"-"z"]
			.repeats(2...64)
			.found(1)(.any)(.any)
		Regex {
			["A"-"Z", 0-9, "a"-"z", "._%+-"]+
			"@"
			["A"-"Z", 0-9, "a"-"z", "."]+
			"."
			Regex["A"-"Z", "a"-"z"].repeats
			{2...64}
			"\(?<="sample")fuck"
		}
		
		let str = "string"
		switch str {
		case Regex[""]: break
		default: break
		}
	}
	
	public struct SymbolsSet: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
		public var regex: String
		
		public init(stringLiteral value: StringLiteralType) {
			regex = value
		}
		
		public init(arrayLiteral elements: SymbolsSet...) {
			self = SymbolsSet(elements)
		}
		
		public init(_ elements: [SymbolsSet]) {
			regex = elements.map { $0.regex }.joined()
		}
		
		public init(_ string: String) {
			regex = string
		}
		
		public init(integerLiteral value: Int) {
			regex = "\(value)"
		}
		
		public static func -(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			SymbolsSet("\(lhs.regex)-\(rhs.regex)")
		}
		
		public static func ...(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			lhs - rhs
		}
		
		public static func +(_ lhs: SymbolsSet, _ rhs: SymbolsSet) -> SymbolsSet {
			SymbolsSet(lhs.regex + rhs.regex)
		}
	}
}

extension Regex {
	public static var any: Regex { Regex().any }
	public static var digit: Regex { Regex().digit }
	public static var notDigit: Regex { Regex().notDigit }
	public static var space: Regex { Regex().space }
	public static var notSpace: Regex { Regex().notSpace }
	public static var wordChar: Regex { Regex().wordChar }
	public static var notWordChar: Regex { Regex().notWordChar }
	public static var nextLine: Regex { Regex().nextLine }
	public static var carriageReturn: Regex { Regex().carriageReturn }
	public static var wordEdge: Regex { Regex().wordEdge }
	public static var notWordEdge: Regex { Regex().notWordEdge }
	public static var previous: Regex { Regex().previous }
	public static var textBegin: Regex { Regex().textBegin }
	public static var textEnd: Regex { Regex().textEnd }
	public static func string(_ string: String) -> Regex { Regex().string(string) }
	
	public static func group(_ regex: Regex) -> Regex { Regex()(regex) }
	public static func group(@RegexBuilder _ builder: () -> Regex) -> Regex { .group(builder()) }
	
	public static func atomGroup(_ regex: Regex) -> Regex { Regex("(?>\(regex.symbol))") }
	public static func atomGroup(@RegexBuilder _ builder: () -> Regex) -> Regex { .atomGroup(builder()) }
	
//	public static func group(_ regex: Regex) -> Regex { Regex()(regex) }
//	public static func group(@RegexBuilder _ builder: () -> Regex) -> Regex { .group(builder()) }
	
	public static func any(@ArrayBuilder<SymbolsSet> _ builder: () -> [SymbolsSet]) -> Regex { Regex(builder()) }
	
	public static var email: Regex { Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}") }
}

extension Regex {
	public enum Look: String {
		case behind = "?<=", ahead = "?="
		case behindNot = "?<!", aheadNot = "?!"
	}
}

prefix operator ^
postfix operator +
postfix operator *
postfix operator *?
postfix operator +?
postfix operator *+
postfix operator ++

prefix operator ?=
prefix operator ?!
prefix operator ?<=
prefix operator ?<!

public postfix func +(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "+")
}

public postfix func *(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "*")
}

public postfix func *?(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "*?")
}

public postfix func +?(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "+?")
}

public postfix func *+(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "*+")
}

public postfix func ++(_ lhs: Regex) -> Regex {
	Regex(lhs.symbol + "++")
}

public prefix func ^(_ rhs: Regex) -> Regex {
	Regex("^" + rhs.symbol)
}

public prefix func ^(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	"^" + rhs
}

public prefix func !(_ rhs: Regex.SymbolsSet) -> Regex.SymbolsSet {
	^rhs
}

public prefix func ?=(_ rhs: Regex) -> Regex {
	Regex("(?=\(rhs.symbol))")
}

public prefix func ?!(_ rhs: Regex) -> Regex {
	Regex("(?!\(rhs.symbol))")
}

public prefix func ?<=(_ rhs: Regex) -> Regex {
	Regex("(?<=\(rhs.symbol))")
}

public prefix func ?<!(_ rhs: Regex) -> Regex {
	Regex("(?<!\(rhs.symbol))")
}

extension Regex {
	public var ns: NSRegularExpression? {
		try? NSRegularExpression(pattern: symbol)
	}
}

extension CharacterSet {
	
	public static var regexSpecial: CharacterSet {
		CharacterSet(charactersIn: "[]\\/^$.|?*+(){}")
	}
}

extension StringProtocol {
	
	public func match(_ regex: Regex) -> Bool {
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex.symbol)
		return emailPredicate.evaluate(with: String(self))
	}
	
	public func replace(_ regex: Regex, with template: String) -> String {
		regex.ns?.stringByReplacingMatches(in: String(self), options: [], range: NSRange(location: 0, length: count), withTemplate: template) ?? String(self)
	}
}

public func ~=<T: StringProtocol>(lhs: Regex, rhs: T) -> Bool {
	rhs.match(lhs)
}

private extension String {
	var regexShielding: String {
		map { CharacterSet.regexSpecial.contains($0) ? "\\\($0)" : String($0) }.joined()
			.replacingOccurrences(of: "\n", with: "\\n")
	}
}

extension Regex: ArrayInitable {
	
	public static func create(from: [Regex]) -> Regex {
		Regex(from.reduce("", { $0 + $1.symbol }))
	}
}

public typealias RegexBuilder = ComposeBuilder<Regex>

extension Regex {
	public init(@RegexBuilder _ builder: () -> Regex) {
		self = builder()
	}
}

extension ComposeBuilder where C == Regex {
	public static func buildExpression(_ expression: Regex) -> Regex {
		expression
	}
	
	public static func buildExpression(_ expression: [Regex.SymbolsSet]) -> Regex {
		Regex(expression)
	}
	
	public static func buildExpression(_ string: String) -> Regex {
		.string(string)
	}
	
	public static func buildExpression(_ regexes: () -> Int) -> Regex {
		Regex().repeats(regexes())
	}
	
	public static func buildExpression(_ regexes: () -> ClosedRange<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	public static func buildExpression(_ regexes: () -> PartialRangeFrom<Int>) -> Regex {
		Regex().repeats(regexes())
	}
	
	public static func buildExpression(_ regexes: () -> PartialRangeThrough<Int>) -> Regex {
		Regex().repeats(regexes())
	}
}
