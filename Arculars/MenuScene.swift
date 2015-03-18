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
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var playButton : Button!
    private var statsButton : Button!
    private var settingsButton : Button!
    
    override func didMoveToView(view: SKView) {
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Init Top Level Nodes
        self.addChild(rootNode)
        
        // Init Menu
        playButton = Button(position: CGPoint(x: 0, y: 90), color: Colors.Blue, content: SKSpriteNode(imageNamed: "play"), radius: 30)
        rootNode.addChild(playButton.fadeIn())
        
        statsButton = Button(position: CGPoint(x: 0, y: 0), color: Colors.Orange, content: SKSpriteNode(imageNamed: "stats"), radius: 30)
        rootNode.addChild(statsButton.fadeIn())
        
        settingsButton = Button(position: CGPoint(x: 0, y: -90), color: Colors.Red, content: SKSpriteNode(imageNamed: "settings"), radius: 30)
        rootNode.addChild(settingsButton.fadeIn())
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (playButton.containsPoint(location)) {
                
                var scaleDown = SKAction.scaleTo(0.0, duration: 0.25)
                var block = SKAction.runBlock({
                    self.playButton.runAction(scaleDown)
                    self.statsButton.runAction(scaleDown)
                    self.settingsButton.runAction(scaleDown)
                })
                
                self.runAction(SKAction.sequence([
                    block,
                    SKAction.waitForDuration(0.75)
                ]), completion: { ()
                    self.view?.presentScene(GameScene(size: self.size))
                })
            }
        }
    }
    
}