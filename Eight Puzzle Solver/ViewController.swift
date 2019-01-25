//
//  ViewController.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let easy = [ 1, 3, 4, 8, 6, 2, 7, 0, 5]

        solve(puzzle: easy, with: .BreadthFirst)
        solve(puzzle: easy, with: .DepthFirst)
        solve(puzzle: easy, with: .UniformCost)
        solve(puzzle: easy, with: .AStar1)
        solve(puzzle: easy, with: .AStar2)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}



