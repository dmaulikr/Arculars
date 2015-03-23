//
//  SettingsScene.swift
//  Arculars
//
//  Created by Roman Blum on 19/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene: SKScene {
    
    var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var tomenu : SKShapeNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Add Root Node
        self.addChild(rootNode)
        
        initScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initScene() {
        var tomenuLabel = SKLabelNode(text: "BACK TO MENU")
        tomenuLabel.fontName = "Avenir"
        tomenuLabel.fontColor = Colors.FontColor
        tomenuLabel.fontSize = self.size.height / 32
        tomenu = SKShapeNode(rect: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: tomenuLabel.frame.height * 4))
        tomenu.lineWidth = 0
        tomenu.fillColor = UIColor.clearColor()
        tomenu.strokeColor = UIColor.clearColor()
        tomenuLabel.position = CGPoint(x: 0, y: -(self.size.height / 2) + (tomenuLabel.frame.height * 1.5))
        tomenu.addChild(tomenuLabel)
        rootNode.addChild(tomenu)
    }
    
    override func didMoveToView(view: SKView) {
        
        self.runAction(SKAction.fadeInWithDuration(0.3))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (tomenu.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            }
        }
    }
}