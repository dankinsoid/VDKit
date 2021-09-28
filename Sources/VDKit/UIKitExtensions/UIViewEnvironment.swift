//
//  UIViewEnvironment.swift
//  TodoList
//
//  Created by Данил Войдилов on 29.06.2021.
//  Copyright © 2021 Magic Solutions. All rights reserved.
//

import UIKit

extension UIView {
    
	public var environments: ObjectEnvironment<UIView> {
        ObjectEnvironment.environments(
            self,
            create: UIView.init,
            parent: { $0.superview },
            children: { $0.subviews }
        ) { base, action in
            _ = try? base.onMethodInvoked(#selector(UIView.didMoveToWindow)) { _ in
                action()
            }
        }
	}
}

extension UIViewController {
    
    public var environments: ObjectEnvironment<UIViewController> {
        ObjectEnvironment.environments(
            self,
            create: UIViewController.init,
            parent: { $0.parent },
            children: { $0.children }
        ) { base, action in
            _ = try? base.onMethodInvoked(#selector(UIViewController.didMove(toParent:))) { _ in
                action()
            }
        }
    }
}

@dynamicMemberLookup
public final class ObjectEnvironment<Base: AnyObject> {
	private var values: [PartialKeyPath<ObjectEnvironment>: Any] = [:]
	private var keyPaths: Set<AnyKeyPath> = []
    private var create: () -> Base
    private var parent: (Base) -> Base?
    private var children: (Base) -> [Base]
    private var observe: (Base, @escaping () -> Void) -> Void
    private(set) public weak var base: Base?
    private var _base: Base { base ?? create() }
    private var _parent: Base { base.flatMap(parent) ?? create() }
    private var environmentObservers = Observers()
	
    public init(_ base: Base, create: @escaping () -> Base, parent: @escaping (Base) -> Base?, children: @escaping (Base) -> [Base], observe: @escaping (Base, @escaping () -> Void) -> Void) {
        self.create = create
        self.parent = parent
        self.children = children
        self.observe = observe
        self.base = base
    }
    
	public subscript<T>(_ keyPath: KeyPath<ObjectEnvironment, T>) -> T? {
		get {
			if let any = values[keyPath], type(of: any) == T.self {
				return any as? T
			}
            return base.flatMap(parent).map(environments)?[keyPath]
		}
		set {
            guard let newValue = newValue else { return }
			values[keyPath] = newValue
			send(keyPath: keyPath, value: newValue)
		}
	}
	
	public subscript<T>(dynamicMember keyPath: KeyPath<Base, T>) -> Path<T> {
        Path(keyPath: keyPath, environment: self)
	}
	
	public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, T>) -> T {
		get {
			if keyPaths.contains(keyPath) {
				return _base[keyPath: keyPath]
			} else {
                return environments(_parent)[dynamicMember: keyPath]
			}
		}
		set {
			set(keyPath: keyPath, value: newValue)
			keyPaths.insert(keyPath)
		}
	}
	
	@discardableResult
	public func observe<T>(_ keyPath: KeyPath<ObjectEnvironment, T>, observer: @escaping (T) -> Void) -> () -> Void {
		observer(self[keyPath: keyPath])
		observeMovedToSuperviewIfCan {
			observer(self[keyPath: keyPath])
		}
		return environmentObservers.add(for: keyPath, observer)
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<ObjectEnvironment, T>, to: ReferenceWritableKeyPath<Base, T>) -> () -> Void {
		observe(keyPath) { [weak base] in
            base?[keyPath: to] = $0
		}
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<ObjectEnvironment, T>, to: ReferenceWritableKeyPath<Base, T?>) -> () -> Void {
		observe(keyPath) { [weak base] in
            base?[keyPath: to] = $0
		}
	}
	
	@discardableResult
	public func bind<T>(_ keyPath: KeyPath<ObjectEnvironment, T?>, to: ReferenceWritableKeyPath<Base, T>) -> () -> Void {
		observe(keyPath) { [weak base] in
			guard let value = $0 else { return }
            base?[keyPath: to] = value
		}
	}
	
	private func send<T>(keyPath: KeyPath<ObjectEnvironment, T>, value: T) {
		environmentObservers.send(value, for: keyPath)
        children(_base).forEach {
            environments($0).sendRecursive(keyPath: keyPath, value: value)
		}
	}
	
	private func sendRecursive<T>(keyPath: KeyPath<ObjectEnvironment, T>, value: T) {
		guard values[keyPath] == nil else { return }
		send(keyPath: keyPath, value: value)
	}
	
	private func observeMovedToSuperviewIfCan(_ action: @escaping () -> Void) {
		observe(_base, action)
	}
    
    private func environments(_ base: Base) -> ObjectEnvironment {
        .environments(base, create: create, parent: parent, children: children, observe: observe)
    }
    
    private class Observers {
        private var observers: [AnyKeyPath: [UUID: (Any) -> Void]] = [:]
        
        func add<T>(for keyPath: KeyPath<ObjectEnvironment, T>, _ observer: @escaping (T) -> Void) -> () -> Void {
            let id = UUID()
            observers[keyPath, default: [:]][id] = {
                guard let value = $0 as? T else { return }
                observer(value)
            }
            return { self.observers[keyPath]?[id] = nil }
        }
        
        func send<T>(_ value: T, for keyPath: KeyPath<ObjectEnvironment, T>) {
            observers[keyPath]?.forEach {
                $0.value(value)
            }
        }
    }
    
    @dynamicMemberLookup
    public struct Path<Value> {
        public let keyPath: KeyPath<Base, Value>
        public let environment: ObjectEnvironment
        
        public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> Path<T> {
            Path<T>(keyPath: self.keyPath.appending(path: keyPath), environment: environment)
        }
        
        public subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, T>) -> T {
            get { environment[dynamicMember: self.keyPath.appending(path: keyPath)] }
            nonmutating set { environment[dynamicMember: self.keyPath.appending(path: keyPath)] = newValue }
        }
    }
    
    public subscript<V, T>(_ keyPath: ReferenceWritableKeyPath<V, T>) -> T? {
        get {
            if keyPaths.contains(keyPath) {
                return (base as? V)?[keyPath: keyPath]
            } else {
                return base.flatMap(parent).map(environments)?[keyPath]
            }
        }
        set {
            guard let value = newValue else { return }
            set(keyPath: keyPath, value: value)
            keyPaths.insert(keyPath)
        }
    }
    
    private func set<V, T>(keyPath: ReferenceWritableKeyPath<V, T>, value: T) {
        (base as? V)?[keyPath: keyPath] = value
        children(_base).forEach {
            environments($0).setRecursive(keyPath: keyPath, value: value)
        }
    }
    
    private func setRecursive<V, T>(keyPath: ReferenceWritableKeyPath<V, T>, value: T) {
        guard !keyPaths.contains(keyPath) else { return }
        set(keyPath: keyPath, value: value)
    }
}

extension ObjectEnvironment {
    
    public static func environments(_ base: Base, create: @escaping () -> Base, parent: @escaping (Base) -> Base?, children: @escaping (Base) -> [Base], observe: @escaping (Base, @escaping () -> Void) -> Void) -> ObjectEnvironment {
        if let result = (objc_getAssociatedObject(self, &environmentsKey) as? ObjectEnvironmentOwner)?.environment as? ObjectEnvironment {
            return result
        }
        let result = ObjectEnvironment(base, create: create, parent: parent, children: children, observe: observe)
        objc_setAssociatedObject(self, &environmentsKey, ObjectEnvironmentOwner(result), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return result
    }
}

private final class ObjectEnvironmentOwner {
    var environment: Any
    
    init(_ environment: Any) {
        self.environment = environment
    }
    
}

private var environmentsKey = "environmentsKey"
