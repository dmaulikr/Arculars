//
//  HelpScene.swift
//  Arculars
//
//  Created by Roman Blum on 30/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class HelpScene: SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var btnToMenu : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
        
        alpha = 0.0
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.1))
    }
    
    deinit {
        #if DEBUG
            println("HelpScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: size.height / 12))
        title.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "HOW TO PLAY")
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // TUTORIAL IMAGE
        var image = SKSpriteNode(imageNamed: "tutorial-image")
        var aspectRatio = image.size.width / image.size.height
        image.size = CGSize(width: size.width, height: size.width / aspectRatio)
        image.position = CGPoint(x: 0, y: 0)
        rootNode.addChild(image)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "CLOSE")
        tml.position = CGPoint(x: 0, y: -(size.height / 2) + (size.height / 12))
        tml.fontName = Fonts.FontNameNormal
        tml.fontColor = Colors.DisabledColor
        tml.fontSize = size.height / 32
        tml.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tml.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnToMenu = SKShapeNode(rect: CGRect(x: -(size.width / 2), y: -(size.height / 2), width: size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnToMenu == object as? SKShapeNode) {
                    sceneDelegate!.showMenuScene()
                }
            }
        }
    }
}