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
    private var list: [State]
    
    public let algorithm: Algorithm
    public var popped = [State]()

    
    init(with start: [Int], using algorithm: Algorithm) {
        self.algorithm = algorithm // The algorithm used by the agent within this state space.
        self.list = [State]()      // The backing data structure used by the agent.
        
        // Instantiate the State Space with the starting State.
        let startState = State(action: .down, currentState: start, depth: 0, parent: nil, tile: 0, using: algorithm)
        list.append(startState)
    }
   
    /// Helper function to determine if the state space has no more states, which would be an error.
    ///
    /// - Returns: True iff the backing data structure for the state space is empty.
    public func isEmpty() -> Bool {
        return list.count == 0
    }
    
    /// Function to determine the correct State to expand next depending on the algorithm used.
    ///
    /// - Returns: The next state for the agent to expand.
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

    /// Function used to remove a State in the backing data structure depending on the algorithm used.
    /// Also adds the State returned by peek() to an array holding the States that have been 'popped'
    ///
    /// - Returns: The State returned by peek()
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
    
    /// Function to add a State to the backing data structure in the correct position depending on algorithm used.
    ///
    /// - Parameter state: The State to add to the State Space.
    public func push(state: State) {
        switch algorithm {
        case .DepthFirst:
            list.insert(state, at: 0)
        default:
            list.append(state)
        }
        stateCheck()
    }
    
    /// Deletes the given State from the State Space's backing data structure.
    ///
    /// - Parameter state: The State to delete from the backing data structure.
    public func delete(state: State) {
        list.removeAll(where: { $0 === state })
    }
    
    /// Checks if the State Space has an array with an identical 1D representation of the board.
    ///
    /// - Parameter state: The State to compare to the State Space.
    /// - Returns: True iff a State already exists in the State Space with the same board layout.
    public func contains(state: State) -> Bool {
        return list.contains(where: { $0.equalTo(other: state) })
    }
    
    /// Collects all the States within the State Space with identical 1D representation of the board.
    /// Used as a helper function for repeates state checking.
    ///
    /// - Parameter state: The State which may contain duplicates within the State Space.
    /// - Returns: An array of size >= 0 with the duplicate States
    public func getDuplicates(of state: State) -> [State] {
        var duplicates = [State]()
        for node in list {
            if node.equalTo(other: state) {
                duplicates.append(node)
            }
        }
        return duplicates
    }

    /// A repeated state checking function which ensures that when duplicates are present, only the lowest cost duplicate remains in the State Space.
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
