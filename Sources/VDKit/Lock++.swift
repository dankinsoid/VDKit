//
//  Lock++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension NSRecursiveLock {
	
	public func protect(code: () -> ()) {
		lock()
		code()
		unlock()
	}
	
	public func protect<T>(code: () -> T) -> T {
		lock()
		defer { unlock() }
		return code()
	}
}

extension NSLock {
	
	public func protect(code: () -> ()) {
		lock()
		code()
		unlock()
	}
	
	public func protect<T>(code: () -> T) -> T {
		lock()
		defer { unlock() }
		return code()
	}
}
