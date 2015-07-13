//
//  CountedSet.swift
//  Sets
//
//  Created by Michael MacCallum on 7/12/15.
//  Copyright © 2015 0x7fffffff. All rights reserved.
//

public struct CountedSet<T : Hashable> : SetAlgebraType {
    typealias Element = T
    typealias Index = SetIndex<Element>
    typealias GeneratorType = SetGenerator<Element>

    private var backingDictionary = [Element : Int]()

    public var count: CountedSet.Index.Distance {
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
        for member in elements {
            insert(member)
        }
    }

    public init<S : SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        for member in sequence {
            insert(member)
        }
    }

    public func countForObject(object: Element) -> Int {
        return backingDictionary[object] ?? 0
    }

    public func contains(member: CountedSet.Element) -> Bool {
        return backingDictionary[member] != nil
    }

    public mutating func insert(member: CountedSet.Element) {
        if let existing = backingDictionary[member] {
            backingDictionary[member] = existing + 1
        } else {
            backingDictionary[member] = 1
        }
    }

    public mutating func remove(member: CountedSet.Element) -> CountedSet.Element? {
        if let value = backingDictionary[member] {
            if value > 1 {
                backingDictionary[member] = value - 1
            } else {
                backingDictionary.removeValueForKey(member)
            }

            return member
        }

        return nil
    }

    public mutating func unionInPlace(other: CountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if let existingValue = backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary[key] = value
            }
        }
    }

    public func union(other: CountedSet<Element>) -> CountedSet<Element> {
        var unionized = self
        unionized.unionInPlace(other)

        return unionized
    }

    public mutating func intersectInPlace(other: CountedSet<Element>) {
        for (key, value) in backingDictionary {
            if let existingValue = other.backingDictionary[key] {
                backingDictionary[key] = existingValue + value
            } else {
                backingDictionary.removeValueForKey(key)
            }
        }
    }

    public func intersectsSet(other: CountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if backingDictionary[key] != nil {
                return true
            }
        }

        return false
    }

    public func intersect(other: CountedSet<Element>) -> CountedSet<Element> {
        var intersected = self
        intersected.intersectInPlace(other)

        return intersected
    }

    public mutating func exclusiveOrInPlace(other: CountedSet<Element>) {
        for (key, value) in other.backingDictionary {
            if backingDictionary[key] == nil {
                backingDictionary[key] = value
            } else {
                backingDictionary.removeValueForKey(key)
            }
        }
    }

    public func exclusiveOr(other: CountedSet<Element>) -> CountedSet<Element> {
        var xored = self
        xored.exclusiveOrInPlace(other)

        return xored
    }

    public mutating func subtractInPlace(other: CountedSet<Element>) {
        for (key, _) in other.backingDictionary {
            backingDictionary.removeValueForKey(key)
        }
    }

    public func subtract(other: CountedSet<Element>) -> CountedSet<Element> {
        var subtracted = self
        subtracted.subtractInPlace(other)
        
        return subtracted
    }

    public func isSubsetOf(other: CountedSet<Element>) -> Bool {
        for (key, _) in backingDictionary {
            if other.backingDictionary[key] == nil {
                return false
            }
        }

        return true
    }

    public func isDisjointWith(other: CountedSet<Element>) -> Bool {
        return intersect(other).isEmpty
    }

    public func isSupersetOf(other: CountedSet<Element>) -> Bool {
        for (key, _) in other.backingDictionary {
            if backingDictionary[key] == nil {
                return false
            }
        }

        return true
    }

    public func isStrictSupersetOf(other: CountedSet<Element>) -> Bool {
        return isSupersetOf(other) && count > other.count
    }

    public func isStrictSubsetOf(other: CountedSet<Element>) -> Bool {
        return isSubsetOf(other) && count < other.count
    }

    public static func element(a: CountedSet.Element, subsumes b: CountedSet.Element) -> Bool {
        return CountedSet([a]).isSupersetOf(CountedSet([b]))
    }

    public static func element(a: CountedSet.Element, isDisjointWith b: CountedSet.Element) -> Bool {
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

public func == <T: Hashable>(lhs: CountedSet<T>, rhs: CountedSet<T>) -> Bool {
    return lhs.backingDictionary == rhs.backingDictionary
}
