//
//  SettingsScene.swift
//  Arculars
//
//  Created by Roman Blum on 23/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene : SKScene {
    
    var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    private var btnToMenu : SKShapeNode!
    
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
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: self.size.width / 3, height: self.size.height / 12))
        title.position = CGPoint(x: 0, y: (self.size.height / 2) - (self.size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "SETTINGS")
        titleLabel.fontSize = self.size.height / 32
        titleLabel.fontName = "Avenir-Black"
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "BACK TO MENU")
        tml.position = CGPoint(x: 0, y: -(self.size.height / 2) + (self.size.height / 24))
        tml.fontName = "Avenir"
        tml.fontColor = Colors.FontColor
        tml.fontSize = self.size.height / 32
        btnToMenu = SKShapeNode(rect: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
    }
    
    override func didMoveToView(view: SKView) {
        self.runAction(SKAction.fadeInWithDuration(0.3))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (btnToMenu.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            }
        }
    }
}