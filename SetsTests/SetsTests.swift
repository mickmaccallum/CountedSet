//
//  SetsTests.swift
//  SetsTests
//
//  Created by Michael MacCallum on 7/12/15.
//  Copyright © 2015 0x7fffffff. All rights reserved.
//

import XCTest
@testable import Sets

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
            countedSet.insert(i)
        }

        print(countedSet)
        XCTAssert(countedSet.count == 16)
    }

    func testRemove() {
        var countedSet = CountedSet<Int>()
        countedSet.insert(42)
        countedSet.insert(42)
        countedSet.insert(42)
        countedSet.insert(17)
        print(countedSet)

        countedSet.remove(42)
        countedSet.remove(42)
        countedSet.remove(42)

        print(countedSet)
        XCTAssert(countedSet.count == 1)
    }

    func testCountForObject() {
        var countedSet = CountedSet<Int>([1, 2, 3, 4, 5])

        XCTAssert(countedSet.countForObject(3) == 1)

        countedSet.insert(3)
        countedSet.insert(3)

        XCTAssert(countedSet.countForObject(3) == 3)

        countedSet.remove(3)
        countedSet.remove(3)
        countedSet.remove(3)

        XCTAssert(countedSet.countForObject(3) == 0)
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
        appleSet1.addObject(0)
        appleSet1.addObject(1)
        appleSet1.addObject(2)

        let appleSet2 = NSCountedSet()
        appleSet2.addObject(2)
        appleSet2.addObject(3)
        appleSet2.addObject(4)

        appleSet1.unionSet(appleSet2 as Set<NSObject>)

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

        let intersection = countedSet.intersect(countedSet2)

        print(intersection)
        XCTAssert(intersection.count == 6)

        let appleSet1 = NSCountedSet()
        for i in 0...10 {
            appleSet1.addObject(i)
        }


        let appleSet2 = NSCountedSet()
        for i in 5...15 {
            appleSet2.addObject(i)
        }

        appleSet1.intersectSet(appleSet2 as Set<NSObject>)
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

        let xored = countedSet1.exclusiveOr(countedSet2)
        print(xored)

        XCTAssert(xored.count == 4)

        let appleSet1 = NSCountedSet()
        appleSet1.addObject(0)
        appleSet1.addObject(1)
        appleSet1.addObject(2)

        let appleSet2 = NSCountedSet()
        appleSet2.addObject(2)
        appleSet2.addObject(3)
        appleSet2.addObject(4)

        appleSet1
    }

    func testSubtract() {
        let countedSet1 = CountedSet<Int>([1, 2, 3, 1, 2])
        let countedSet2 = CountedSet<Int>([1, 2])

        XCTAssert(countedSet1.countForObject(1) == 2)

        let subtracted = countedSet1.subtract(countedSet2)

        XCTAssert(subtracted.count == 3)
        XCTAssert(subtracted.countForObject(1) == 1)
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
        countedSet1.insert(1)

        XCTAssert(countedSet1.count == 2)

        countedSet1.remove(1)
        countedSet1.remove(1)
        countedSet1.remove(2)

        XCTAssert(countedSet1.count == 1)
    }

    func testSubsets() {
        let countedSet1 = CountedSet<Int>([1, 2, 3])
        let countedSet2 = CountedSet<Int>([1, 2, 3])

        XCTAssert(countedSet2.isSubsetOf(countedSet1))
        XCTAssert(!countedSet2.isStrictSubsetOf(countedSet1))
    }

    func testSupersets() {
        let countedSet1 = CountedSet<Int>([1, 2, 3])
        let countedSet2 = CountedSet<Int>([1, 2, 3])

        XCTAssert(countedSet1.isSupersetOf(countedSet2))
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
        let countedSet1 = CountedSet<Int>([1, 2, 3])
        let countedSet2 = CountedSet<Int>([4, 5, 6])
        let countedSet3 = CountedSet<Int>([3, 4])

        XCTAssert(countedSet1.isDisjointWith(countedSet2))
        XCTAssert(!countedSet1.isDisjointWith(countedSet3))
    }

    func testIsDisjoint() {
        let a = 4
        let b = 5
        let c = 4

        XCTAssert(CountedSet.element(a, isDisjointWith: b))
        XCTAssert(!CountedSet.element(a, isDisjointWith: c))
    }

    func testEquality() {
        let countedSet1 = CountedSet<Int>([1, 2, 3])
        let countedSet2 = CountedSet<Int>([1, 2, 3])
        let countedSet3 = CountedSet<Int>([4, 5, 6])

        XCTAssert(countedSet1 == countedSet2)
        XCTAssert(countedSet1 != countedSet3)
    }
}
