//
//  Collection++.swift
//  VD
//
//  Created by Daniil on 10.08.2019.
//

import Foundation

extension Collection {
	
	public var nilIfEmpty: Self? {
		isEmpty ? nil : self
	}
	
	public var array: [Element] {
		Array(self)
	}
	
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
	
	public func prefix(_ maxLength: Int, where condition: (Element) -> Bool) -> [Element] {
		var result: [Element] = []
		result.reserveCapacity(maxLength)
		for element in self {
			if condition(element) {
				result.append(element)
			}
			if result.count == maxLength {
				return result
			}
		}
		return result
	}
	
	public func mapDictionary<Key: Hashable, Value>(_ transform: (Element) -> (Key, Value), uniquingKeysWith: (Value, Value) throws -> Value) rethrows -> [Key: Value] {
		try Dictionary(map(transform), uniquingKeysWith: uniquingKeysWith)
	}
	
	public func mapDictionary<Key: Hashable, Value>(_ transform: (Element) -> (Key, Value)) -> [Key: Value] {
		mapDictionary(transform, uniquingKeysWith: { _, second in second })
	}
	
	public func mapDictionary<Key: Hashable>(by key: KeyPath<Element, Key>) -> [Key: Element] {
		mapDictionary { ($0[keyPath: key], $0) }
	}
	
	public func compactMapDictionary<Key: Hashable, Value>(_ transform: (Element) -> (Key, Value)?, uniquingKeysWith: (Value, Value) throws -> Value) rethrows -> [Key: Value] {
		try Dictionary(compactMap(transform), uniquingKeysWith: uniquingKeysWith)
	}
	
	public func compactMapDictionary<Key: Hashable, Value>(_ transform: (Element) -> (Key, Value)?) -> [Key: Value] {
		compactMapDictionary(transform, uniquingKeysWith: { _, second in second })
	}
    
    func grouped(by isEqual: (Element, Element) -> Bool) -> [[Element]] {
        var groups: [[Element]] = []
        for element in self {
            if let i = groups.firstIndex(where: { isEqual($0[0], element) }) {
                groups[i].append(element)
            } else {
                groups.append([element])
            }
        }
        return groups
    }
    
    func grouped<T>(by keyPath: KeyPath<Element, T>, _ isEqual: (T, T) -> Bool) -> [[Element]] {
        grouped {
            isEqual($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    
    func grouped<T: Equatable>(by keyPath: KeyPath<Element, T>) -> [[Element]] {
        grouped(by: keyPath, ==)
    }
}

extension Sequence {
	
	public func scan<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> [Result] {
		var result = initialResult
		return try map {
			result = try nextPartialResult(result, $0)
			return result
		}
	}
	
	public func reduce<Result>(while condition: (Result) -> Bool, _ initialValue: Result, _ reducing: (Result, Element) -> Result) -> Result {
		var result = initialValue
		for element in self {
			guard condition(result) else { return result }
			result = reducing(result, element)
		}
		return result
	}
}

extension RangeReplaceableCollection  {
	
	public subscript(safe index: Index) -> Element? {
		get {
			guard index >= startIndex, index < endIndex else { return nil }
			return self[index]
		}
		set {
			guard index >= startIndex, index <= endIndex else { return }
			if let value = newValue {
				if index < endIndex  {
					replaceSubrange(index...index, with: [value])
				} else {
					append(value)
				}
			} else if index < endIndex  {
				remove(at: index)
			}
		}
	}
}

extension Collection where Element: Equatable {
	
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

extension Collection {
	
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

	public func join(with other: [Element], every step: Int, offset: Int) -> [Element] {
		guard !other.isEmpty else { return Array(self) }
		var result = Array(self)
		var index = offset
		for element in other {
			index = Swift.max(0, Swift.min(index + step, count))
			result.insert(element, at: index)
			guard index < count - 1 else { return result }
		}
		return result
	}
}

extension ClosedRange where Bound: FloatingPoint {
	
	public func split(count: Int) -> [Bound] {
		guard count > 0 else { return [] }
		guard count > 1 else { return [lowerBound] }
		guard count > 2 else { return [lowerBound, upperBound] }
		let delta = (upperBound - lowerBound) / Bound(count)
		var result: [Bound] = []
		result.append(lowerBound)
		for _ in 1..<(count - 1) {
			result.append(result.last! + delta)
		}
		result.append(upperBound)
		return result
	}
}

extension Collection where Element: Collection {
	
	public func joinedArray() -> [Element.Element] {
		Array(joined())
	}
}

public func +=<K, V>(left: inout [K: V], right: [K: V]) {
  left = left + right
}

public func +<K, V>(left: [K: V], right: [K: V]) -> [K: V] {
  left.merging(right, uniquingKeysWith: { _, rhs in rhs })
}

private extension Dictionary {
  mutating func mutate(for key: Key, mutator: (inout Value?) -> Void) {
    var val = self[key]
    mutator(&val)
    self[key] = val
  }
}

extension Set {
	
	public subscript(_ element: Element) -> Bool {
		get { contains(element) }
		set {
			if newValue {
				insert(element)
			} else {
				remove(element)
			}
		}
	}
}
