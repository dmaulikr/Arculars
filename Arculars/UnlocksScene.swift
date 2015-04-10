//
//  UnlocksScene.swift
//  Arculars
//
//  Created by Roman Blum on 30/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class UnlocksScene: SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var btnUnlockTheme1 : Unlock!
    private var btnUnlockTheme2 : Unlock!
    private var btnUnlockTheme3 : Unlock!
    private var btnUnlockTheme4 : Unlock!
    
    private var btnUnlockBall1 : Unlock!
    private var btnUnlockBall2 : Unlock!
    private var btnUnlockBall3 : Unlock!
    private var btnUnlockBall4 : Unlock!
    
    private var btnUnlockEffect1 : Unlock!
    private var btnUnlockEffect2 : Unlock!
    private var btnUnlockEffect3 : Unlock!
    private var btnUnlockEffect4 : Unlock!
    
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
        getUnlocks()
    }
    
    func getUnlocks() {
        btnUnlockTheme1.setActive()
        btnUnlockTheme2.setUnlocked()
        btnUnlockTheme3.setUnlocked()
        btnUnlockTheme4.setUnlocked()
        
        btnUnlockBall1.setActive()
        btnUnlockBall2.setUnlocked()
        btnUnlockBall3.setUnlocked()
        btnUnlockBall4.setUnlocked()
        
        btnUnlockEffect1.setActive()
        btnUnlockEffect2.setUnlocked()
        btnUnlockEffect3.setUnlocked()
        btnUnlockEffect4.setUnlocked()
    }
    
    deinit {
        #if DEBUG
            println("UnlocksScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        var unlockRadius = size.height / 20
        
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: size.height / 12))
        title.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "UNLOCKS (COMING SOON)")
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT UNLOCKS
        var themesLabel = SKLabelNode(text: "THEMES")
        themesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        themesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        themesLabel.position = CGPoint(x: 0, y: size.height / 5 + (size.height / 10))
        themesLabel.fontSize = size.height / 48
        themesLabel.fontName = Fonts.FontNameNormal
        themesLabel.fontColor = Colors.FontColor
        rootNode.addChild(themesLabel)
        
        var themesNode = SKNode()
        themesNode.position = CGPoint(x: 0, y: size.height / 5)
        rootNode.addChild(themesNode)
        
        btnUnlockTheme1 = Unlock(radius: unlockRadius, cost: 0, color: Colors.AppColorOne, fontColor: Colors.FontColor, unlockedText: "DARK")
        btnUnlockTheme1.position = CGPoint(x: -btnUnlockTheme1.frame.width * 2, y: 0)
        themesNode.addChild(btnUnlockTheme1)
        btnUnlockTheme2 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorOne, fontColor: Colors.FontColor, unlockedText: "LIGHT")
        btnUnlockTheme2.position = CGPoint(x: -btnUnlockTheme2.frame.width / 1.5, y: 0)
        themesNode.addChild(btnUnlockTheme2)
        btnUnlockTheme3 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorOne, fontColor: Colors.FontColor, unlockedText: "B&W")
        btnUnlockTheme3.position = CGPoint(x: btnUnlockTheme3.frame.width / 1.5, y: 0)
        themesNode.addChild(btnUnlockTheme3)
        btnUnlockTheme4 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorOne, fontColor: Colors.FontColor, unlockedText: "SUMMER")
        btnUnlockTheme4.position = CGPoint(x: btnUnlockTheme4.frame.width * 2, y: 0)
        themesNode.addChild(btnUnlockTheme4)
        
        var ballsLabel = SKLabelNode(text: "BALLS")
        ballsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        ballsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        ballsLabel.position = CGPoint(x: 0, y: (size.height / 10))
        ballsLabel.fontSize = size.height / 48
        ballsLabel.fontName = Fonts.FontNameNormal
        ballsLabel.fontColor = Colors.FontColor
        rootNode.addChild(ballsLabel)
        
        var ballsNode = SKNode()
        ballsNode.position = CGPoint(x: 0, y: 0)
        rootNode.addChild(ballsNode)
        
        btnUnlockBall1 = Unlock(radius: unlockRadius, cost: 0, color: Colors.AppColorTwo, fontColor: Colors.FontColor, unlockedText: "STANDARD")
        btnUnlockBall1.position = CGPoint(x: -btnUnlockBall1.frame.width * 2, y: 0)
        ballsNode.addChild(btnUnlockBall1)
        btnUnlockBall2 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorTwo, fontColor: Colors.FontColor, unlockedText: "BOLT")
        btnUnlockBall2.position = CGPoint(x: -btnUnlockBall2.frame.width / 1.5, y: 0)
        ballsNode.addChild(btnUnlockBall2)
        btnUnlockBall3 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorTwo, fontColor: Colors.FontColor, unlockedText: "ROCKET")
        btnUnlockBall3.position = CGPoint(x: btnUnlockBall3.frame.width / 1.5, y: 0)
        ballsNode.addChild(btnUnlockBall3)
        btnUnlockBall4 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorTwo, fontColor: Colors.FontColor, unlockedText: "LIGHTNING")
        btnUnlockBall4.position = CGPoint(x: btnUnlockBall4.frame.width * 2, y: 0)
        ballsNode.addChild(btnUnlockBall4)
        
        var effectsLabel = SKLabelNode(text: "EFFECTS")
        effectsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        effectsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        effectsLabel.position = CGPoint(x: 0, y: -size.height / 5 + (size.height / 10))
        effectsLabel.fontSize = size.height / 48
        effectsLabel.fontName = Fonts.FontNameNormal
        effectsLabel.fontColor = Colors.FontColor
        rootNode.addChild(effectsLabel)
        
        var effectsNode = SKNode()
        effectsNode.position = CGPoint(x: 0, y: -size.height / 5)
        rootNode.addChild(effectsNode)
        
        btnUnlockEffect1 = Unlock(radius: unlockRadius, cost: 0, color: Colors.AppColorFour, fontColor: Colors.BackgroundColor, unlockedText: "NONE")
        btnUnlockEffect1.position = CGPoint(x: -btnUnlockEffect1.frame.width * 2, y: 0)
        effectsNode.addChild(btnUnlockEffect1)
        btnUnlockEffect2 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorFour, fontColor: Colors.BackgroundColor, unlockedText: "EFFECT")
        btnUnlockEffect2.position = CGPoint(x: -btnUnlockEffect2.frame.width / 1.5, y: 0)
        effectsNode.addChild(btnUnlockEffect2)
        btnUnlockEffect3 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorFour, fontColor: Colors.BackgroundColor, unlockedText: "EFFECT")
        btnUnlockEffect3.position = CGPoint(x: btnUnlockEffect3.frame.width / 1.5, y: 0)
        effectsNode.addChild(btnUnlockEffect3)
        btnUnlockEffect4 = Unlock(radius: unlockRadius, cost: 5000, color: Colors.AppColorFour, fontColor: Colors.BackgroundColor, unlockedText: "EFFECT")
        btnUnlockEffect4.position = CGPoint(x: btnUnlockEffect4.frame.width * 2, y: 0)
        effectsNode.addChild(btnUnlockEffect4)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "BACK TO MENU")
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
                    sceneDelegate!.showMenu()
                } else if (btnUnlockTheme1 == object as? Unlock) {
                    
                } else if (btnUnlockTheme2 == object as? Unlock) {
                    
                } else if (btnUnlockTheme3 == object as? Unlock) {
                    
                } else if (btnUnlockTheme4 == object as? Unlock) {
                    
                } else if (btnUnlockBall1 == object as? Unlock) {
                    
                } else if (btnUnlockBall2 == object as? Unlock) {
                    
                } else if (btnUnlockBall3 == object as? Unlock) {
                    
                } else if (btnUnlockBall4 == object as? Unlock) {
                    
                } else if (btnUnlockEffect1 == object as? Unlock) {
                    
                } else if (btnUnlockEffect2 == object as? Unlock) {
                    
                } else if (btnUnlockEffect3 == object as? Unlock) {
                    
                } else if (btnUnlockEffect4 == object as? Unlock) {
                    
                }
            }
        }
    }
}