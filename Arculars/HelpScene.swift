//
//  HelpScene.swift
//  Arculars
//
//  Created by Roman Blum on 30/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class HelpScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    private var nextBall : Ball?
    private var score : Score!
    
    private var btnClose : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = ThemeHandler.Instance.getCurrentColors().BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        
        // Setup Scene Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
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
        
        // SAMPE GAMESCENE
        var radius = size.height / 24
        var thickness = size.height / 40
        var c1 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius, thickness: thickness, clockwise: false, pointsPerHit: 2, color: ThemeHandler.Instance.getCurrentColors().AppColorOne)
        c1.setColor(ThemeHandler.Instance.getCurrentColors().AppColorOne)
        c1.setSpeed(2.0, max: 2.0)
        c1.fadeIn()
        rootNode.addChild(c1)
        
        var c2 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius + thickness, thickness: thickness, clockwise: true, pointsPerHit: 1, color: ThemeHandler.Instance.getCurrentColors().AppColorThree)
        c2.setColor(ThemeHandler.Instance.getCurrentColors().AppColorThree)
        c2.setSpeed(1.6, max: 1.6)
        c2.fadeIn()
        rootNode.addChild(c2)
        
        score = Score(position: CGPoint(x: 0, y: (size.height / 4) + radius + (3 * thickness)))
        score.fontSize = size.height / 40
        rootNode.addChild(score)
        
        addBall()
        var wait = SKAction.waitForDuration(3.0)
        var shoot = SKAction.runBlock({()
            self.shootBall()
            self.addBall()
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([shoot, wait])))
        
        // TEXT
        
        
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
    
    // MARK: - CONTACTS DELEGATE
    func didBeginContact(contact: SKPhysicsContact) {
        var ball : Ball
        var circle : Circle
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
            ball = contact.bodyA.node as! Ball
            circle = contact.bodyB.node?.parent as! Circle // parent because the arc's parent
        } else {
            ball = contact.bodyB.node as! Ball
            circle = contact.bodyA.node?.parent as! Circle // parent because the arc's parent
        }
        
        ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
        ball.removeFromParent()
        
        if (ball.nodeColor == circle.nodeColor) {
            runAction(SKAction.playSoundFileNamed("hit1.wav", waitForCompletion: false))
            score.increaseByWithColor(circle.pointsPerHit, color: circle.nodeColor)
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func addBall() {
        nextBall = Ball(color: ThemeHandler.Instance.getCurrentColors().AppColorOne, position: CGPoint(x: 0, y: 0), radius: size.height / 80)
        rootNode.addChild(nextBall!.fadeIn())
    }
    
    private func shootBall() {
        nextBall?.shoot(size.height)
    }
    
}