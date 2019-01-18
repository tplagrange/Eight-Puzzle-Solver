/*
    StateSpace.swift
    Eight Puzzle Solver

    Created by Lagrange, Thomas on 1/18/19.
    Copyright © 2019 Thomas Lagrange. All rights reserved.

    StateSpace is an implementation of a min-heap designed to return the item with the lowest value
    This value is determined by the search algorithm being used to navigate the state space.
 
    Root of the heap will always be the starting state, because the cost of getting from start -> start is 0
 */

import Foundation

public class StateSpace {
    private let algorithm: Algorithm
    private let root: State
//    private let queue: PriorityQueue
    
    public var solved = false
    
    init(with start: [Int], using algorithm: Algorithm) {
        self.root = State(action: .down, currentState: start, depth: 0, parent: nil, pathCost: 0)
        self.algorithm = algorithm
    }
    
    public func successor(of state:State?) {
        // If the passed state is nil; we're at the root
        let previousState: State
        if (state == nil) {
            previousState = root
        } else {
            previousState = state!
        }
        
        // Determine which square is blank
        let blank = previousState.blankIndex()
        debug(msg: "Blank index set to \(blank)")
        
        // Layout the space as a square to determine the next legal moves
        let squareEdgeSize = Int(Double(squares).squareRoot())
        debug(msg: "Square edge was set to \(squareEdgeSize)")

        // Determine the position of the blank in the square
        let row = blank / squareEdgeSize
        let col = blank % squareEdgeSize
        debug(msg: "Blank is at \(row),\(col)")
        
        // Determine which moves can be made from the blank (imagined as the blank is moving)
        var legalMoves = [Action]()
        
        for theoreticalMove in theoreticalMoves {
            var newRow: Int
            var newCol: Int

            // Check against theoretical moves
            switch theoreticalMove {
            case .up:
                newRow = row - 1
                newCol = col
                if newRow >= 0 {
                    legalMoves.append(theoreticalMove)
                    debug(msg: "We can move up")
                }
            case .right:
                newRow = row
                newCol = col + 1
                if newCol < squareEdgeSize {
                    legalMoves.append(theoreticalMove)
                    debug(msg: "We can move right")
                }
            case .down:
                newRow = row + 1
                newCol = col
                if newRow < squareEdgeSize {
                    legalMoves.append(theoreticalMove)
                    debug(msg: "We can move down")
                }
            case .left:
                newRow = row
                newCol = col - 1
                if newCol >= 0 {
                    legalMoves.append(theoreticalMove)
                    debug(msg: "We can move left")
                }
            }
        }
        
        // The program has now determined which moves are legal; stored in the array "legalMoves"
        // The program must now create new states for each legal move
        
        for legalMove in legalMoves {
            let tile: Int // The numbered tile that will be moved
            
            // First we will create a duplicate representation of the state
            var newRepresentation = [Int](repeating: 0, count: squares)
            for i in 0..<squares {
                newRepresentation[i] = previousState.representation[i]
            }
            
            // Create a new state depending on the move
            switch legalMove {
            case .up:
                tile = previousState.representation[(row-1) * 3 + col]
                newRepresentation[row * 3 + col] = tile
                newRepresentation[(row-1) * 3 + col] = 0
            case .right:
                tile = previousState.representation[row * 3 + col + 1]
                newRepresentation[row * 3 + col] = tile
                newRepresentation[row * 3 + col + 1] = 0
            case .down:
                tile = previousState.representation[(row+1) * 3 + col]
                newRepresentation[row * 3 + col] = tile
                newRepresentation[(row+1) * 3 + col] = 0
            case .left:
                tile = previousState.representation[row * 3 + col - 1]
                newRepresentation[row * 3 + col] = tile
                newRepresentation[row * 3 + col - 1] = 0
            }
            
            // Instantiate new state using generated parameters
            let newState = State(action: legalMove, currentState: newRepresentation, depth: previousState.depth + 1, parent: previousState, pathCost: previousState.pathCost + tile)
            
            push(state: newState)
        }
    }
    
    private func push(state: State) {
        stateCheck()
        solved = true
    }
    
    private func stateCheck() {
        debug(msg: "Checking State... again!")
    }
}
