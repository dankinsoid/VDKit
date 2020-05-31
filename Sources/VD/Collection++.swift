//
//  Collection++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension Collection {
    
    public func split(by number: Int) -> [[Element]] {
        guard !isEmpty, number > 0 else { return [] }
        var result: [[Element]] = []
        var copy = Array(self)
        let itemCount = count % number == 0 ? count / number : count / number + 1
        for _ in 0..<itemCount {
            let item = Array(copy.prefix(number))
            result.append(item)
            if number <= copy.count {
                copy.removeFirst(number)
            }
        }
        return result
    }
    
    public subscript(safe index: Index) -> Element? {
        if isEmpty { return nil }
        if index >= startIndex && index < endIndex {
            return self[index]
        }
        return nil
    }
    
}

extension Array where Element: Hashable {
    public func removeEqual() -> [Element] {
        var result: [Element] = []
        result.reserveCapacity(count)
        forEach {
            if !result.contains($0) {
                result.append($0)
            }
        }
        return result
    }
}

extension Array {
    public func removeEqual<H: Equatable>(by keyPath: KeyPath<Element, H>) -> [Element] {
        var result: [Element] = []
        result.reserveCapacity(count)
        forEach { e in
            if !result.contains(where: { $0[keyPath: keyPath] == e[keyPath: keyPath] }) {
                result.append(e)
            }
        }
        return result
    }
}

extension Array {
    public subscript(safe index: Index) -> Element? {
        get {
            guard index >= startIndex, index < endIndex else { return nil }
            return self[index]
        }
        set {
            guard index >= startIndex, index <= endIndex else { return }
            if let value = newValue {
                if index < endIndex  {
                    self[index] = value
                } else {
                    append(value)
                }
            } else if index < endIndex  {
                remove(at: index)
            }
        }
    }
}
