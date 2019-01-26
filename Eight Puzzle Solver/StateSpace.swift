/*
    StateSpace.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.

    StateSpace is a representation of the problem state space.
 
 */

import Foundation

public class StateSpace {
    // Backing data structure
    private var list: [State]

    public let algorithm: Algorithm
    public var popped = [State]()

    
    init(with start: [Int], using algorithm: Algorithm) {
        self.algorithm = algorithm
        self.list = [State]()

        let startState = State(action: .down, currentState: start, depth: 0, parent: nil, tile: 0, using: algorithm)
        list.append(startState)
    }
   
    public func isEmpty() -> Bool {
        return list.count == 0
    }
    
    public func peek() -> State {
        switch algorithm {
        case .BreadthFirst:
            return list[0]
        case .DepthFirst:
            return list.last!
        default:
            return list.min()!
        }
    }

    public func pop() -> State {
        let toPop = peek()
        popped.append(toPop)
        
        switch algorithm {
        case .BreadthFirst:
            list.remove(at: 0)
        case .DepthFirst:
            list.remove(at: list.count - 1)
        default:
            let toRemove = list.firstIndex(where: { $0 === toPop })
            list.remove(at: toRemove!)
        }
        
        return toPop
    }
    
    public func push(state: State) {
        switch algorithm {
        case .DepthFirst:
            list.insert(state, at: 0)
        default:
            list.append(state)
        }
        stateCheck()
    }
    
    public func delete(state: State) {
        list.removeAll(where: { $0 === state })
    }
    
    // Checks if the a state with the same board layout exists in the list
    public func contains(state: State) -> Bool {
        return list.contains(where: { $0.equalTo(other: state) })
    }
    
    public func getDuplicates(of state: State) -> [State] {
        var duplicates = [State]()
        for node in list {
            if node.equalTo(other: state) {
                duplicates.append(node)
            }
        }
        return duplicates
    }

    private func stateCheck() {
        var equalStates: [State]
        for node in list {
            equalStates = getDuplicates(of: node)
            equalStates.append(node)
            let minimum = equalStates.min()!
            for equalState in equalStates {
                if equalState != minimum && equalState > minimum {
                    delete(state: equalState)
                }
            }
        }
    }
}
