//
//  CountedSet.swift
//  Sets
//
//  Created by Michael MacCallum on 7/12/15.
//  Copyright © 2015 0x7fffffff. All rights reserved.
//

public struct CountedSet<T: Hashable>: SetAlgebra {
    public typealias Element = T

    fileprivate var backingDictionary = [Element: Int]()

    public var count: Int {
        return backingDictionary.count
    }

    public var isEmpty: Bool {
        return count == 0
    }

    public init() {
        // yay protocol conformance
    }

    public init(object: Element) {
        insert(object)
    }

    public init(countedSet: CountedSet<Element>) {
        backingDictionary = countedSet.backingDictionary
    }

    public init(arrayLiteral elements: CountedSet.Element...) {
        insert(elements)
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        insert(sequence as! [T])
    }

    public func count(for object: Element) -> Int {
        return backingDictionary[object] ?? 0
    }

    public func contains(_ member: CountedSet.Element) -> Bool {
        return backingDictionary[member] != nil
    }

    fileprivate mutating func insert(_ members: [T]) {
        for member in members {
            let (inserted, existing) = insert(member)

            if !inserted {
                update(with: existing)
            }
        }
    }

    @discardableResult
    public mutating func insert(_ newMember: T) -> (inserted: Bool, memberAfterInsert: T) {
        if backingDictionary.keys.contains(newMember) {
            return (false, newMember)
        } else {
            backingDictionary[newMember] = 1
            return (true, newMember)
        }
    }

    @discardableResult
    public mutating func update(with newMember: T) -> T? {
        return update(with: newMember, count: 1)
    }

    @discardableResult
    public mutating func update(with newMember: T, count: Int) -> T? {
        if let existing = backingDictionary[newMember] {
            backingDictionary[newMember] = (existing + count)
            return newMember
        } else {
            backingDictionary[newMember] = count
            return nil
        }
    }

    @discardableResult
    public mutating func remove(_ member: CountedSet.Element) -> CountedSet.Element? {
        return remove(member, count: 1)
    }

    @discardableResult
    public mutating func remove(_ member: CountedSet.Element, count: Int = 1) -> CountedSet.Element? {
        guard let value = backingDictionary[member] else {
            return nil
        }

        if value > count {
            backingDictionary[member] = (value - count)
        } else {
            backingDictionary.removeValue(forKey: member)
        }

        return member
    }

    public mutating func formUnion(_ other: CountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if let existingValue = backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary[key] = value
            }
        }
    }

    public func union(_ other: CountedSet<Element>) -> CountedSet<Element> {
        var unionized = self
        unionized.formUnion(other)

        return unionized
    }

    public mutating func formIntersection(_ other: CountedSet<Element>) {
        for (key, value) in backingDictionary {
            if let existingValue = other.backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary.removeValue(forKey: key)
            }
        }
    }

    public func intersectsSet(_ other: CountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if let _ = backingDictionary[key] {
                return true
            }
        }

        return false
    }

    public func intersection(_ other: CountedSet<Element>) -> CountedSet<Element> {
        var intersected = self
        intersected.formIntersection(other)

        return intersected
    }

    public mutating func formSymmetricDifference(_ other: CountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if let _ = backingDictionary[key] {
                backingDictionary.removeValue(forKey: key)
            } else {
                backingDictionary[key] = value
            }
        }
    }

    public func symmetricDifference(_ other: CountedSet<Element>) -> CountedSet<Element> {
        var xored = self
        xored.formSymmetricDifference(other)

        return xored
    }

    public mutating func subtract(_ other: CountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            guard let existingValue = backingDictionary[key] else {
                continue
            }

            if value >= existingValue {
                backingDictionary.removeValue(forKey: key)
            } else {
                backingDictionary[key] = existingValue - value
            }
        }
    }

    public func subtracting(_ other: CountedSet<Element>) -> CountedSet<Element> {
        var subtracted = self
        subtracted.subtract(other)

        return subtracted
    }

    public func isSubset(of other: CountedSet<Element>) -> Bool {
        for (key, _) in backingDictionary {
            if !other.backingDictionary.keys.contains(key) {
                return false
            }
        }

        return true
    }

    public func isDisjoint(with other: CountedSet<Element>) -> Bool {
        return intersection(other).isEmpty
    }

    public func isSuperset(of other: CountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if !backingDictionary.keys.contains(key) {
                return false
            }
        }

        return true
    }

    public func isStrictSupersetOf(_ other: CountedSet<Element>) -> Bool {
        return isSuperset(of: other) && count > other.count
    }

    public func isStrictSubsetOf(_ other: CountedSet<Element>) -> Bool {
        return isSubset(of: other) && count < other.count
    }

    public static func element(_ a: CountedSet.Element, subsumes b: CountedSet.Element) -> Bool {
        return CountedSet([a]).isSuperset(of: CountedSet([b]))
    }

    public static func element(_ a: CountedSet.Element, isDisjointWith b: CountedSet.Element) -> Bool {
        return !CountedSet.element(a, subsumes: b) && !CountedSet.element(b, subsumes: a)
    }
}

extension CountedSet: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return backingDictionary.description
    }

    public var debugDescription: String {
        return backingDictionary.debugDescription
    }
}

extension CountedSet : Hashable {
    public var hashValue: Int {
        var hash = 5381
        
        for (element, count) in backingDictionary {
            for _ in 1...count {
                hash = ((hash << 5) &+ hash) &+ element.hashValue
            }
        }
        
        return hash
    }
}

public func == <T: Hashable>(lhs: CountedSet<T>, rhs: CountedSet<T>) -> Bool {
    return lhs.backingDictionary == rhs.backingDictionary
}

extension CountedSet: Sequence {
	public func makeIterator() -> DictionaryIterator<Element,Int> {
		return backingDictionary.makeIterator()
	}
}

extension CountedSet {
    public func mapToCountedSet<U>(_ transform: (Element, Int) throws -> (element:U, count:Int)) rethrows -> CountedSet<U> {
        var result = CountedSet<U>()
        
        for (element, count) in backingDictionary {
            let (newElement, newCount) = try transform(element, count)
            result.update(with: newElement, count: newCount)
        }
    
        return result
    }

    public func flatMapToCountedSet<U>(_ transform: (Element, Int) throws -> (element:U, count:Int)?) rethrows -> CountedSet<U> {
        var result = CountedSet<U>()
        
        for (element, count) in backingDictionary {
            if let (newElement, newCount) = try transform(element, count) {
                result.update(with: newElement, count: newCount)
            }
        }
        
        return result
    }

    public func filterToCountedSet(_ inclusionCount: (Element, Int) throws -> Int) rethrows -> CountedSet<Element> {
        var result = CountedSet<Element>()
        
        for (element, count) in backingDictionary {
            let newCount = try inclusionCount(element, count)
            
            if newCount > 0 {
                result.update(with: element, count: newCount)
            }
        }
        
        return result
    }
    
    
}
