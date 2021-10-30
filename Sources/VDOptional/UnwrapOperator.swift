import Foundation

postfix operator ~!
infix operator !!

public postfix func ~!<T>(_ lhs: T?) throws -> T {
	guard let value = lhs else { throw OptionalException.nil }
	return value
}

public func !!<T>(_ lhs: T?, _ rhs: Error) throws -> T {
	guard let value = lhs else { throw rhs }
	return value
}

public protocol OptionalProtocol {
	associatedtype Wrapped
	static var none: Self { get }
	init(_ optional: Wrapped?)
	func asOptional() -> Wrapped?
	func unwrap(throw error: Error) throws -> Wrapped
}

extension Optional: OptionalProtocol {
    
	public init(_ optional: Wrapped?) {
		self = optional
	}
	
	public func unwrap(throw error: Error) throws -> Wrapped {
		guard let value = self else { throw error }
		return value
	}
	
	public func unwrap(file: String = #file, line: Int = #line, column: Int = #column) throws -> Wrapped {
		try unwrap(throw: OptionalException.nilAt(file: file, line: line, column: column))
	}
	
	public func asOptional() -> Wrapped? {
		return self
	}
}

public enum OptionalException: LocalizedError {
	case nilAt(file: String, line: Int, column: Int), `nil`
	
	public var errorDescription: String? {
		switch self {
		case .nil:
			return "unexpectedly found nil while unwrapping"
		case .nilAt(let file, let line, let column):
			return "unexpectedly found nil while unwrapping at file: \"\(file)\" line: \(line) column: \(column)"
		}
	}
}

extension OptionalProtocol {
	
	public var or: Optional<Wrapped>.Or {
		get { .init(optional: asOptional()) }
		set { self = .init(newValue.optional) }
	}
}

extension Optional {
	
	public struct Or {
		let optional: Optional
		
		public subscript(_ value: Wrapped) -> Wrapped {
			get { optional ?? value }
			set { self = Or(optional: newValue) }
		}
	}
}

public func ??<Root, Value: Hashable>(_ lhs: KeyPath<Root, Value?>, _ rhs: Value) -> KeyPath<Root, Value> {
	lhs.appending(path: \.or[rhs])
}

public func ??<Root, Value: Hashable>(_ lhs: WritableKeyPath<Root, Value?>, _ rhs: Value) -> WritableKeyPath<Root, Value> {
	lhs.appending(path: \.or[rhs])
}
