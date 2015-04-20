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
    
    private var isPageSwitching = false
    private var current : SKNode?
    private var currentPage = 1
    
    private var ballRadius : CGFloat
    private var nextBall : Ball?
    private var score : Score!
    
    // PAGE ONE
    private var btnGotoPage2 : SKShapeNode!
    private let p1SkipShoot = 2
    private var p1SkipCurrent = 2
    
    // PAGE TWO
    private var btnGotoPage3 : SKShapeNode!
    private var p2Powerup : Powerup!
    
    // PAGE THREE
    private var btnGotoPage4 : SKShapeNode!
    
    // PAGE FOUR
    private var btnClose : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        ballRadius = size.height / 80
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = ThemeHandler.Instance.getCurrentColors().BackgroundColor
        
        // Setup Scene Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(size.width / 2), -(size.height / 2), size.width, size.height))
        physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.dynamic = true

        current = initPageOne()
        addChild(current!)
        addBall()
        
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
    private func initPageOne() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "HOW TO PLAY"))
        
        var radius = size.height / 24
        var thickness = size.height / 40
        
        var c1 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius, thickness: thickness, clockwise: false, pointsPerHit: 2, color: ThemeHandler.Instance.getCurrentColors().AppColorOne)
        c1.setSpeed(3.0, max: 3.0)
        page.addChild(c1)
        
        var c2 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius + thickness, thickness: thickness, clockwise: true, pointsPerHit: 1, color: ThemeHandler.Instance.getCurrentColors().AppColorThree)
        c2.setSpeed(2.0, max: 2.0)
        page.addChild(c2)
        
        score = Score(position: CGPoint(x: 0, y: (size.height / 4) + radius + (3 * thickness)))
        score.fontSize = size.height / 40
        page.addChild(score)
        
        var wait = SKAction.waitForDuration(2.0)
        var shoot = SKAction.runBlock({()
            if (self.p1SkipCurrent < self.p1SkipShoot) {
                self.p1SkipCurrent++
                self.shootBall()
                self.addBall()
            } else {
                self.p1SkipCurrent = 0
            }
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([shoot, wait])))
        
        var pageLabel_1 = createLabel("Hit the arc matching")
        pageLabel_1.position = CGPoint(x: 0, y: -size.height / 6)
        page.addChild(pageLabel_1)
        var pageLabel_2 = createLabel("the ball's color")
        pageLabel_2.position = CGPoint(x: 0, y: pageLabel_1.position.y - (pageLabel_1.frame.height))
        page.addChild(pageLabel_2)
        
        btnGotoPage2 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage2)
        
        return page
    }
    
    private func initPageTwo() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "POWERUPS"))
        
        var radius = size.height / 24
        var thickness = size.height / 40
        
        var c1 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius, thickness: thickness, clockwise: false, pointsPerHit: 2, color: ThemeHandler.Instance.getCurrentColors().AppColorOne)
        c1.setSpeed(3.0, max: 3.0)
        page.addChild(c1)
        
        var c2 = Circle(position: CGPoint(x: 0, y: (size.height / 4)), radius: radius + thickness, thickness: thickness, clockwise: true, pointsPerHit: 1, color: ThemeHandler.Instance.getCurrentColors().AppColorThree)
        c2.setSpeed(2.0, max: 2.0)
        page.addChild(c2)
        
        p2Powerup = Powerup(radius: ballRadius * 2, type: PowerupType.Unicolor)
        p2Powerup.position = c1.position
        page.addChild(p2Powerup)
        
        var pageLabel_1 = createLabel("Collect Powerups")
        pageLabel_1.position = CGPoint(x: 0, y: -size.height / 6)
        page.addChild(pageLabel_1)
        var pageLabel_2 = createLabel("to boost your score")
        pageLabel_2.position = CGPoint(x: 0, y: pageLabel_1.position.y - (pageLabel_1.frame.height))
        page.addChild(pageLabel_2)
        
        btnGotoPage3 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage3)
        
        return page
    }
    
    private func initPageThree() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "STATS"))
        
        btnGotoPage4 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage4)
        
        return page
    }
    
    private func initPageFour() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "SETTINGS"))
        
        btnClose = Nodes.getTextButton(frame.size, content: "CLOSE")
        page.addChild(btnClose)
        
        return page
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (isPageSwitching) { return }
        
        switch currentPage {
        case 1:
            self.removeAllActions()
            currentPage = 2
            pageSwitch(current!, right: initPageTwo())
            break
        case 2:
            self.removeAllActions()
            currentPage = 3
            pageSwitch(current!, right: initPageThree())
            break
        case 3:
            self.removeAllActions()
            currentPage = 4
            pageSwitch(current!, right: initPageFour())
            break
        case 4:
            self.removeAllActions()
            sceneDelegate?.showMenuScene()
            break
        default:
            break
        }
    }
    
    // MARK: - CONTACTS DELEGATE
    func didBeginContact(contact: SKPhysicsContact) {
        var ball : Ball
        var circle : Circle
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
        case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
                circle = contact.bodyB.node!.parent as! Circle // parent because the arc's parent
            } else {
                ball = contact.bodyB.node as! Ball
                circle = contact.bodyA.node!.parent as! Circle // parent because the arc's parent
            }
            
            ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
            ball.removeFromParent()
            
            if (ball.nodeColor == circle.nodeColor) {
                runAction(SKAction.playSoundFileNamed("hit1.wav", waitForCompletion: false))
                score.increaseByWithColor(circle.pointsPerHit, color: circle.nodeColor)
            } else {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            break
        case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            ball.removeFromParent()
            break
        case PhysicsCategory.powerup.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            
            break
        default:
            return
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func pageSwitch(left: SKNode, right: SKNode) {
        right.position = CGPoint(x: size.width, y: 0)
        addChild(right)
        
        var fadeOut = SKAction.moveByX(-size.width, y: 0, duration: 0.3)
        fadeOut.timingMode = SKActionTimingMode.EaseOut
        var fadeIn = SKAction.moveByX(-size.width, y: 0, duration: 0.3)
        fadeIn.timingMode = SKActionTimingMode.EaseOut
        
        left.runAction(fadeOut)
        right.runAction(fadeIn, completion: {()
            self.current = right
            left.removeFromParent()
            self.isPageSwitching = false
        })
    }
    
    private func createLabel(text: String) -> SKLabelNode {
        var label = SKLabelNode(text: text)
        label.fontSize = size.height / 24
        label.fontName = Fonts.FontNameNormal
        label.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return label
    }
    
    private func addBall() {
        nextBall = Ball(color: ThemeHandler.Instance.getCurrentColors().AppColorOne, position: CGPoint(x: 0, y: 0), radius: ballRadius)
        current?.addChild(nextBall!.fadeIn())
    }
    
    private func shootBall() {
        nextBall?.shoot(size.height)
    }
    
}