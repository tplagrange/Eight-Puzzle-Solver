/*
    StateSpace.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.

    StateSpace is a representation of the problem state space. It is backed by PriorityQueue.
 
 */

import Foundation

public class StateSpace {
    // Data Structure used for Breadth/Depth First
    private var list = [State]()
    // Data Sturcture used for all other algorithms
    private let queue: PriorityQueue

    public let algorithm: Algorithm
    public var popped = [State]()
    
    init(with start: [Int], using algorithm: Algorithm) {
        self.algorithm = algorithm
        self.queue = PriorityQueue(using: algorithm)
        let startState = State(action: .down, currentState: start, depth: 0, parent: nil, pathCost: 0)
        if (algorithm == .BreadthFirst || algorithm == .DepthFirst) {
            list.append(startState)
        } else {
            queue.insert(node: startState)
        }
    }
   
    public func isEmpty() -> Bool {
        if algorithm == .BreadthFirst || algorithm == .DepthFirst {
            return list.count == 0
        } else {
            return queue.isEmpty()
        }
    }
    
    public func peek() -> State {
        switch algorithm {
        case .BreadthFirst:
            return list[0]
        case .DepthFirst:
            return list[list.count - 1]
        default:
            return queue.getMin()
        }
    }

    public func pop() -> State {
        let toPop = peek()
        popped.append(toPop)
        switch algorithm {
        case .BreadthFirst:
            list.remove(at: 0)
            return toPop
        case .DepthFirst:
            list.remove(at: list.count - 1)
            return toPop
        default:
            return queue.deleteMin()
        }
    }
    
    public func push(state: State) {
        // How the new state is inserted depends on the algorithm
        switch algorithm { 
        case .BreadthFirst:
            list.append(state)
        case .DepthFirst:
            list.insert(state, at: 0)
        default:
            queue.insert(node: state)
        }
    }
    
    public func contains(state: State) -> Bool {
        if algorithm == .BreadthFirst || algorithm == .DepthFirst {
            return list.contains(where: { $0.equalTo(other: state) })
        } else {
            return queue.contains(state: state)
        }
    }

}
