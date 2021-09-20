//
//  File.swift
//  
//
//  Created by Данил Войдилов on 16.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct AnyTypeKey<T>: EnvironmentKey {
    static var defaultValue: [KeyPath<EnvironmentValues, T>: T] { [:] }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    public subscript<T>(_ keyPath: KeyPath<EnvironmentValues, T>) -> T? {
        get {
            self[AnyTypeKey<T>.self][keyPath]
        }
        set {
            self[AnyTypeKey<T>.self][keyPath] = newValue
        }
    }
}
