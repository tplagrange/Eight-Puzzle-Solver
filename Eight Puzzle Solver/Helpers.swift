//
//  Helpers.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//

import Foundation

/*
 Globally available functions and variables
 */

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
public let goal =   [1, 2, 3, 8, 0, 4, 7, 6, 5]
public let easy =   [ 1, 3, 4, 8, 6, 2, 7, 0, 5 ]
public let medium = [ 2, 8, 1, 0, 4, 3, 7, 6, 5 ]
public let hard =   [ 5, 6, 7, 4, 0, 8, 3, 2, 1 ]
