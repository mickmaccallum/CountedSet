## CountedSet

A generic Swift counted set (multiset) implementation. This structure has been built to conform to Swift 3's SetAlgebra protocol.

## Usage

#### Creating a CountedSet

CountedSet's are generic, and can be created using any generic type, as long as this type is [Hashable](http://swiftdoc.org/v2.0/protocol/Hashable/).

```swift
var countedSet = CountedSet<Int>()
```

#### Adding Elements to a CountedSet
Elements are added to a CountedSet via its insert and update methods. `insert` returns a tuple containing a Bool representing whether or not the operation was successful, and an element of the set representing either the matching element that already existed, or the new element that was just inserted. As per updates to SetAlgebra in Swift 3, insertion operations will only happen if the set doesn't already contain the element being inserted, and will not increase the count of an element if it is inserted twice.

```swift
let (success, element) = countedSet.insert(element)
```

`update` is used to update the value of an element that may or may not be in the set. When you call `update`, the a matching element will be returned if it already existed in the set, or nil if it did not, in which case an insertion is performed. In both of these cases, the count for a given element will be as is expected, and you'll probably want to use `update` over `insert` in the general case.

```swift
let element = countedSet.update(element)
```

#### Removing Elements From a CountedSet
Elements are removed from a CountedSet via its remove instance method, this method takes any valid element for the set as input, and returns an optional of the same type. If this method returns nil, the set didn't contain the specified element, otherwise, it did, and the count for that element is decremented.

Consider the following example, where the number 42 is inserted into the set twice. Remove is only called once with 42 as input, so 42 won't be removed from the set. Instead, it will have its associated count set to 1 and then 2 by the calls to insert, and then will have its count decremented back down to 1 by the remove call. Calling remove once more for 42 would remove it from the set.

```swift
var countedSet = CountedSet<Int>()
countedSet.insert(42)
countedSet.update(42)
countedSet.remove(42)
```

#### Getting an Element's Count
The whole point of a CountedSet is that it keeps track of how many times each element has been added to it, which of course means that it provides facilities for accessing this information. In an attempt to keep naming conventions as similar as possible to those of [NSCountedSet](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSCountedSet_Class/#//apple_ref/occ/instm/NSCountedSet/countForObject:) (where possible), the count for a given element is found via its countForObject instance method.

```swift
var countedSet = CountedSet([1, 4, 4, 2, 2, 2])
let ones = countedSet.countForObject(1) // 1
let twos = countedSet.countForObject(2) // 3
let fours = countedSet.countForObject(4) // 2
```

#### Unions, Intersections, XORs & Subtractions
Since CountedSet is set, it provides many of the features you'd expect from one. These include methods for the creation of unions, intersections, XORs & subtractions. The only real difference between these, and their set equivalents is that they take the count of each object into consideration. For example, when taking the union of two sets, the resultant set will contain all of the elements from both input sets with the counts of each object equaling the sum of their previous two counts.

```swift
var countedSet1 = CountedSet([1, 1, 1, 2])
let countedSet2 = CountedSet([2, 2, 2, 3])

let union = countedSet1.union(countedSet2) // [1, 2, 3]
let ones = union.countForObject(1) // 3
let twos = union.countForObject(2) // 4
let threes = union.countForObject(3) // 1
```

#### Other Stuff

###### isEmpty
```swift
var countedSet = CountedSet<Int>()
countedSet.isEmpty // true
countedSet.insert(3)
countedSet.isEmpty // false
countedSet.remove(3)
countedSet.isEmpty // true
```

## Development

To generate Xcode project invoke `make generate`. You can also generate and open Xcode project by invoking `make open`.
