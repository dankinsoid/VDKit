//
//  File.swift
//  
//
//  Created by Данил Войдилов on 15.08.2021.
//

import SwiftUI
import VDBuilders

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias AnyViewsBuilder = ArrayBuilder<AnyView>


@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ArrayBuilder where T == AnyView {
    
    @inlinable
    public static func buildExpression<V: View>(_ expression: V) -> [T] {
        [AnyView(expression)]
    }
}
