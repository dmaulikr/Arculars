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
        
        // Add GameLayer
        addChild(gameLayer)
        
        // Test: Create circles
        var circle1 = SKShapeNode(circleOfRadius: 100)
        circle1.position = CGPointMake(0, size.height / 4)
        circle1.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.2)
        circle1.lineWidth = 40
        circle1.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        circle1.physicsBody?.dynamic = false //set to false so it doesn't fall off scene.
        gameLayer.addChild(circle1)
        
        let arc1path = UIBezierPath(arcCenter: CGPointMake(0, 0), radius: 100, startAngle: 0.0, endAngle: CGFloat(M_PI / 2.0), clockwise: true)
        var arc1 = SKShapeNode(path: arc1path.CGPath)
        arc1.position = CGPointMake(0, size.height / 4)
        arc1.lineCap = kCGLineCapRound
        arc1.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        arc1.lineWidth = 40
        arc1.physicsBody = SKPhysicsBody(polygonFromPath: arc1path.CGPath)
        arc1.physicsBody?.categoryBitMask = PhysicsCategory.Arc
        arc1.physicsBody?.contactTestBitMask = PhysicsCategory.None
        arc1.physicsBody?.collisionBitMask = 0
        arc1.physicsBody?.usesPreciseCollisionDetection = true
        arc1.physicsBody?.dynamic = true
        
        let angle : CGFloat = CGFloat(2 * M_PI)
        let rotate = SKAction.rotateByAngle(angle, duration: 1)
        let repeatAction = SKAction.repeatActionForever(rotate)
        arc1.runAction(repeatAction)
        
        gameLayer.addChild(arc1)
        
        var ball1 = SKShapeNode(circleOfRadius: 20)
        ball1.antialiased = true
        ball1.position = CGPointMake(0, -(size.height / 4))
        ball1.fillColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball1.strokeColor = SKColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        ball1.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball1.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball1.physicsBody?.contactTestBitMask = PhysicsCategory.Arc
        ball1.physicsBody?.collisionBitMask = 0
        ball1.physicsBody?.usesPreciseCollisionDetection = true
        ball1.physicsBody?.dynamic = true
        
        let move = SKAction.moveTo(CGPointMake(0, size.height / 4), duration: 2)
        let moveBack = SKAction.moveTo(CGPointMake(0, -(size.height / 4)), duration: 2)
        let sequence = SKAction.sequence([move, moveBack])
        let repeatAction2 = SKAction.repeatActionForever(sequence)
        ball1.runAction(repeatAction2)
        
        gameLayer.addChild(ball1)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
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
