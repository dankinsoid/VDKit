//
// Created by Данил Войдилов on 04.10.2021.
//

import Foundation
import SwiftUI
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//@propertyWrapper
//public struct EnvironmentModel<Model: ObservableObject>: DynamicProperty {
//
//    @ObservedObject private var object: Object
//    @Environment(\.environmentModel) private var environment
//    public var wrappedValue: Model {
//        object.model
//    }
//    public var projectedValue: Binding<Model> {
//        .constant(wrappedValue)
//    }
//    
//    public init(wrappedValue: @escaping @autoclosure () -> Model) {
//        
//    }
//
//    private final class Object: ObservableObject {
//        let model: Model
//        var objectWillChange: Model.ObjectWillChangePublisher { model.objectWillChange }
//        
//        init() {}
//    }
//}
//
//@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
//extension EnvironmentValues {
//    fileprivate var environmentModel: Any? {
//        get { self[\.environmentModel] ?? nil }
//        set { self[\.environmentModel] = newValue }
//    }
//}
