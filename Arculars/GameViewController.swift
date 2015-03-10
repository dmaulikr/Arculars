//
//  GameViewController.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        skView.showsPhysics = true
        skView.showsFPS = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        var circles : [Circle] =
            [
                Circle(color: Colors.Blue, radius: 100.0, thickness: 40.0),
                Circle(color: Colors.Orange, radius: 50.0, thickness: 25.0),
                Circle(color: Colors.Red, radius: 20.0, thickness: 15.0)
            ]
        scene.createCircles(circles)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
