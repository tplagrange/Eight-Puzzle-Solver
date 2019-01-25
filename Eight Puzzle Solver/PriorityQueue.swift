//
//  PriorityQueue.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//
//  Implementation of Priority Queue with a Binary Min Heap

import Foundation

class PriorityQueue {
    private var array: [State]
    private var size: Int
    private let algorithm: Algorithm
    
    init(using algorithm: Algorithm) {
        self.algorithm = algorithm
        self.array = [State]()
        self.size = 0
        // Inserting trivial state at index 0; binary heap operations assume array indices >= 1
        array.append(State(action: .up, currentState: [1,2,3,8,0,4,7,6,5], depth: 0, parent: nil, pathCost: -1))
    }
    
    public func isEmpty() -> Bool {
        return size == 0
    }
    
    public func getSize() -> Int {
        return size;
    }
    
    public func insert(node: State) {
        array.append(node)
        size += 1
        heapify(at: size)
    }
    
    public func getMin() -> State {
        // Returns lowest cost node, according to algorithm
        return array[1]
    }
    
    public func deleteMin() -> State {
        // Returns and removes the lowest cost node
        // AKA Pop!
        let min = self.getMin()
        swap(index: 1, and: size)
        size -= 1
        heapify(at: 1)
        return min
    }
    
    public func delete(this state: State) {
        var index = 1
        for node in array {
            if node === state {
//                debug(msg: "Deleting: \(node.flat)")
                swap(index: index, and: size)
                size -= 1
                heapify(at: index)
                return
            }
            index += 1
        }
//        debug(msg: "State to delete not found.")
    }
    
    public func contains(state: State) -> Bool {
        return array.contains(where: { $0.equalTo(other: state) })
    }
   
    private func heapify(at index: Int) {
        // First let's check that parent/child relationship is appropriate
        var percolate = index
        while percolate > 1 && compare(index: percolate/2, and: percolate) {
            swap(index: percolate, and: percolate/2)
            percolate /= 2
        }
        
        // Also check that sibling relationship is appropriate
        var trickle = index
        while 2 * trickle <= size {
            var leftChild = 2 * trickle
            if leftChild < size && compare(index: leftChild, and: leftChild + 1) {
                leftChild += 1
            }
            if !compare(index: trickle, and: leftChild) {
                break
            }
            swap(index: trickle, and: leftChild)
            trickle = leftChild
        }
    }
    
    private func compare(index i: Int, and j: Int) -> Bool {
        return array[i].getCost(using: algorithm) > array[j].getCost(using: algorithm)
    }
    
    private func swap(index i: Int, and j: Int) {
        let swap = array[i]
        array[i] = array[j]
        array[j] = swap
    }
}
