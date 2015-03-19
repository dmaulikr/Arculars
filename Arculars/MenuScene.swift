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
    
    var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var playButton : Button!
    private var statsButton : Button!
    private var settingsButton : Button!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Init Top Level Nodes
        self.addChild(rootNode)
        
        // Init Menu
        playButton = Button(position: CGPoint(x: 0, y: 90), color: Colors.Blue, content: SKSpriteNode(imageNamed: "play"), radius: 30)
        rootNode.addChild(playButton)
        
        statsButton = Button(position: CGPoint(x: 0, y: 0), color: Colors.Orange, content: SKSpriteNode(imageNamed: "stats"), radius: 30)
        rootNode.addChild(statsButton)
        
        settingsButton = Button(position: CGPoint(x: 0, y: -90), color: Colors.Red, content: SKSpriteNode(imageNamed: "settings"), radius: 30)
        rootNode.addChild(settingsButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        playButton.fadeIn()
        statsButton.fadeIn()
        settingsButton.fadeIn()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (playButton.containsPoint(location)) {
                
                self.playButton.runAction(
                    SKAction.scaleTo(0.0, duration: 0.2)
                    , completion: {()
                        self.sceneDelegate?.showGameScene()
                })
                
            } else if (statsButton.containsPoint(location)) {
                sceneDelegate?.showGameCenter()
            }
        }
    }
    
}