//
//  File.swift
//  
//
//  Created by Данил Войдилов on 04.05.2021.
//

#if !os(Linux)
import Foundation
#if SWIFT_PACKAGE && !DISABLE_SWIZZLING && !os(Linux)
import VDKitRuntime
#endif

#if !DISABLE_SWIZZLING && !os(Linux)
private var deallocatingSubjectTriggerContext: UInt8 = 0
private var deallocatingSubjectContext: UInt8 = 0
#endif
private var deallocatedSubjectTriggerContext: UInt8 = 0
private var deallocatedSubjectContext: UInt8 = 0

// Dealloc
@discardableResult
public func onDeallocated(_ base: AnyObject, action: @escaping () -> Void) -> () -> Void {
	synchronized(on: base) {
		let id = UUID()
		if let deallocObserver = objc_getAssociatedObject(base, &deallocatedSubjectContext) as? DeallocObserver {
			deallocObserver.actions[id] = action
			return { deallocObserver.actions[id] = nil }
		}
		
		let deallocObserver = DeallocObserver()
		deallocObserver.actions[id] = action
		
		objc_setAssociatedObject(base, &deallocatedSubjectContext, deallocObserver, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return { deallocObserver.actions[id] = nil }
	}
}

#if !DISABLE_SWIZZLING && !os(Linux)
	
extension NSObject {
	
	@discardableResult
	public func onSentMessage(_ selector: Selector, action: @escaping ([Any]) -> Void) throws -> () -> Void {
		try synchronized(on: self) {
			if selector == deallocSelector {
				return try onDeallocating { action([]) }
			}
			let proxy: MessageSentProxy = try self.registerMessageInterceptor(selector)
			let id = UUID()
			proxy.messageSent[id] = action
			return { proxy.messageSent[id] = nil }
		}
	}
	
	@discardableResult
	public func onMethodInvoked(_ selector: Selector, action: @escaping ([Any]) -> Void) throws -> () -> Void {
		try synchronized(on: self) {
			// in case of dealloc selector replay subject behavior needs to be used
			if selector == deallocSelector {
				return onDeallocated(self) { action([]) }
			}
			
			let proxy: MessageSentProxy = try self.registerMessageInterceptor(selector)
			let id = UUID()
			proxy.methodInvoked[id] = action
			return { proxy.methodInvoked[id] = nil }
		}
	}
	
	@discardableResult
	public func onDeallocating(_ action: @escaping () -> Void) throws -> () -> Void {
		try synchronized(on: self) {
			let proxy: DeallocatingProxy = try self.registerMessageInterceptor(deallocSelector)
			let id = UUID()
			proxy.messageSent[id] = action
			return { proxy.messageSent[id] = nil }
		}
	}
	
	private func registerMessageInterceptor<T: MessageInterceptorSubject>(_ selector: Selector) throws -> T {
		let rxSelector = VD_selector(selector)
		let selectorReference = VD_reference_from_selector(rxSelector)
		
		let subject: T
		if let existingSubject = objc_getAssociatedObject(self, selectorReference) as? T {
			subject = existingSubject
		}
		else {
			subject = T()
			objc_setAssociatedObject(
				self,
				selectorReference,
				subject,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC
			)
		}
		
		if subject.isActive {
			return subject
		}
		
		var error: NSError?
		let targetImplementation = VD_ensure_observing(self, selector, &error)
		if targetImplementation == nil {
			throw error ?? OptionalException.nil
		}
		subject.targetImplementation = targetImplementation!
		
		return subject
	}
}
#endif

// MARK: Message interceptors

#if !DISABLE_SWIZZLING && !os(Linux)

private protocol MessageInterceptorSubject: AnyObject {
	init()
	var isActive: Bool { get }
	var targetImplementation: IMP { get set }
}

private final class DeallocatingProxy: MessageInterceptorSubject, VDDeallocatingObserver {
	typealias Element = ()
	
	var messageSent: [UUID: () -> Void] = [:]
	
	@objc var targetImplementation: IMP = VD_default_target_implementation()
	
	var isActive: Bool {
		return self.targetImplementation != VD_default_target_implementation()
	}
	
	init() {}
	
	@objc func deallocating() {
		self.messageSent.forEach { $0.value() }
	}
}

private final class MessageSentProxy: MessageInterceptorSubject, VDMessageSentObserver {
	typealias Element = [AnyObject]
	
	var messageSent: [UUID: ([Any]) -> Void] = [:]
	var methodInvoked: [UUID: ([Any]) -> Void] = [:]
	
	@objc var targetImplementation: IMP = VD_default_target_implementation()
	
	var isActive: Bool {
		return self.targetImplementation != VD_default_target_implementation()
	}
	
	init() {}
	
	@objc func messageSent(withArguments arguments: [Any]) {
		self.messageSent.forEach { $0.value(arguments) }
	}
	
	@objc func methodInvoked(withArguments arguments: [Any]) {
		self.methodInvoked.forEach { $0.value(arguments) }
	}
}

#endif

private final class DeallocObserver {
	var actions: [UUID: () -> Void] = [:]
	
	deinit {
		actions.forEach { $0.value() }
	}
}

// MARK: Constants

private let deallocSelector = NSSelectorFromString("dealloc")

func synchronized<T>(on base: AnyObject, _ action: () throws -> T) rethrows -> T {
	objc_sync_enter(base)
	let result = try action()
	objc_sync_exit(base)
	return result
}

#endif
