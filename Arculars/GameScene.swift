//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let Ball      : UInt32 = 0b1
    static let Arc       : UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameLayer = SKNode()
    let circleLayer = SKNode()
    let ballLayer = SKNode()
    
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
    }
    
    func createCircles(circles: [Circle]) {
        
        for circle in circles {
            var shape = SKShapeNode(circleOfRadius: circle.radius)
            shape.position = CGPointMake(0, 0)
            shape.strokeColor = circle.color.colorWithAlphaComponent(0.2)
            shape.lineWidth = circle.thickness
            shape.physicsBody = SKPhysicsBody(circleOfRadius: circle.radius)
            shape.physicsBody?.dynamic = false
            
            circleLayer.addChild(shape)
            
            let arcpath = UIBezierPath(arcCenter: CGPointMake(0, 0), radius: circle.radius, startAngle: 0.0, endAngle: CGFloat(M_PI / 2.0), clockwise: true)
            var arc = SKShapeNode(path: arcpath.CGPath)
            arc.position = CGPointMake(0, 0)
            arc.lineCap = kCGLineCapRound
            arc.strokeColor = circle.color
            
            var bodyparts = 10;
            var bodypath = CGPathCreateMutable();
            for var index = 0; index < bodyparts; ++index {
                CGPathAddArc(bodypath, nil, 0, circle.radius, CGFloat(circle.thickness / 2), 0, CGFloat(2 * M_PI), true)
            }
            
            arc.lineWidth = circle.thickness
            arc.physicsBody = SKPhysicsBody(polygonFromPath: bodypath)
            arc.physicsBody?.categoryBitMask = PhysicsCategory.Arc
            arc.physicsBody?.contactTestBitMask = PhysicsCategory.None
            arc.physicsBody?.collisionBitMask = 0
            arc.physicsBody?.usesPreciseCollisionDetection = true
            arc.physicsBody?.dynamic = true
            
            var angle : CGFloat
            if circle.clockwise {
                angle = CGFloat(2 * M_PI)
            }
            else {
                angle = -CGFloat(2 * M_PI)
            }
            let rotate = SKAction.rotateByAngle(angle, duration: 1.5)
            let repeatAction = SKAction.repeatActionForever(rotate)
            arc.runAction(repeatAction)

            circleLayer.addChild(arc)
        }
        
    }
    
    func fireBall() {
        
        let move = SKAction.moveTo(CGPointMake(0, size.height), duration: 1.8)
        // move.timingMode = SKActionTimingMode.EaseIn
        var ball = balls[0]
        balls.removeAtIndex(0)
        ball.runAction(move)
        
    }
    
    func createBall() {
        
        var ball = SKShapeNode(circleOfRadius: 20)
        ball.antialiased = true
        ball.position = CGPointMake(0, 0)
        ball.fillColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
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
