//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import Foundation

extension Mirror {
	
	public static func description(of value: Any) -> String {
		let mirror = Mirror(reflecting: value)
		if mirror.children.isEmpty {
			return "\(value)"
		} else {
			return "\(type(of: value))(" + mirror.children.map { "\($0.label ?? ""): " + description(of: $0.value) }.joined(separator: ", ") + ")"
		}
	}
	
    public var asJson: [String?: Any] {
        Dictionary(children.map { ($0.label, Mirrored($0.value).asJson) }, uniquingKeysWith: { _, p in p })
	}
    
    public var dictionary: [String?: Any] {
        Dictionary(children.map { ($0.label, $0.value) }, uniquingKeysWith: { _, p in p })
    }
    
    public func last(_ first: String) -> Any? {
        let current = recursive(path: [first])
        return current.flatMap { Mirror(reflecting: $0).last(first) } ?? current
    }
    
    public func recursive<C: Collection>(path: C) -> Any? where C.Element == String {
        guard !path.isEmpty else { return nil }
        if let value = children.first(where: { $0.label == path.first })?.value {
            if path.count == 1 { return value }
            if let result = Mirror(reflecting: value).recursive(path: path.dropFirst()) {
                return result
            }
        }
        for (_, value) in children {
            if let result = Mirror(reflecting: value).recursive(path: path) {
                return result
            }
        }
        return nil
    }
}

private struct Mirrored<T> {
    var mirror: Mirror
    var value: T
    
    init(_ value: T) {
        self.value = value
        self.mirror = Mirror(reflecting: value)
    }
    
    var asJson: [String?: Any] {
        mirror.children.isEmpty ? [nil: value] : mirror.asJson
    }
}
