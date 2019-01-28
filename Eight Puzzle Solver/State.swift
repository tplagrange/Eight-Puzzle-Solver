/*
 State.swift
 Eight Puzzle Solver
 
 Created by Lagrange, Thomas on 1/18/19.
 Copyright © 2019 Thomas Lagrange. All rights reserved.
 */

import Foundation

/// State is a class that represents an 8-Puzzle state within the StateSpace class as a node.
public class State: Comparable {
    
    public let action: Action
    public let depth: Int
    public let parent: State?
    public let flat: [Int]
    
    private let tile: Int
    private let algorithm: Algorithm
    
    init(action:Action, currentState: [Int], depth: Int, parent: State?, tile: Int, using algorithm: Algorithm) {
        self.action = action                // The step taken to reach this state.
        self.flat = currentState            // A 1D array representation of the 8-Puzzle board.
        self.depth = depth                  // The depth in the search tree the agent encountered this state (root.depth == 0).
        self.parent = parent                // The parent node in the search tree.
        self.tile = tile                    // The number of the tile that was moved to reach the state.
        self.algorithm = algorithm          // The algorithm the agent used when encountering this state (important for determining the state cost)
    }
    
    /// First of two functions required to implement Comparable.
    /// lhs compares two states based on cost and returns true if the first of the two states is smaller
    ///
    /// - Parameters:
    ///   - lhs: The left operand State
    ///   - rhs: The right operand State
    /// - Returns: True if lhs is smaller than rhs
    public static func < (lhs: State, rhs: State) -> Bool {
        let algorithm = lhs.getAlgorithm()
        if algorithm != rhs.getAlgorithm() {
            debug(msg: "[ERROR] Comparable (<) encountered States using different algorithms!")
        }
        
        switch algorithm {
        case .BreadthFirst, .DepthFirst:
            return lhs.tile < rhs.tile
        default:
            return lhs.getCost(using: algorithm) < rhs.getCost(using: algorithm)
        }
    }
    
    /// Second of two functions required to implement Comparable.
    /// rhs returns true if both states have the same cost
    ///
    /// - Parameters:
    ///   - lhs: The left operand State
    ///   - rhs: The right operand State
    /// - Returns: True if both states have the same cost
    public static func == (lhs: State, rhs: State) -> Bool {
        let algorithm = lhs.getAlgorithm()
        if algorithm != rhs.getAlgorithm() {
            debug(msg: "[ERROR] Comparable (==) encountered States using different algorithms!")
        }
        
        switch algorithm {
        case .BreadthFirst, .DepthFirst:
            return lhs.tile == rhs.tile
        default:
            return lhs.getCost(using: algorithm) == rhs.getCost(using: algorithm)
        }
    }
    
    /// Compares two states based on their 1D representation of the 8-Puzzle board.
    ///
    /// - Parameter state: The other state to examine (the first being this state)
    /// - Returns: True if both states' 1D representation of the board is equivalent
    public func equalTo(other state: State) -> Bool {
        return flat.elementsEqual(state.flat)
    }
    
    /// Getter method for returning the algorithm the agent used to encounter this state.
    ///
    /// - Returns: The algorithm mentioned above.
    public func getAlgorithm() -> Algorithm {
        return algorithm
    }
    
    /// Returns the cost to the agent to reach this state. This of course depends on the algorithm used.
    ///
    /// - Parameter algorithm: The algorithm used by the agent to reach this state.
    /// - Returns: The cost to the agent to reach this state.
    public func getCost(using algorithm: Algorithm) -> Int {
        switch algorithm {
        case .UniformCost:
            return pathCost()
        case .BestFirst:
            return heuristic1()
        case .AStar1:
            return tile + heuristic1()
        case .AStar2:
            return tile + heuristic2()
        default:
            return tile
        }
    }

    /// Checks to see if the 1D representation of this state is equivalent to 1D representation of the goal state.
    ///
    /// - Returns: True iff equivalent to goal state.
    public func isGoal() -> Bool {
        if self.flat.elementsEqual(goal) {
            return true
        } else {
            return false
        }
    }

    /// Returns the cumulative cost of reaching this state from the starting state
    ///
    /// - Returns: The total cost for the agent to reach this state from the starting state.
    private func pathCost() -> Int {
        if parent == nil {
            return tile
        }
        var cost = tile
        var state = parent!
        while state.parent != nil {
            cost += state.tile
            state = state.parent!
        }
        cost += state.tile
        return cost
    }
    
    /// Calculates the number of misplaced tiles on this State's board as a heuristic to use in a search algorithm
    ///
    /// - Returns: Number of misplaced tiles on the board as compared to the goal State.
    private func heuristic1() -> Int {
        var index = 0
        var misplacedTiles = 0
        for tile in flat {
            if tile != goal[index] {
                misplacedTiles += 1
            }
            index += 1
        }
        return misplacedTiles
    }
    
    /// Calculates the sum of the manhattan distances for the misplaced tiles on the board.
    ///
    /// - Returns: The sum of the manhattan distances for each misplaced tile on the board.
    private func heuristic2() -> Int {
        var index = 0
        var manhattanDistances = 0
        for tile in flat {
            if tile != goal[index] {
                let squareEdgeSize = Int(Double(squares).squareRoot())
                
                let row = index / squareEdgeSize
                let col = index % squareEdgeSize
                
                let correctIndex = goal.firstIndex(of: tile)
                let correctRow = correctIndex! / squareEdgeSize
                let correctCol = correctIndex! % squareEdgeSize
                
                let x = abs(correctRow - row)
                let y = abs(correctCol - col)
                
                let manhattanDistance = x + y
                
                manhattanDistances += manhattanDistance
            }
            index += 1
        }
        return manhattanDistances
    }
    
    /// Helper function which returns which index in the 1D representation of the board holds the blank slot.
    ///
    /// - Returns: The index of the blank slot in the 1D representation of the board.
    public func blankIndex() -> Int {
        for i in 0..<squares {
            if flat[i] == 0 {
                return i
            }
        }
        // No blank slot in puzzle; return error
        return -1
    }
    
    /// Helper function to display the 1D representation of the board as a 3x3 8-Puzzle.
    ///
    /// - Returns: A string containing end-user friendly representation of the State.
    public func toString() -> String {
        return
"""
\(flat[0]) \(flat[1]) \(flat[2])
\(flat[3]) \(flat[4]) \(flat[5])
\(flat[6]) \(flat[7]) \(flat[8])
"""
    }
    
}
