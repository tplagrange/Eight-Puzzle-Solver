/*
 State.swift
 Eight Puzzle Solver
 
 Created by Lagrange, Thomas on 1/18/19.
 Copyright © 2019 Thomas Lagrange. All rights reserved.
 
 State is a class that represents a state within the State Space as a node.
 */

import Foundation

public class State {
    public let action: Action
    public let depth: Int
    public let parent: State?
    public let flat: [Int]
    
    private let tile: Int
    
    init(action:Action, currentState: [Int], depth: Int, parent: State?, tile: Int) {
        self.action = action                // How did I get here
        self.flat = currentState            // Who am I
        self.depth = depth                  // How long have I been here
        self.parent = parent                // Where do I come from
        self.tile = tile                    // What am I worth
    }
    
    // To-Do
    public func getCost(using algorithm: Algorithm) -> Int {
        switch algorithm {
        case .UniformCost:
            return pathCost()
        case .BestFirst:
            return heuristic1()
        case .AStar1:
            return pathCost() + heuristic1()
        case .AStar2:
            return pathCost() + heuristic2()
        default:
            return tile
        }
    }

    public func isGoal() -> Bool {
        if self.flat.elementsEqual(goal) {
            return true
        } else {
            return false
        }
    }
    
    public func equalTo(other state: State) -> Bool {
        return flat.elementsEqual(state.flat)
    }

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
//        debug(msg: "\(cost)")
        return cost
    }
    
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
    
    // To-Do
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
    
    public func blankIndex() -> Int {
        for i in 0..<squares {
            if flat[i] == 0 {
                return i
            }
        }
        // No blank slot in puzzle; return error
        return -1
    }
    
    public func toString() -> String {
        return
"""
\(flat[0])--\(flat[1])--\(flat[2])
|  |  |
\(flat[3])--\(flat[4])--\(flat[5])
|  |  |
\(flat[6])--\(flat[7])--\(flat[8])
"""
    }
    
}
