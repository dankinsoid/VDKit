import Foundation

postfix operator ~!

public postfix func ~!<T>(_ lhs: T?) throws -> T {
    guard let value = lhs else { throw OptionalException.noValue }
    return value
}

public protocol OptionalProtocol {
    associatedtype Wrapped
    init(_ optional: Wrapped?)
    func asOptional() -> Wrapped?
    func unwrap(throw error: Error) throws -> Wrapped
}

extension Optional: OptionalProtocol {
    
    public init(_ optional: Wrapped?) {
        self = optional
    }
    
    public func unwrap(throw error: Error = OptionalException.noValue) throws -> Wrapped {
        guard let value = self else { throw error }
        return value
    }
    
    public func asOptional() -> Wrapped? {
        return self
    }
    
}

public enum OptionalException: String, LocalizedError {
    case noValue
}
