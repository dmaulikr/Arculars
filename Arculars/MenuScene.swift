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
    
    deinit {
        println("deinit menuscene")
    }
    
    private func initMenu() {
        playButton = Button(name: "playbutton", position: CGPoint(x: 0, y: 90), color: Colors.Blue, content: SKSpriteNode(imageNamed: "play"), radius: 30)
        playButton.addTo(screenNode)
        
        statsButton = Button(name: "statsbutton", position: CGPoint(x: 0, y: 0), color: Colors.Orange, content: SKSpriteNode(imageNamed: "stats"), radius: 30)
        statsButton.addTo(screenNode)
        
        settingsButton = Button(name: "settingsbutton", position: CGPoint(x: 0, y: -90), color: Colors.Red, content: SKSpriteNode(imageNamed: "settings"), radius: 30)
        settingsButton.addTo(screenNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(screenNode)
            var nodeAtLocation = self.nodeAtPoint(location)
            
            if (nodeAtLocation.name == "playbutton") {
                
                var scaleDown = SKAction.scaleTo(0.0, duration: 0.25)
                var block = SKAction.runBlock({
                    self.playButton.button.runAction(scaleDown)
                    self.statsButton.button.runAction(scaleDown)
                    self.settingsButton.button.runAction(scaleDown)
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