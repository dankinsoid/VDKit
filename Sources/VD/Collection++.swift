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
