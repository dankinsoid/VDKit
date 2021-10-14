//
// Created by Данил Войдилов on 04.10.2021.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct EnvironmentStateObject<Model: ObservableObject>: DynamicProperty {

    @StateObject private var object = Object()
    @State private var updater = false
    @Environment(\.environmentModel) private var environment
    private let defaultValue: () -> Model
    private let id: AnyHashable
    
    public var wrappedValue: Model {
        get {
            createModel()
            return object.model
        }
        nonmutating set {
            object.model = newValue
            updater.toggle()
        }
    }
    
    public var projectedValue: Binding<Model> {
        Binding {
            self.wrappedValue
        } set: {
            self.wrappedValue = $0
        }
    }
    
    public init(wrappedValue: @escaping @autoclosure () -> Model) {
        defaultValue = wrappedValue
        id = String(reflecting: Model.self)
    }
    
    public init<ID: Hashable>(wrappedValue: @escaping @autoclosure () -> Model, _ id: ID) {
        defaultValue = wrappedValue
        self.id = id
    }

    @inline(__always) private func createModel() {
        guard object.model == nil else { return }
        object.model = (environment[id] as? () -> Model)?() ?? defaultValue()
    }
    
    private final class Object: ObservableObject {
        var model: Model! {
            didSet {
                bag = []
                model.objectWillChange.subscribe(objectWillChange).store(in: &bag)
            }
        }
        var bag: Set<AnyCancellable> = []
        let objectWillChange = PassthroughSubject<Model.ObjectWillChangePublisher.Output, Model.ObjectWillChangePublisher.Failure>()
        
        init() {}
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    public func environmentStateObject<M: ObservableObject>(_ model: @escaping @autoclosure () -> M) -> some View {
        modifier(EnvironmentModelModifier(model: model, key: String(reflecting: M.self)))
    }
    
    public func environmentStateObject<M: ObservableObject, ID: Hashable>(id: ID, _ model: @escaping @autoclosure () -> M) -> some View {
        modifier(EnvironmentModelModifier(model: model, key: id))
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct EnvironmentModelModifier<Model>: ViewModifier {
    @State private var object = Object()
    private let create: () -> Model
    let key: AnyHashable
    
    var model: Model {
        createModel()
        return object.model
    }
    
    init(model: @escaping () -> Model, key: AnyHashable) {
        create = model
        self.key = key
    }

    @inline(__always) private func createModel() {
        guard object.model == nil else { return }
        object.model = create()
    }
    
    func body(content: Content) -> some View {
        let value: () -> Model = { self.model }
        return content.environment(\.environmentModel[key], value)
    }
    
    private final class Object {
        var model: Model!
        
        init() {}
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    fileprivate var environmentModel: [AnyHashable: Any] {
        get { self[\.environmentModel] ?? [:] }
        set { self[\.environmentModel] = newValue }
    }
}
