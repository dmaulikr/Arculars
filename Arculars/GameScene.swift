//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballSize = CGFloat(12.0)
    
    let labelLayer = SKNode()
    let circleLayer = SKNode()
    let ballLayer = SKNode()
    
    var circles = [Circle]()
    var ballQueue = [Ball]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.LightBackground
        
        // Setup Layers
        initLabels()
        initCircles()
        initBalls()
        
        // Setup Physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(self.size.width / 2), -(self.size.height / 2), self.size.width, self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
    }
    
    func initLabels() {
        labelLayer.position = CGPointMake(0, -(size.height / 2) + 32)
        addChild(labelLayer)
        
        var scoreLabel = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
        scoreLabel.text = "Score"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = Colors.LightFontColor
        
        labelLayer.addChild(scoreLabel)
    }
    
    func initCircles() {
        circleLayer.position = CGPointMake(0, size.height / 4)
        addChild(circleLayer)
        
        circles = [
            Circle(color: Colors.LightBlue, radius: 100.0, thickness: 40.0, clockwise: true, secondsPerRound: 1.2),
            Circle(color: Colors.LightOrange, radius: 50.0, thickness: 25.0, clockwise: false, secondsPerRound: 1.8),
            Circle(color: Colors.LightRed, radius: 20.0, thickness: 12.0, clockwise: true, secondsPerRound: 2.4)
        ]
        
        for circle in circles {
            circleLayer.addChild(circle)
        }
    }
    
    func initBalls() {
        ballLayer.position = CGPointMake(0, -(size.height / 4))
        addChild(ballLayer)
        addBallToQueue()
    }
    
    func fireBall() {
        let move = SKAction.moveTo(CGPointMake(0, size.height), duration: 1.8)
        var ball = ballQueue[0]
        ballQueue.removeAtIndex(0)
        ball.runAction(move)
    }
    
    func addBallToQueue() {
        var ball = Ball(color: Colors.randomLightBall(), radius: ballSize)
        ballQueue.append(ball)
        ballLayer.addChild(ball)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        fireBall()
        addBallToQueue()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
            case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
                
                var ballNode : Ball?
                var circleNode : Circle?
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as? Ball
                    circleNode = contact.bodyB.node?.parent as? Circle
                } else{
                    ballNode = contact.bodyB.node as? Ball
                    circleNode = contact.bodyA.node?.parent as? Circle
                }
                if ballNode != nil && circleNode != nil {
                    ballDidCollideWithArc(ballNode!, circle: circleNode!)
                }
                break
            case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
                var ballNode : Ball?
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as? Ball
                } else{
                    ballNode = contact.bodyB.node as? Ball
                }
                
                ballNode?.removeFromParent()
                break
            default:
                return
        }
    }
    
    func ballDidCollideWithArc(ball: Ball, circle: Circle) {
        if (ball.color == circle.color) {
            ball.removeFromParent();
        } else {
            
        }
    }
}
