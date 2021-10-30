//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/Foil
//
//  GitHub
//  https://github.com/jessesquires/Foil
//
//  Copyright © 2021-present Jesse Squires
//

import Foundation
import CoreText

/// Describes a value that can be saved to and fetched from `UserDefaults`.
///
/// Default conformances are provided for:
///    - `Bool`
///    - `Int`
///    - `UInt`
///    - `Float`
///    - `Double`
///    - `String`
///    - `URL`
///    - `Date`
///    - `Data`
///    - `Array`
///    - `Set`
///    - `Dictionary`
///    - `RawRepresentable` types
protocol UserDefaultsSerializable {
    
    /// The value to store in `UserDefaults`.
    var storedValue: Any? { get }

    /// Initializes the object using the provided value.
    ///
    /// - Parameter storedValue: The previously store value fetched from `UserDefaults`.
    init?(storedValue: Any?)
}

/// :nodoc:
extension Bool: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension Int: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension UInt: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension Float: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension Double: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension String: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}
/// :nodoc:
extension Date: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension Data: UserDefaultsSerializable {
    var storedValue: Any? { self }

    init?(storedValue: Any?) {
        guard let value = storedValue as? Self else { return nil }
        self = value
    }
}

/// :nodoc:
extension Array: UserDefaultsSerializable where Element: UserDefaultsSerializable {
    var storedValue: Any? {
        self.map { $0.storedValue }
    }

    init?(storedValue: Any?) {
        guard let value = storedValue as? [Any] else { return nil }
        self = value.compactMap { Element(storedValue: $0) }
    }
}

/// :nodoc:
extension Set: UserDefaultsSerializable where Element: UserDefaultsSerializable {
    var storedValue: Any? {
        self.map { $0.storedValue }
    }

    init?(storedValue: Any?) {
        guard let value = storedValue as? [Any] else { return nil }
        self = Set(value.compactMap { Element(storedValue: $0) })
    }
}

/// :nodoc:
extension Dictionary: UserDefaultsSerializable where Key == String, Value: UserDefaultsSerializable {
    var storedValue: Any? {
        self.mapValues { $0.storedValue }
    }

    init?(storedValue: Any?) {
        guard let value = storedValue as? [String: Any] else { return nil }
        self = value.compactMapValues { Value(storedValue: $0) }
    }
}

/// :nodoc:
extension UserDefaultsSerializable where Self: RawRepresentable, Self.RawValue: UserDefaultsSerializable {
    var storedValue: Any? { self.rawValue.storedValue }

    init?(storedValue: Any?) {
        guard let value = RawValue(storedValue: storedValue) else { return nil }
        self.init(rawValue: value)
    }
}

extension Optional: UserDefaultsSerializable where Wrapped: UserDefaultsSerializable {
    var storedValue: Any? { this }
    
    private var this: Wrapped? { self }
    
    init?(storedValue: Any?) {
        guard let value = storedValue as? Optional<Wrapped> else { return nil }
        self = value
    }
}
