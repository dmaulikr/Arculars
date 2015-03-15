//
//  Ball.swift
//  Arculars
//
//  Created by Roman Blum on 13/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Ball {
    
    private var ball : SKShapeNode!
    private var color : SKColor!
    private var radius : CGFloat!
    
    init(color: SKColor, radius: CGFloat) {
        self.color = color
        self.radius = radius
    }
    
    func addTo(parentNode: SKSpriteNode) -> Ball {
        // Setup Node
        ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = color
        ball.strokeColor = color
        ball.lineWidth = 1
        ball.position = CGPoint(x: 0, y: -(parentNode.size.height / 4))
        
        var ballOffset = SKShapeNode(circleOfRadius: radius)
        ballOffset.fillColor = color.darkerColor(0.1)
        ballOffset.strokeColor = color.darkerColor(0.1)
        ballOffset.lineWidth = 1
        ballOffset.zPosition = -1
        ballOffset.position = CGPoint(x: 0, y: -3)
        
        ball.addChild(ballOffset)
        
        // Setup Physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball.rawValue
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.arc.rawValue
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.dynamic = true
        
        parentNode.addChild(ball)
        return self
    }
    
    func moveTo(location: CGPoint, speed: NSTimeInterval) {
        let move = SKAction.moveTo(location, duration: speed)
        ball.runAction(move)
    }
}