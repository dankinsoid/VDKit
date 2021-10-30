//
//  File.swift
//  
//
//  Created by Данил Войдилов on 22.08.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public enum StateOrBinding<Value>: DynamicProperty {
    
    case binding(Binding<Value>), state(State<Value>)
    
    public var wrappedValue: Value {
        get {
            switch self {
            case .binding(let binding): return binding.wrappedValue
            case .state(let state): return state.wrappedValue
            }
        }
        nonmutating set {
            switch self {
            case .binding(let binding): binding.wrappedValue = newValue
            case .state(let state): state.wrappedValue = newValue
            }
        }
    }
    
    public var projectedValue: Binding<Value> {
        switch self {
        case .binding(let binding): return binding
        case .state(let state): return state.projectedValue
        }
    }
    
    public init(wrappedValue: Value) {
        self = .state(.init(wrappedValue: wrappedValue))
    }
    
    public static func state(_ wrappedValue: Value) -> StateOrBinding {
        .state(.init(wrappedValue: wrappedValue))
    }
}
