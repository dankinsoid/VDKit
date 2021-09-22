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

/// A property wrapper that uses `UserDefaults` as a backing store,
/// whose `wrappedValue` is non-optional and registers a **non-optional default value**.
@propertyWrapper
public struct WrappedDefault<T: Codable> {
    public let userDefaults: UserDefaults

    /// The key for the value in `UserDefaults`.
    public let key: String
    public let defaultValue: T

    /// The value retreived from `UserDefaults`.
    public var wrappedValue: T {
        get {
            userDefaults.fetch(key) ?? defaultValue
        }
        set {
            userDefaults.save(newValue, for: key)
        }
    }
    
    public var projctedValue: WrappedDefault<T> { self }
    
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
    
    public func synchronize() {
        userDefaults.synchronize()
    }

    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - wrappedValue: The default value to register for the specified key.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(wrappedValue: T, _ keyName: String, suiteName: String?) {
        self = WrappedDefault(wrappedValue: wrappedValue, keyName, userDefaults: UserDefaults(suiteName: suiteName) ?? .standard)
    }
    
    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - wrappedValue: The default value to register for the specified key.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(wrappedValue: T, _ keyName: String, userDefaults: UserDefaults = .standard) {
        self.key = keyName
        self.userDefaults = userDefaults
        self.defaultValue = wrappedValue
    }
}

extension WrappedDefault where T: OptionalProtocol {
    
    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(_ keyName: String, suiteName: String?) {
        self = WrappedDefault(wrappedValue: .none, keyName, userDefaults: UserDefaults(suiteName: suiteName) ?? .standard)
    }
    
    /// Initializes the property wrapper.
    /// - Parameters:
    ///   - keyName: The key for the value in `UserDefaults`.
    ///   - userDefaults: The `UserDefaults` backing store. The default value is `.standard`.
    public init(_ keyName: String, userDefaults: UserDefaults = .standard) {
        self = WrappedDefault(wrappedValue: .none, keyName, userDefaults: userDefaults)
    }
}
