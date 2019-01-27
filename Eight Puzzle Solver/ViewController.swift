//
//  ViewController.swift
//  Eight Puzzle Solver
//
//  Created by Lagrange, Thomas on 1/18/19.
//  Copyright © 2019 Thomas Lagrange. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var OutputText: NSTextView!
    @IBOutlet var AlgorithmMenu: NSPopUpButtonCell!
    @IBOutlet var DifficultyMenu: NSPopUpButtonCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func solvePuzzle(sender: NSButton) {
        let algorithmItem = AlgorithmMenu.selectedItem!.title
        let difficultyItem = AlgorithmMenu.selectedItem!.title
        
        var algorithm: Algorithm
        var difficulty: [Int]
        
        switch algorithmItem {
        case "Breadth First":
            algorithm = .BreadthFirst
        case "Depth First":
            algorithm = .DepthFirst
        case "Uniform Cost":
            algorithm = .UniformCost
        case "Best First":
            algorithm = .BestFirst
        case "A* One":
            algorithm = .AStar1
        case "A* Two":
            algorithm = .AStar2
        default:
            // alert
            return
        }
        
        switch difficultyItem {
        case "Easy":
            difficulty = easy
        case "Medium":
            difficulty = medium
        case "Hard":
            difficulty = hard
        default:
            // alert
            return
        }
        
        // A-Sync with 5 minute limit
        solve(puzzle: difficulty, with: algorithm)
    }

}


