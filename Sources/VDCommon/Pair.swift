//
//  Pair.swift
//  IterableStruct
//
//  Created by Данил Войдилов on 29.04.2021.
//

import Foundation

public struct Pair<F, S> {
	public var _0: F
	public var _1: S
	
	public init(_ first: F, _ second: S) {
		_0 = first
		_1 = second
	}
}
