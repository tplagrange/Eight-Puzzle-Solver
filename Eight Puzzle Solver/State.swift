/*
 State.swift
 Eight Puzzle Solver
 
 Created by Lagrange, Thomas on 1/18/19.
 Copyright © 2019 Thomas Lagrange. All rights reserved.
 
 State is a class that represents a state within the State Space as a node.
 */

import Foundation

public class State {
    public var action: Action
    public var depth: Int
    public var parent: State?
    public var pathCost: Int
    public var representation: [Int]
    
    init(action:Action, currentState: [Int], depth: Int, parent: State?, pathCost: Int) {
        self.action = action
        self.representation = currentState
        self.depth = depth
        self.parent = parent
        self.pathCost = pathCost
    }
    
    public func blankIndex() -> Int {
        for i in 0..<squares {
            if representation[i] == 0 {
                return i
            }
        }
        // No blank slot in puzzle; return error
        return -1
    }
    
}
