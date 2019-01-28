//
//  PuzzleSolver.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//

import Foundation
import Cocoa

/// Attempts to solve the 8-Puzzle with parameters selected from the GUI.
///
/// - Parameters:
///   - initialState: The puzzle before any moves are made by the agent as represented by a 1D array.
///   - algorithm: The algorithm the agent will use to attempt to solve the puzzle.
///   - textView: The NSTextView element that will output the solution to the user.
public func solve(puzzle initialState: [Int], with algorithm: Algorithm, outputTo textView: NSTextView) {
    // Instantiate the state space with our first state
    let stateSpace = StateSpace(with: initialState, using: algorithm)
    
    // Counter variable to track the number of states the agent has expanded.
    var statesExpanded = 0

    while (true) {
        // Error out if we have an empty state space, this means the agent could not find a goal path.
        if stateSpace.isEmpty() {
            textView.string = "The agent encountered an empty state space, this means it was unable to solve the given puzzle."
            return
        }
        
        // Pop the next state from the state space
        let nextState = stateSpace.pop()
        statesExpanded += 1
        
        // Check for goal state
        if nextState.isGoal() {
            textView.string = "Goal state found!\n"
            textView.string.append("Length: \(nextState.depth)\n")
            textView.string.append("Time: \(stateSpace.numPopped())\n")
            textView.string.append("Space: \(stateSpace.getMaxSize())\n\n")
            outputGoal(from: nextState, into: textView)
            return
        }
        
        // Expand the state
        let successors = successor(of: nextState, in: stateSpace)
        
        // Add the states to our state space iff they are not already there and haven't been expanded
        for successor in successors {
            if stateSpace.popped.contains(where: { $0.equalTo(other: successor) }) {
                continue
            } else if stateSpace.contains(state: successor) {
                if algorithm == .BreadthFirst || algorithm == .DepthFirst {
                    continue
                } else {
                    // If the agent is using an algorithm that compares cost, push it and worry about state checking after pushing
                    stateSpace.push(state: successor)
                }
            } else {
                // The state has not been encountered before, add it to our state space
                stateSpace.push(state: successor)
            }
        }
    }
}

/// Retrieve all legal states taken from expanded the state passed to the function.
///
/// - Parameters:
///   - previousState: The state to expand.
///   - stateSpace: The state space within which the agent is attempting to find a solution.
/// - Returns: An array containing the legal moves starting from 'previousState'.
private func successor(of previousState: State, in stateSpace: StateSpace) -> [State] {
    var successors = [State]()
    
    // Determine which tile is blank
    let blank = previousState.blankIndex()
    
    // Layout the space as a square to determine the next legal moves
    let squareEdgeSize = Int(Double(squares).squareRoot())
    
    // Determine the position of the blank in the square
    let row = blank / squareEdgeSize
    let col = blank % squareEdgeSize
    
    // Determine which moves can be made from the blank (imagined as the blank is moving)
    var legalMoves = [Action]()
    
    // Assess the outcome of each of the 4 theoretically possible moves
    for theoreticalMove in theoreticalMoves {
        var newRow: Int
        var newCol: Int
        
        switch theoreticalMove {
        case .up:
            newRow = row - 1
            newCol = col
            // If the theoretical move still places the blank within the square, the agent classifies it as a legal move.
            if newRow >= 0 {
                legalMoves.append(theoreticalMove)
            }
        case .right:
            newRow = row
            newCol = col + 1
            if newCol < squareEdgeSize {
                legalMoves.append(theoreticalMove)
            }
        case .down:
            newRow = row + 1
            newCol = col
            if newRow < squareEdgeSize {
                legalMoves.append(theoreticalMove)
            }
        case .left:
            newRow = row
            newCol = col - 1
            if newCol >= 0 {
                legalMoves.append(theoreticalMove)
            }
        }
    }
    
    // The agent has now determined which moves are legal; stored in the array "legalMoves"

    // The agent must now create new states for each legal move
    for legalMove in legalMoves {
        let tile: Int // The numbered tile that will be moved
        
        // First we will create a duplicate representation of the existing state
        var newRepresentation = [Int](repeating: 0, count: squares)
        for i in 0..<squares {
            newRepresentation[i] = previousState.flat[i]
        }
        
        // Create a new state depending on the move
        switch legalMove {
        case .up:
            // The tile to be moved is not the same as the blank tile, so this calculates the tile that will be moved
            tile = previousState.flat[(row-1) * 3 + col]
            // Assign the value of the tile to the position where the blank was
            newRepresentation[row * 3 + col] = tile
            // Assign the old position of the tile to be blank
            newRepresentation[(row-1) * 3 + col] = 0
        case .right:
            tile = previousState.flat[row * 3 + col + 1]
            newRepresentation[row * 3 + col] = tile
            newRepresentation[row * 3 + col + 1] = 0
        case .down:
            tile = previousState.flat[(row+1) * 3 + col]
            newRepresentation[row * 3 + col] = tile
            newRepresentation[(row+1) * 3 + col] = 0
        case .left:
            tile = previousState.flat[row * 3 + col - 1]
            newRepresentation[row * 3 + col] = tile
            newRepresentation[row * 3 + col - 1] = 0
        }
        
        // Instantiate new state using generated parameters
        let newState = State(action: legalMove, currentState: newRepresentation, depth: previousState.depth + 1, parent: previousState, tile: tile, using: stateSpace.algorithm)
        
        successors.append(newState)
    }
    
    return successors
}

/// GUI Helper which outputs a path to the goal state. No logic towards solving the puzzle is placed here.
///
/// - Parameters:
///   - state: The state which was found to match the goal state by the agent.
///   - textView: The NSTextView object that will store the outputted solution.
private func outputGoal(from state: State, into textView: NSTextView) {
    var currentState = state
    var goalPath = [State]()
    // Work our way up back to the starting state
    while currentState.parent != nil {
        goalPath.insert(currentState, at: 0)
        currentState = currentState.parent!
    }
    // Ensure the starting state is accounted for (the loop will not encounter the start state since it's parent value is nil)
    goalPath.insert(currentState, at: 0)
    var totalCost = 0
    // Stepping through the collected path from the start state
    for goalStep in goalPath {
        // Calculate the value of the step depending on the algorithm used
        let stepCost = goalStep.getCost(using: goalStep.getAlgorithm())
        // Increment the total cost
        totalCost += stepCost
        if (goalStep.depth == 0){
            // GUI formatting for the start state
            textView.string.append("Start:\n")
            textView.string.append("\n\(goalStep.toString())\n\n")
        } else {
            // GUI formatting for the other states
            textView.string.append("\(goalStep.action), cost = \(stepCost), total cost = \(totalCost)")
            textView.string.append("\n\n\(goalStep.toString())\n\n")
        }
    }
    textView.string.append("Goal path found with cost of: \(totalCost)\n") // Cost of solution path
}
