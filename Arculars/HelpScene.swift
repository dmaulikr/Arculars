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
    
    private var btnClose : SKShapeNode!
    
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
        rootNode.addChild(Nodes.getSceneTitle(frame.size, content: "HOW TO PLAY"))
        
        // TUTORIAL IMAGE
        var image = SKSpriteNode(imageNamed: "tutorial-image")
        var aspectRatio = image.size.width / image.size.height
        image.size = CGSize(width: size.width, height: size.width / aspectRatio)
        image.position = CGPoint(x: 0, y: 0)
        rootNode.addChild(image)
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "CLOSE")
        rootNode.addChild(btnClose)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnClose == object as? SKShapeNode) {
                    sceneDelegate!.showMenuScene()
                }
            }
        }
    }
}