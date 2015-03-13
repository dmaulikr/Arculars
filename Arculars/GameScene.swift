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
        
        createCircles()
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
        
        var ball = Ball(color: Colors.LightBlue, radius: 12)
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
            default:
                return
        }
    }
    
    func ballDidCollideWithArc(ball: Ball, circle: Circle) {
        println("Hit")
        if (ball.color == circle.color) {
            ball.removeFromParent();
        }
    }
}
