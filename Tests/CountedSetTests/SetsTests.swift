//
//  SetsTests.swift
//  SetsTests
//
//  Created by Michael MacCallum on 7/12/15.
//  Copyright © 2015 0x7fffffff. All rights reserved.
//

import XCTest
@testable import CountedSet

class SetsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInsert() {
        var countedSet = CountedSet<Int>()

        for i in 0...10 {
            countedSet.insert(i)
        }

        for i in 5...15 {
            let (inserted, element) = countedSet.insert(i)

            if !inserted {
                countedSet.update(with: element)
            }
        }

        print(countedSet)
        XCTAssert(countedSet.count == 16)
    }

    func testUpdate() {
        var countedSet = CountedSet<Int>([1, 2, 3, 4, 5])

        XCTAssertEqual(countedSet.count(for: 3), 1)

        countedSet.update(with: 3)
        countedSet.update(with: 3, count: 2)
        countedSet.update(with: 3, count: 3)

        XCTAssertEqual(countedSet.count(for: 3), 7)
    }

    func testRemove() {
        var countedSet = CountedSet<Int>()
        countedSet.insert(42)
        countedSet.update(with: 42)
        countedSet.update(with: 42)
        countedSet.insert(17)
        print(countedSet)

        countedSet.remove(42)
        countedSet.remove(42)
        countedSet.remove(42)

        print(countedSet)
        XCTAssert(countedSet.count == 1)
    }

    func testRemoveWithCount() {
        var countedSet: CountedSet<Int> = [1,42,42,42,42,42,3,4]

        XCTAssertEqual(countedSet.count(for: 42), 5)

        countedSet.remove(42)
        XCTAssertEqual(countedSet.count(for: 42), 4)

        countedSet.remove(42, count: 2)
        XCTAssertEqual(countedSet.count(for: 42), 2)

        countedSet.remove(42, count: 2)
        XCTAssertFalse(countedSet.contains(42))

        countedSet.remove(1, count: 55)
        XCTAssertFalse(countedSet.contains(1))
    }

    func testCountForObject() {
        var countedSet = CountedSet<Int>([1, 2, 3, 4, 5])

        XCTAssert(countedSet.count(for:3) == 1)

        countedSet.update(with: 3)
        countedSet.update(with: 3)

        XCTAssert(countedSet.count(for:3) == 3)

        countedSet.remove(3)
        countedSet.remove(3)
        countedSet.remove(3)

        XCTAssert(countedSet.count(for:3) == 0)
    }

    func testUnion() {
        var countedSet1 = CountedSet<Int>()
        countedSet1.insert(0)
        countedSet1.insert(1)
        countedSet1.insert(2)

        var countedSet2 = CountedSet<Int>()
        countedSet2.insert(2)
        countedSet2.insert(3)
        countedSet2.insert(4)

        let union = countedSet1.union(countedSet2)

        print(union)
        XCTAssert(union.count == 5)

        let appleSet1 = NSCountedSet()
        appleSet1.add(0)
        appleSet1.add(1)
        appleSet1.add(2)

        let appleSet2 = NSCountedSet()
        appleSet2.add(2)
        appleSet2.add(3)
        appleSet2.add(4)

        appleSet1.union(appleSet2 as Set<NSObject>)

        print(appleSet1)
        XCTAssert(appleSet1.count == union.count)
    }

    func testIntersection() {
        var countedSet = CountedSet<Int>()
        for i in 0...10 {
            countedSet.insert(i)
        }

        var countedSet2 = CountedSet<Int>()
        for i in 5...15 {
            countedSet2.insert(i)
        }

        let intersection = countedSet.intersection(countedSet2)

        print(intersection)
        XCTAssert(intersection.count == 6)

        let appleSet1 = NSCountedSet()
        for i in 0...10 {
            appleSet1.add(i)
        }


        let appleSet2 = NSCountedSet()
        for i in 5...15 {
            appleSet2.add(i)
        }

        appleSet1.intersect(appleSet2 as Set<NSObject>)
        print(appleSet1)

        XCTAssert(appleSet1.count == intersection.count)
    }

    func testExclusiveOR() {
        var countedSet1 = CountedSet<Int>()
        countedSet1.insert(0)
        countedSet1.insert(1)
        countedSet1.insert(2)

        var countedSet2 = CountedSet<Int>()
        countedSet2.insert(2)
        countedSet2.insert(3)
        countedSet2.insert(4)

        let xored = countedSet1.symmetricDifference(countedSet2)
        print(xored)

        XCTAssert(xored.count == 4)

        let appleSet1 = NSCountedSet()
        appleSet1.add(0)
        appleSet1.add(1)
        appleSet1.add(2)

        let appleSet2 = NSCountedSet()
        appleSet2.add(2)
        appleSet2.add(3)
        appleSet2.add(4)
    }

    func testSubtract() {
        let countedSet1 = CountedSet([1, 2, 3, 1, 2])
        let countedSet2 = CountedSet([1, 2])

        XCTAssert(countedSet1.count(for:1) == 2)

        let subtracted = countedSet1.subtracting(countedSet2)

        XCTAssert(subtracted.count == 3)
        XCTAssert(subtracted.count(for:1) == 1)
    }

    func testIsEmpty() {
        var countedSet1 = CountedSet<Int>()

        XCTAssert(countedSet1.isEmpty)

        countedSet1.insert(3)

        XCTAssert(!countedSet1.isEmpty)

        countedSet1.remove(3)

        XCTAssert(countedSet1.isEmpty)
    }

    func testCount() {
        var countedSet1 = CountedSet<Int>()

        countedSet1.insert(0)
        countedSet1.insert(1)
        countedSet1.update(with: 1)
        countedSet1.update(with: 1)

        XCTAssert(countedSet1.count == 2)

        countedSet1.remove(1)
        countedSet1.remove(1)
        countedSet1.remove(1)
        countedSet1.remove(2)

        XCTAssert(countedSet1.count == 1)
    }

    func testSubsets() {
        let countedSet1 = CountedSet([1, 2, 3])
        let countedSet2 = CountedSet([1, 2, 3])

        XCTAssert(countedSet2.isSubset(of: countedSet1))
        XCTAssert(!countedSet2.isStrictSubsetOf(countedSet1))
    }

    func testSupersets() {
        let countedSet1 = CountedSet([1, 2, 3])
        let countedSet2 = CountedSet([1, 2, 3])

        XCTAssert(countedSet1.isSuperset(of: countedSet2))
        XCTAssert(!countedSet1.isStrictSupersetOf(countedSet2))
    }

    func testSubsumes() {
        let a = 42
        let b = 42
        let c = 17

        XCTAssert(CountedSet.element(a, subsumes: b))
        XCTAssert(!CountedSet.element(a, subsumes: c))
    }

    func testSetIsDisjoint() {
        let countedSet1 = CountedSet([1, 2, 3])
        let countedSet2 = CountedSet([4, 5, 6])
        let countedSet3 = CountedSet([3, 4])

        XCTAssert(countedSet1.isDisjoint(with: countedSet2))
        XCTAssert(!countedSet1.isDisjoint(with: countedSet3))
    }
    
    func testIsDisjoint() {
        let a = 4
        let b = 5
        let c = 4
        
        XCTAssert(CountedSet.element(a, isDisjointWith: b))
        XCTAssert(!CountedSet.element(a, isDisjointWith: c))
    }
    
    func testEquality() {
        let countedSet1 = CountedSet([1, 2, 3])
        let countedSet2 = CountedSet([1, 2, 3])
        let countedSet3 = CountedSet([4, 5, 6])
        
        XCTAssert(countedSet1 == countedSet2)
        XCTAssert(countedSet1 != countedSet3)
    }
    
    func testHashValue() {
        let countedSet1 = CountedSet([17, 10, 75])
        let countedSet2 = CountedSet([17, 10, 75])
        
        XCTAssertEqual(countedSet1.hashValue, countedSet2.hashValue)
    }
    
    func testMapToCountedSet() {
        let countedSet = CountedSet([1, 1, 2, 17])
        let expected = CountedSet([0.5, 0.5, 0.5, 0.5, 1, 1, 8.5, 8.5])
        
        let result = countedSet.mapToCountedSet { (element: 0.5 * Double($0), count: 2 * $1) }
        
        XCTAssertEqual(expected, result)
    }

    func testFlatMapToCountedSet() {
        let countedSet = CountedSet([1, 2, 3, 4, 5, 5])
        let expected = CountedSet([1.5, 1.5, 3.5, 3.5, 5.5, 5.5, 5.5])
        
        let result = countedSet.flatMapToCountedSet { $0 % 2 == 0 ? nil : (element: 0.5 + Double($0), count: 1 + $1) }
        
        XCTAssertEqual(expected, result)
    }

    func testFilterToCountedSet() {
        let countedSet = CountedSet([1, 1, 2, 3, 17, 17, 17])
        let expected = CountedSet([1, 2, 2, 17, 17])
        
        let result = countedSet.filterToCountedSet { $0 % 2 == 0 ? $1 + 1 : $1 - 1 }
        
        XCTAssertEqual(expected, result)
    }
}
