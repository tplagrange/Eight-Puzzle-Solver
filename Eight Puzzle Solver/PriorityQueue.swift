//
//  PriorityQueue.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//
//  Implementation of Priority Queue with a Min Heap

import Foundation

class PriorityQueue {
    private var array: [State]
    private var size: Int
    private let algorithm: Algorithm
    
    init(start: State, using algorithm: Algorithm) {
        self.size = 1
        self.array = [State]()
        self.algorithm = algorithm
        insert(node: start)
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
        heapify(at:size)
    }
    
    private func heapify(at index: Int) {
        return
    }
    
    private func compare(state node: State, to otherNode: State) -> Int {
        
        return 0
    }
    
    public func min() {
        // Returns lowest cost node, according to algorithm
    }
    
    public func delMin() -> State {
        // Returns and removes the lowest cost node
        // AKA Pop!
        swap(index: 0, and: size - 1)
        size -= 1
        return array.remove(at: size)
    }
    
    private func swap(index i: Int, and j: Int) {
        let swap = array[i]
        array[i] = array[j]
        array[j] = swap
    }
    
    private func delete(state: State) {
        //Delete the specified node
    }
    
    public func contains(state: State) -> Bool {
        // Check if another state with the same representation exists
        // If yes, delete (all) with highest costs
        return true
    }
}
