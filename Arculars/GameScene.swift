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
    
    let gameLayer = SKNode()
    let circleLayer = SKNode()
    let ballLayer = SKNode()
    
    var circles = [SKShapeNode]()
    var balls = [SKShapeNode]()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        createCircles()
    }
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Setup background color
        self.backgroundColor = Colors.LightBackground
        
        // Add Layers
        addChild(gameLayer)
        
        circleLayer.position = CGPointMake(0, size.height / 4)
        addChild(circleLayer)
        
        ballLayer.position = CGPointMake(0, -(size.height / 4))
        addChild(ballLayer)
        createBall()
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
    }
    
    func createCircles() {
        
        circles = [
            Circle(color: Colors.LightBlue, radius: 100.0, thickness: 40.0, clockwise: true),
            Circle(color: Colors.LightOrange, radius: 50.0, thickness: 25.0, clockwise: false),
            Circle(color: Colors.LightRed, radius: 20.0, thickness: 12.0, clockwise: true)
        ]
        
        for circle in circles {
            circleLayer.addChild(circle)
        }
    }
    
    func fireBall() {
        
        let move = SKAction.moveTo(CGPointMake(0, size.height), duration: 1.8)
        var ball = balls[0]
        balls.removeAtIndex(0)
        ball.runAction(move)
        
    }
    
    func createBall() {
        
        var ball = SKShapeNode(circleOfRadius: 12)
        ball.antialiased = true
        ball.position = CGPointMake(0, 0)
        ball.fillColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Arc
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.dynamic = true
        
        balls.append(ball)
        ballLayer.addChild(ball)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // Convert the touch location to a point relative to the cookiesLayer.
        let touch = touches.anyObject() as UITouch
        
        fireBall()
        createBall()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("Contact")
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Ball != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Arc != 0)) {
                var ballNode = firstBody.node as? SKShapeNode
                var arcNode = secondBody.node as? SKShapeNode
                if ballNode != nil && arcNode != nil {
                    ballDidCollideWithArc(ballNode!, arc: arcNode!)
                }
        }
    }
    
    func ballDidCollideWithArc(ball: SKShapeNode, arc: SKShapeNode) {
        println("Hit")
        if (ball.fillColor == arc.strokeColor) {
            ball.removeFromParent();
        }
        else {
            
        }
    }
}
