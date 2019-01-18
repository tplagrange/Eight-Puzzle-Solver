/*
    EightPuzzleSolver.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.

    This file contains the main operations for solving the eight puzzle.
    Functions within this file are called from ViewController which are in turn called by the GUI.
 */

import Foundation

// Debug function
public func debug(msg: String) {
    if debugSetting {
        print(msg)
    }
}

// Simple enumeration of the available actions
public enum Action {
    case up
    case right
    case down
    case left
}

// Enumeration of available algorithms
public enum Algorithm {
    case BreadthFirst
    case DepthFirst
    case UniformCost
    case BestFirst  // h = # of tiles that are not in correct position
    case AStar1     // h = # of tiles that are not in correct position
    case AStar2     // h = sum of Manhattan distances between all tiles and their correct positions
}

// Globally available variables
public let squares = 9      // The number of squares in our puzzle
public let theoreticalMoves = [Action.up, Action.right, Action.down, Action.left]
public let debugSetting = true
public let goal = [1, 2, 3, 8, 0, 4, 7, 6, 5]

// Initiate attempt to find solution
public func solve(puzzle initialState: [Int], with algorithm: Algorithm) {
    let stateSpace = StateSpace(with: initialState, using: algorithm)
    
    // Add 5 minute limit to execution of this function
    while (!stateSpace.solved) {
        stateSpace.successor(of: nil)
    }
}
