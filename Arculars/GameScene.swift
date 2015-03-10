//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Setup background color
        let bgColor = SKColor(red: 247.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        
        // Add Layers
        addChild(gameLayer)
        
        circleLayer.position = CGPointMake(0, size.height / 4)
        addChild(circleLayer)
        
        ballLayer.position = CGPointMake(0, -(size.height / 4))
        addChild(ballLayer)
        
        // Test: Create circles
        
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
        
        let move = SKAction.moveTo(CGPointMake(0, size.height / 4), duration: 2)
        let moveBack = SKAction.moveTo(CGPointMake(0, -(size.height / 4)), duration: 2)
        let sequence = SKAction.sequence([move, moveBack])
        let repeatAction2 = SKAction.repeatActionForever(sequence)
        ball.runAction(repeatAction2)
        
        ballLayer.addChild(ball)
        
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
            
            arc.lineWidth = circle.thickness
            arc.physicsBody = SKPhysicsBody(polygonFromPath: arcpath.CGPath)
            arc.physicsBody?.categoryBitMask = PhysicsCategory.Arc
            arc.physicsBody?.contactTestBitMask = PhysicsCategory.None
            arc.physicsBody?.collisionBitMask = 0
            arc.physicsBody?.usesPreciseCollisionDetection = true
            arc.physicsBody?.dynamic = true
            
            let angle : CGFloat = CGFloat(2 * M_PI)
            let rotate = SKAction.rotateByAngle(angle, duration: 1)
            let repeatAction = SKAction.repeatActionForever(rotate)
            arc.runAction(repeatAction)
            
            circleLayer.addChild(arc)
        }
        
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
                ballDidCollideWithArc(firstBody.node as SKShapeNode, arc: secondBody.node as SKShapeNode)
        }
    }
    
    func ballDidCollideWithArc(ball: SKShapeNode, arc: SKShapeNode) {
        println("Hit")
    }
}
