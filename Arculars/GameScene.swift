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
    
    var circles : [Circle] = [
        Circle(color: Colors.LightBlue, radius: 100.0, thickness: 40.0, clockwise: true, secondsPerRound: 1.2),
        Circle(color: Colors.LightOrange, radius: 50.0, thickness: 25.0, clockwise: false, secondsPerRound: 1.8),
        Circle(color: Colors.LightRed, radius: 20.0, thickness: 12.0, clockwise: true, secondsPerRound: 2.4)
    ]
    
    var ballQueue = [Ball]()
    
    var screenNode : SKSpriteNode!
    var score : Score!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.LightBackground
        
        screenNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        addChild(screenNode)
        
        score = Score().addTo(screenNode)
        
        for circle in circles {
            circle.addTo(screenNode).startAnimation()
        }
        
        addBallToQueue()
        
        // Setup Physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(self.size.width / 2), -(self.size.height / 2), self.size.width, self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
    }
    
    func fireBall() {
        var ball = ballQueue[0]
        ballQueue.removeAtIndex(0)
        ball.moveTo(CGPointMake(0, size.height))
    }
    
    func addBallToQueue() {
        var ball = Ball(color: Colors.randomLightBall(), radius: ballSize)
        ballQueue.append(ball)
        ball.addTo(screenNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        fireBall()
        addBallToQueue()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
            case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
                var ballNode : SKShapeNode!
                var circleNode : SKShapeNode!
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as? SKShapeNode
                    circleNode = contact.bodyB.node as? SKShapeNode
                } else{
                    ballNode = contact.bodyB.node as? SKShapeNode
                    circleNode = contact.bodyA.node as? SKShapeNode
                }
                if ballNode != nil && circleNode != nil {
                    ballDidCollideWithArc(ballNode, circle: circleNode)
                }
                break
            case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
                var ballNode : SKShapeNode!
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as SKShapeNode
                } else{
                    ballNode = contact.bodyB.node as SKShapeNode
                }
                
                ballNode.removeFromParent()
                break
            default:
                return
        }
    }
    
    func ballDidCollideWithArc(ball: SKShapeNode, circle: SKShapeNode) {
        if (ball.fillColor == circle.strokeColor) {
            ball.removeFromParent();
        } else {
            // Game over
        }
    }
}
