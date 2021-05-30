//
//  File.swift
//  
//
//  Created by Данил Войдилов on 30.05.2021.
//

import Foundation

extension Bool {
	public var toggled: Bool {
		get { !self }
		set { self = !newValue }
	}
}

public prefix func !<Root>(_ lhs: KeyPath<Root, Bool>) -> KeyPath<Root, Bool> {
	lhs.appending(path: \.toggled)
}

public prefix func !<Root>(_ lhs: WritableKeyPath<Root, Bool>) -> WritableKeyPath<Root, Bool> {
	lhs.appending(path: \.toggled)
}
