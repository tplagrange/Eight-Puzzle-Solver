/*
    StateSpace.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.

    StateSpace is a representation of the problem state space. It is backed by PriorityQueue.
 
 */

import Foundation

public class StateSpace {
    private let root: State
    private let queue: PriorityQueue
    
    public var solved = false
    public var popped = [State]()
    
    init(with start: [Int], using algorithm: Algorithm) {
        self.root = State(action: .down, currentState: start, depth: 0, parent: nil, pathCost: 0)
        self.queue = PriorityQueue(start: root, using: algorithm)
    }
    
    public func getRoot() -> State {
        return root
    }
    
    public func pop() {
        // Returns the next node to expand
    }
    
    public func push(state: State) {
        stateCheck()
        queue.insert(node: state)
    }
    
    private func stateCheck() {
        // Need to iterate over queue for duplicates
        // Need to delete duplicates with higher cost
        debug(msg: "Checking State... again!")
    }
    
    private func stateCheck(for state: State) -> Bool {
        return queue.contains(state: state)
    }
}
