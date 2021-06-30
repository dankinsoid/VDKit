//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.06.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public struct EnvironmentViewBuilder<Body: View, Value> {
	var body: Body
	var keyPath: WritableKeyPath<EnvironmentValues, Value>
	
	public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> EnvironmentViewBuilder<Body, T> {
		EnvironmentViewBuilder<Body, T>(body: body, keyPath: self.keyPath.appending(path: keyPath))
	}
	
	public func callAsFunction(_ value: Value) -> EnvironmentView<Body, Value> {
		EnvironmentView(content: body, keyPath: keyPath, value: value)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@dynamicMemberLookup
public struct EnvironmentView<Content: View, Value>: View {
	var content: Content
	var keyPath: WritableKeyPath<EnvironmentValues, Value>
	var value: Value
	
	public var body: some View {
		content.environment(keyPath, value)
	}
	
	public subscript<T>(dynamicMember keyPath: WritableKeyPath<EnvironmentValues, T>) -> EnvironmentViewBuilder<Self, T> {
		EnvironmentViewBuilder<Self, T>(body: self, keyPath: keyPath)
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
	public var environment: EnvironmentViewBuilder<Self, EnvironmentValues> {
		EnvironmentViewBuilder(body: self, keyPath: \.self)
	}
}
