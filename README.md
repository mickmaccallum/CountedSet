## CountedSet

A generic Swift counted set (multiset) implementation. This structure has been built to conform to Swift 2's SetAlgebraType protocol.

## Usage

#### Creating a CountedSet

CountedSet's are generic, and can be created using any generic type, as long as this type is [Hashable](http://swiftdoc.org/v2.0/protocol/Hashable/).

~~~{swift}
var countedSet = CountedSet<Int>()
~~~

#### Adding Elements to a CountedSet
Elements are added to a CountedSet via its insert instance method. If the set already contains an element with the same hash value, this will merely increment the count associated with that element. Otherwise, insert will add the element to the set with an initial count of 1.

~~~{swift}
countedSet.insert(i)
~~~

#### Removing Elements From a CountedSet
Elements are removed from a CountedSet via its remove instance method, this method takes any valid element for the set as input, and returns an optional of the same type. If this method returns nil, the set didn't contain the specified element, otherwise, it did, and the count for that element is decremented.

Consider the following example, where the number 42 is inserted into the set twice. Remove is only called once with 42 as input, so 42 won't be removed from the set. Instead, it will have its associated count set to 1 and then 2 by the calls to insert, and then will have its count decremented back down to 1 by the remove call. Calling remove once more for 42 would remove it from the set.

~~~{swift}
var countedSet = CountedSet<Int>()
countedSet.insert(42)
countedSet.insert(42)
countedSet.remove(42)
~~~

#### Getting an Element's Count
The whole point of a CountedSet is that it keeps track of how many times each element has been added to it, which of course means that it provides facilities for accessing this information. In an attempt to keep naming conventions as similar as possible to those of [NSCountedSet](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSCountedSet_Class/#//apple_ref/occ/instm/NSCountedSet/countForObject:) (where possible), the count for a given element is found via its countForObject instance method.

~~~{swift}
var countedSet = CountedSet<Int>([1, 4, 4, 2, 2, 2])
let ones = countedSet.countForObject(1) // 1
let twos = countedSet.countForObject(2) // 3
let fours = countedSet.countForObject(4) // 2
~~~

#### Unions, Intersections, XORs & Subtractions
Since CountedSet is set, it provides many of the features you'd expect from one. These include methods for the creation of unions, intersections, XORs & subtractions. The only real difference between these, and their set equivalents is that they take the count of each object into consideration. For example, when taking the union of two sets, the resultant set will contain all of the elements from both input sets with the counts of each object equaling the sum of their previous two counts.

~~~{swift}
var countedSet1 = CountedSet<Int>([1, 1, 1, 2])
let countedSet2 = CountedSet<Int>([2, 2, 2, 3])

let union = countedSet1.union(countedSet2) // [1, 2, 3]
let ones = union.countForObject(1) // 3
let twos = union.countForObject(2) // 4
let threes = union.countForObject(3) // 1
~~~

#### Other Stuff

###### isEmpty
~~~{swift}
var countedSet = CountedSet<Int>()
countedSet.isEmpty // true
countedSet.insert(3)
countedSet.isEmpty // false
countedSet.remove(3)
countedSet.isEmpty // true
~~~

More documentation to come...

## License

The MIT License (MIT)

Copyright (c) 2015 Michael MacCallum

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
