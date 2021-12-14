//
//  File.swift
//  
//
//  Created by Данил Войдилов on 26.10.2021.
//

import SwiftUI
import Combine
import VDOptional

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias ValueStateSubject<Value> = StateSubject<PassthroughSubject<Value, Never>>

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct StateSubject<S: Subject>: DynamicProperty, Publisher where S.Failure == Never {
	public typealias Failure = Never
	public typealias Output = S.Output
	
	public var wrappedValue: Output {
		get {
			if object.model == nil {
				object.model = create()
			}
			return object.value ?? defaultValue
		}
		nonmutating set {
			if object.model == nil {
				object.model = create()
			}
			object.model.send(newValue)
		}
	}
	@StateObject private var object = Object()
	private let create: () -> S
	private let defaultValue: Output
	
	public var projectedValue: Binding<Output> {
		Binding {
			self.wrappedValue
		} set: {
			self.wrappedValue = $0
		}
	}
	
	public var subject: S {
		if object.model == nil {
			object.model = create()
		}
		return object.model
	}
	
	public init(wrappedValue: Output, _ publisher: @escaping @autoclosure () -> S) {
		defaultValue = wrappedValue
		create = publisher
	}
	
	public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
		subject.receive(subscriber: subscriber)
	}
	
	private final class Object: ObservableObject {
		var model: S! {
			didSet {
				bag = []
				model.sink(receiveCompletion: { _ in }) {[weak self] in
					self?.value = $0
				}.store(in: &bag)
			}
		}
		@Published var value: Output?
		var bag: Set<AnyCancellable> = []
		
		init() {}
	}
	
	public init<Value>(wrappedValue: Value) where S == PassthroughSubject<Value, Never> {
		self = StateSubject(wrappedValue: wrappedValue, PassthroughSubject())
	}
	
	public init<Value>() where S == PassthroughSubject<Value?, Never> {
		self = StateSubject(wrappedValue: nil, PassthroughSubject())
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension StateSubject where Output: OptionalProtocol {
	
	public init(_ publisher: @escaping @autoclosure () -> S) {
		self = StateSubject(wrappedValue: .none, publisher())
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public typealias StateTimer = StatePublisher<Publishers.Autoconnect<Timer.TimerPublisher>, Date>

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct StatePublisher<P: Publisher, Output>: DynamicProperty, Publisher where P.Failure == Never, P.Output == Output {
	public typealias Failure = Never
	
	public var wrappedValue: P.Output {
		if object.model == nil {
			object.model = create()
		}
		return object.value ?? defaultValue
	}
	@StateObject private var object = Object()
	private let create: () -> P
	private let defaultValue: P.Output
	
	public var projectedValue: P {
		get {
			if object.model == nil {
				object.model = create()
			}
			return object.model
		}
		nonmutating set {
			object.model = newValue
		}
	}
	
	public init(wrappedValue: P.Output, _ publisher: @escaping @autoclosure () -> P) {
		defaultValue = wrappedValue
		create = publisher
	}
	
	public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
		projectedValue.receive(subscriber: subscriber)
	}
	
	private final class Object: ObservableObject {
		var model: P! {
			didSet {
				bag = []
				model.sink(receiveCompletion: { _ in }) {[weak self] in
					self?.value = $0
				}.store(in: &bag)
			}
		}
		@Published var value: P.Output?
		var bag: Set<AnyCancellable> = []
		
		init() {}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension StatePublisher where P.Output: OptionalProtocol {
	
	public init(_ publisher: @escaping @autoclosure () -> P) {
		self = StatePublisher(wrappedValue: .none, publisher())
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension StatePublisher where P == Publishers.Autoconnect<Timer.TimerPublisher> {
	
	public init(_ interval: TimeInterval, tolerance: TimeInterval? = nil, in mode: RunLoop.Mode = .default, options: RunLoop.SchedulerOptions? = nil) {
		self = StatePublisher(wrappedValue: Date(), Timer.publish(every: interval, tolerance: tolerance, on: .main, in: mode, options: options).autoconnect())
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public final class PublisherObject<P: Publisher>: ObservableObject where P.Failure == Never {
	public typealias ObjectWillChangePublisher = P
	public let publisher: P
	public var objectWillChange: P { publisher }
	
	public init(_ publisher: P) {
		self.publisher = publisher
	}
}
