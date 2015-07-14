//
//  Game.swift
//  test_charkit
//
//  Created by piton on 07.07.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

typealias CKScene = CharKit.Scene
//typealias CKView = CharKit.View
typealias CKPoint = CharKit.Point
typealias CKDirections = CharKit.Directions
typealias CKUnit = CharKit.Unit

// MARK: - Helper

func +=(inout point: CKPoint, direction: CKDirections) {

    switch direction {
    case .Left:  point.x--
    case .Right: point.x++
    case .Up:    point.y--
    case .Down:  point.y++
    }
}

func +=(inout str: String, char: Character) {
    str += String(char)
}

// MARK: -

struct CharKit {
    
    struct Point {
        var x: Int
        var y: Int
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }

    enum Directions {
        case Left, Right, Up, Down
       
        mutating func invert() {
            switch self {
            case .Left:  self = .Right
            case .Right: self = .Left
            case .Up:    self = .Down
            case .Down:  self = .Up
            }
        }
    }
    
    class Unit {
        
        var position: Point
        var view: Character
        var direction: Directions?
        var speed: Int
        
        init(view: Character, position: Point, speed: Int = 0, direction: Directions? = nil) {
            self.view = view
            self.position = position
            self.speed = speed
            self.direction = direction
        }
    }
    
    class Scene {
        
        let (width, height): (Int, Int)
        let background: String
        
        var units: [Unit] = []
        
        var places = 0
        
        init(width: Int, height: Int, background: String = "....") {
            self.width = width
            self.height = height
            self.background = background
        }
        
        var view: String {
            
            var res = ""
            
            for i in 0..<height {
                for j in 0..<width {
                    if let find = units.filter( {
                        $0.position.y == i && $0.position.x == j
                    } ).first {
                        res += find.view
                    } else {
                        res += background
                    }
                }
                res += "\n"
            }

            return res
        }
        
        func update(time: Int) {
            
            func check(position pos: Point) -> Bool {
                return (0..<width ~= pos.x) && (0..<height ~= pos.y)
            }
            
            for unit in units {
                
                if !(unit.speed > 0 && time % unit.speed == 0) {
                    continue
                }
                
                if var direction = unit.direction {
                    
                    var pos = unit.position
                    pos += direction
                    
                    if !check(position: pos) {
                        direction.invert()
                        unit.position += direction
                    } else {
                        unit.position = pos
                    }
                    
                    unit.direction = direction
                }
                
            }
        }
    }
}

class CKView: UITextView {
    
    var scene: CKScene?
    
    private var cnt = 0
    
    private var timer: NSTimer? {
        willSet{
            stop()
        }
    }
    
//    override func didMoveToSuperview() {        
//        play()
//    }
    
    func play() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.08, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func update() {
        scene?.update(cnt++)
        text = scene?.view ?? ""
    }
    
    func presentScene(scene: CKScene) {
        cnt = 0
        self.scene = scene
    }
    
    deinit {
        stop()
    }
}




