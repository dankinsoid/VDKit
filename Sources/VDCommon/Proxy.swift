//
//  File.swift
//  
//
//  Created by Данил Войдилов on 28.09.2021.
//

import Foundation

@propertyWrapper
public struct Proxy<EnclosingType: AnyObject, Value> {
    public typealias ValueKeyPath = ReferenceWritableKeyPath<EnclosingType, Value>
    public typealias SelfKeyPath = ReferenceWritableKeyPath<EnclosingType, Self>
    
    public static subscript(
        _enclosingInstance observed: EnclosingType,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingType, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingType, Self>
    ) -> Value {
        get {
            let keyPath = observed[keyPath: storageKeyPath].keyPath
            return observed[keyPath: keyPath]
        }
        set {
            let keyPath = observed[keyPath: storageKeyPath].keyPath
            observed[keyPath: keyPath] = newValue
        }
    }
    
    @available(*, unavailable, message: "@Proxy can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set {}
    }
    
    private let keyPath: ValueKeyPath
    
    public init(_ keyPath: ValueKeyPath) {
        self.keyPath = keyPath
    }
}
