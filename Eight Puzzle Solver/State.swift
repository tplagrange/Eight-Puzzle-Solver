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
    
    private let pathCost: Int
    
    init(action:Action, currentState: [Int], depth: Int, parent: State?, pathCost: Int) {
        self.action = action                // How did I get here
        self.flat = currentState            // Who am I
        self.depth = depth                  // How long have I been here
        self.parent = parent                // Where do I come from
        self.pathCost = pathCost            // What am I worth
    }
    
    // To-Do
    public func getCost(using algorithm: Algorithm) -> Int {
        switch algorithm {
        case .AStar1:
            return pathCost + heuristic1()
        case .AStar2:
            return pathCost + heuristic2()
        default:
            return pathCost
        }
    }
    
    // To-Do
    private func heuristic1() -> Int {
        // Number of incorrectly placed tiles
        return 0
    }
    
    // To-Do
    private func heuristic2() -> Int {
        // Sum of manhattan differences
        return 0
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
| | |
\(flat[3])--\(flat[4])--\(flat[5])
| | |
\(flat[6])--\(flat[7])--\(flat[8])
"""
    }
    
}
