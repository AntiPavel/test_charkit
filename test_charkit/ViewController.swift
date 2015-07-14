//
//  ViewController.swift
//  test_charkit
//
//  Created by piton on 06.07.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameView: CKView!
    
    var hero: CKUnit?
    
    var units: [CKUnit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initScene()
    }

    func initScene() {
        
        let w = 30
        let h = 15
        
        units = []
        
        func rnd(max: Int) -> Int {
            return Int(arc4random_uniform(UInt32(max)))
        }
        
        func rndDirection() -> CKDirections {
            switch rnd(4) {
            case 0: return .Left
            case 1: return .Right
            case 2: return .Up
            default: return .Down
            }
        }
        
        func rndFish() -> Character {
            switch rnd(6) {
            case 0: return "🐠"
            case 1: return "🐡"
            case 2: return "🐳"
            case 3: return "🐟"
            case 4: return "🐬"
            default: return "🐙"
            }
        }
        
        for i in 0..<h {
            let u = CKUnit(view: rndFish(), position: CKPoint(w, i), speed: i + 1, direction: .Left)
            units.append(u)
        }
        
        let scene = CKScene(width: w, height: h)

        scene.units = units
        
        gameView.presentScene(scene)
        gameView.update()
    }
    
    @IBAction func heroChanged(sender: AnyObject) {
        
        let idx = (sender as! UISegmentedControl).selectedSegmentIndex
        hero = units[idx]
    }
    
    @IBAction func up(sender: AnyObject) {
        hero?.direction = .Up
    }

    @IBAction func right(sender: AnyObject) {
        hero?.direction = .Right
    }

    @IBAction func left(sender: AnyObject) {
        hero?.direction = .Left
    }

    @IBAction func down(sender: AnyObject) {
        hero?.direction = .Down
    }
    
    @IBAction func charChanged(sender: AnyObject) {

    }
    
    @IBAction func reset(sender: AnyObject) {
        initScene()
    }

    @IBAction func start(sender: AnyObject) {
        gameView.play()
    }

    @IBAction func pause(sender: AnyObject) {
        gameView.stop()
    }
}


