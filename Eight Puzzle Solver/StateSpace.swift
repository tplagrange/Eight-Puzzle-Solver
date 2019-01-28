/*
    StateSpace.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.
 
 */

import Foundation

/// A representation of the State Space that has or will be expanded by the agent.
public class StateSpace {
    // Backing data structure
    private var queue: [State]
    private var queueMaxSize = 1
    
    public let algorithm: Algorithm
    public var popped = [State]()

    
    init(with start: [Int], using algorithm: Algorithm) {
        self.algorithm = algorithm // The algorithm used by the agent within this state space.
        self.queue = [State]()      // The backing data structure used by the agent.
        
        // Instantiate the State Space with the starting State.
        let startState = State(action: .down, currentState: start, depth: 0, parent: nil, tile: 0, using: algorithm)
        queue.append(startState)
    }
   
    /// Helper function to determine if the state space has no more states, which would be an error.
    ///
    /// - Returns: True iff the backing data structure for the state space is empty.
    public func isEmpty() -> Bool {
        return queue.isEmpty
    }
    
    /// Function to determine the correct State to expand next depending on the algorithm used.
    ///
    /// - Returns: The next state for the agent to expand.
    public func peek() -> State {
        switch algorithm {
        case .BreadthFirst:
            return queue[0]
        case .DepthFirst:
            return queue.last!
        default:
            return queue.first!
        }
    }

    /// Function used to remove a State in the backing data structure depending on the algorithm used.
    /// Also adds the State returned by peek() to an array holding the States that have been 'popped'
    ///
    /// - Returns: The State returned by peek()
    public func pop() -> State {
        let toPop = peek()
        popped.append(toPop)
        
        switch algorithm {
        case .BreadthFirst:
            queue.remove(at: 0)
        case .DepthFirst:
            queue.remove(at: queue.count - 1)
        default:
            queue.swapAt(0, queue.count - 1)
            queue.remove(at: queue.count - 1)
            if !isEmpty() {
                sink(from: 0)
            }
        }
        updateMaxSize()
        
        return toPop
    }
    
    /// Function to add a State to the backing data structure in the correct position depending on algorithm used.
    ///
    /// - Parameter state: The State to add to the State Space.
    public func push(state: State) {
        switch algorithm {
        case .BreadthFirst:
            queue.append(state)
        case .DepthFirst:
            queue.insert(state, at: 0)
        default:
            queue.append(state)
            swim(from: queue.count - 1)
        }
        stateCheck()
        updateMaxSize()
    }
    
    /// Deletes the given State from the State Space's backing data structure.
    ///
    /// - Parameter state: The State to delete from the backing data structure.
    public func delete(state: State) {
        if isEmpty() {
            return
        }
        let indexToDelete = queue.index(where: { $0 === state })!
        if indexToDelete == queue.count - 1 {
            queue.remove(at: queue.count - 1)
        } else {
            queue.swapAt(indexToDelete, queue.count - 1)
            queue.remove(at: queue.count - 1)
            let replacementIndex = indexToDelete
            if firstIsLess(first: replacementIndex, second: parent(of: replacementIndex)) {
                swim(from: replacementIndex)
            } else {
                sink(from: replacementIndex)
            }
        }
        
        updateMaxSize()
    }
    
    /// Checks if the State Space has an array with an identical 1D representation of the board.
    ///
    /// - Parameter state: The State to compare to the State Space.
    /// - Returns: True iff a State already exists in the State Space with the same board layout.
    public func contains(state: State) -> Bool {
        return queue.contains(where: { $0.equalTo(other: state) })
    }
    
    /// Collects all the States within the State Space with identical 1D representation of the board.
    /// Used as a helper function for repeates state checking.
    ///
    /// - Parameter state: The State which may contain duplicates within the State Space.
    /// - Returns: An array of size >= 0 with the duplicate States
    public func getDuplicates(of state: State) -> [State] {
        var duplicates = [State]()
        for node in queue {
            if node === state {
                continue
            } else if node.equalTo(other: state) {
                duplicates.append(node)
            }
        }
        return duplicates
    }

    /// A repeated state checking function which ensures that when duplicates are present, only the lowest cost duplicate remains in the State Space.
    private func stateCheck() {
        var index = 0
        while (index < queue.count) {
            let node = queue[index]
            var equalStates = getDuplicates(of: node)
            equalStates.append(node)
            let minimum = equalStates.min()!
            for equalState in equalStates {
                if equalState > minimum {
                    delete(state: equalState)
                }
            }
            index += 1
        }
    }
    
    /// Helper function to determine the numer of nodes popped off the queue.
    ///
    /// - Returns: Size of popped array
    public func numPopped() -> Int {
        return popped.count
    }
    
    /// Helper function to determine the space cost of the agent's solution
    ///
    /// - Returns: The size of the queue at it's max
    public func getMaxSize() -> Int {
        return queueMaxSize
    }
    
    /// Helper function to maintain the maximum size of the queue.
    private func updateMaxSize() {
        if queueMaxSize < queue.count {
            queueMaxSize = queue.count
        }
    }
    
    ///
    /// The following are functions that extend the queue's funcitonality to that of a min-heap
    ///
    
    /// Checks if the given index is the root of the heap
    ///
    /// - Parameter index: Index to check
    /// - Returns: True iff the index is 0
    private func isRoot(index: Int) -> Bool {
        return index == 0
    }
    
    /// Calculates the theoretical index of the left child
    ///
    /// - Parameter index: Parent index
    /// - Returns: The theoretical index of the parent's left child
    private func leftChild(from parentIndex: Int) -> Int {
        return (2 * parentIndex) + 1
    }
 
    /// Calculates the theoretical index of the right child
    ///
    /// - Parameter index: Parent index
    /// - Returns: The theoretical index of the parent's right child
    private func rightChild(from parentIndex: Int) -> Int {
        return (2 * parentIndex) + 2
    }
    
    /// Calculates the index of the elements parent in the heap
    ///
    /// - Parameter index: Child to find the parent of.
    /// - Returns: The index of the child's parent in the heap.
    private func parent(of index: Int) -> Int {
        return (index - 1) / 2
    }
    
    /// A function that ensures that the element at the first index passed is less than the element at the second index passed.
    ///
    /// - Parameters:
    ///   - indexOne: The index of the first element.
    ///   - indexTwo: The index of the second element.
    /// - Returns: True iff the first index is smaller than the second element.
    private func firstIsLess(first indexOne: Int, second indexTwo: Int) -> Bool {
        return queue[indexOne] < queue[indexTwo]
    }
    
    /// A function to calculate which index of the two passed has an element at that position which is minimum.
    ///
    /// - Parameters:
    ///   - parentIndex: The parent index to check
    ///   - childIndex: The child index to check
    /// - Returns: The index who's position holds the State with the lowest cost.
    private func minIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        if childIndex < queue.count && firstIsLess(first: childIndex, second: parentIndex) {
            return childIndex
        } else {
            return parentIndex
        }
    }
    
    /// Determines which child of the parent holds the minimum value.
    ///
    /// - Parameter parentIndex: Parent to check
    /// - Returns: The index of the child element with the minimum value (or the parent index if it's minimum).
    private func minChild(of parentIndex: Int) -> Int {
        return minIndex(of:
                minIndex(of: parentIndex, and: leftChild(from: parentIndex)),
                and: rightChild(from: parentIndex))
    }
    
    private func sink(from index: Int) {
        let childIndex = minChild(of: index)
        if index == childIndex {
            return
        } else {
            queue.swapAt(index, childIndex)
            sink(from: childIndex)
        }
    }
    
    private func swim(from index: Int) {
        let parentIndex = parent(of: index)
        if (isRoot(index: index)) {
            return
        } else if firstIsLess(first: parentIndex, second: index) {
            return
        }
        queue.swapAt(index, parentIndex)
        swim(from: parentIndex)
    }
}
