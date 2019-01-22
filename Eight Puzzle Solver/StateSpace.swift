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
    private let algorithm: Algorithm
    
    public var solved = false
    public var popped = [State]()
    
    
    init(with start: [Int], using algorithm: Algorithm) {
        self.algorithm = algorithm
        self.queue = PriorityQueue(using: algorithm)
        let startState = State(action: .down, currentState: start, depth: 0, parent: nil, pathCost: 0)
        queue.insert(node: startState)
    }
   
    public func peek() -> State {
        switch algorithm {
        case .BreadthFirst:
            return list[list.count - 1]
        case .DepthFirst:
            return list[0]
        default:
            return queue.getMin()
        }
    }
    
    // To-Do
    public func pop() -> State {
        popped.append(peek())
        
        switch algorithm {
        case .BreadthFirst:
            return peek()
        case .DepthFirst:
            return peek()
        default:
            return peek()
        }
    
        return queue.deleteMin()
    }
    
    public func push(state: State) {
        switch algorithm {
        case .BreadthFirst:
            list.append(state)
        case .DepthFirst:
            list.insert(state, at: 0)
        default:
            queue.insert(node: state)
        }
        stateCheck(for: state)
    }
    
    // To-Do
    private func stateCheck(for state: State) {
        debug(msg: "RCS for \(state.flat)")
    }
}
