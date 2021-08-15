//
//  File.swift
//  
//
//  Created by Данил Войдилов on 14.08.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension ViewBuilder {
    
    public static func buildArray<C: View>(_ components: [C]) -> some View {
        ForEach(components.indices, id: \.self) {
            components[$0]
        }
    }
}
