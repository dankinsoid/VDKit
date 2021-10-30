//
//  File.swift
//  
//
//  Created by Данил Войдилов on 20.05.2021.
//

import Foundation

public func +(_ lhs: (() -> Void)?, _ rhs: (() -> Void)?) -> () -> Void {
	guard let l = lhs, let r = rhs else { return {} }
	return {
		l()
		r()
	}
}

public func +<In>(_ lhs: inout ((In) -> Void)?, _ rhs: ((In) -> Void)?) -> (In) -> Void {
	guard let l = lhs, let r = rhs else { return { _ in } }
	return {
		l($0)
		r($0)
	}
}

public func +<_0, _1>(_ lhs: inout ((_0, _1) -> Void)?, _ rhs: ((_0, _1) -> Void)?) -> (_0, _1) -> Void {
	guard let l = lhs, let r = rhs else { return {_, _ in } }
	return {
		l($0, $1)
		r($0, $1)
	}
}

public func +<_0, _1, _2>(_ lhs: inout ((_0, _1, _2) -> Void)?, _ rhs: ((_0, _1, _2) -> Void)?) -> (_0, _1, _2) -> Void {
	guard let l = lhs, let r = rhs else { return { _, _, _ in } }
	return {
		l($0, $1, $2)
		r($0, $1, $2)
	}
}

public func +<_0, _1, _2, _3>(_ lhs: inout ((_0, _1, _2, _3) -> Void)?, _ rhs: ((_0, _1, _2, _3) -> Void)?) -> (_0, _1, _2, _3) -> Void {
	guard let l = lhs, let r = rhs else { return { _, _, _, _ in } }
	return {
		l($0, $1, $2, $3)
		r($0, $1, $2, $3)
	}
}

public func +<_0, _1, _2, _3, _4>(_ lhs: inout ((_0, _1, _2, _3, _4) -> Void)?, _ rhs: ((_0, _1, _2, _3, _4) -> Void)?) -> (_0, _1, _2, _3, _4) -> Void {
	guard let l = lhs, let r = rhs else { return { _, _, _, _, _ in } }
	return {
		l($0, $1, $2, $3, $4)
		r($0, $1, $2, $3, $4)
	}
}

public func +=(_ lhs: inout (() -> Void)?, _ rhs: (() -> Void)?) {
	lhs = lhs + rhs
}

public func +=<In>(_ lhs: inout ((In) -> Void)?, _ rhs: ((In) -> Void)?) {
	lhs = lhs + rhs
}

public func +=<_0, _1>(_ lhs: inout ((_0, _1) -> Void)?, _ rhs: ((_0, _1) -> Void)?) {
	lhs = lhs + rhs
}

public func +=<_0, _1, _2>(_ lhs: inout ((_0, _1, _2) -> Void)?, _ rhs: ((_0, _1, _2) -> Void)?) {
	lhs = lhs + rhs
}

public func +=<_0, _1, _2, _3>(_ lhs: inout ((_0, _1, _2, _3) -> Void)?, _ rhs: ((_0, _1, _2, _3) -> Void)?) {
	lhs = lhs + rhs
}

public func +=<_0, _1, _2, _3, _4>(_ lhs: inout ((_0, _1, _2, _3, _4) -> Void)?, _ rhs: ((_0, _1, _2, _3, _4) -> Void)?) {
	lhs = lhs + rhs
}
