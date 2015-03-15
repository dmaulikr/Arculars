//
//  MenuScene.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var screenNode : SKSpriteNode!
    
    var playButton : Button!
    var statsButton : Button!
    var settingsButton : Button!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        
        screenNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        addChild(screenNode)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        initMenu()
    }
    
    func initMenu() {
        playButton = Button(position: CGPoint(x: 0, y: 90), color: Colors.Blue, image: "play", radius: 30)
        playButton.addTo(screenNode)
        
        statsButton = Button(position: CGPoint(x: 0, y: 0), color: Colors.Orange, image: "stats", radius: 30)
        statsButton.addTo(screenNode)
        
        settingsButton = Button(position: CGPoint(x: 0, y: -90), color: Colors.Red, image: "settings", radius: 30)
        settingsButton.addTo(screenNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(screenNode)
            
            if playButton.containsPoint(location) {
                
                var scene = GameScene(size: self.size)
                self.view?.presentScene(scene)
                
            } else if statsButton.containsPoint(location) {
                
            } else if settingsButton.containsPoint(location) {
                
            }
        }
    }
    
}