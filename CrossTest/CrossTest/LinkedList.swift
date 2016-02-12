//
//  LinkedList.swift
//  CrossTest
//
//  Created by Loreto Parisi on 11/02/16.
//  Copyright © 2016 Musixmatch. All rights reserved.
//

/**
 * Linked List
 * http://austinzheng.com/2015/01/24/swift-seq/
 */
class List<T> { }
final class LinkedList<T> : List<T> {
    let value : T
    let next : List<T>
    init(_ value: T, next: List<T>) {
        self.value = value
        self.next = next
    }
}
/**
 * List with nil element
 */
final class NilList<T> : List<T> { }

/**
 * List Generator
 Our ListGenerator is going to walk through the list, advancing one node every time its next() method is called. In order to keep track of this state, let’s add a property tracking the generator’s current position, currentNode.
 */
struct ListGenerator<T> : GeneratorType {
    var currentNode : List<T>
    
    init(head: List<T>) {
        currentNode = head
    }
    
    mutating func next() -> T? {
        switch currentNode {
        case let cons as LinkedList<T>:
            currentNode = cons.next
            return cons.value
        default:  // e.g. nil node
            return nil
        }
    }
}

/**
 *
 * Generate function
 The SequenceType protocol defines a single function: generate(), which takes no arguments and returns a Generator. Let’s go ahead and begin extending our List class
 */
extension List : SequenceType {
    func generate() -> ListGenerator<T> {
        return ListGenerator(head: self)
    }
}
