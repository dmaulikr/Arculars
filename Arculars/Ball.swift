//
//  Ball.swift
//  Arculars
//
//  Created by Roman Blum on 13/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Ball : SKShapeNode {
    
    let ballRadius = CGFloat(9.0)
    let ballSpeed = NSTimeInterval(2.4)
    
    let nodeColor : UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: SKColor, position: CGPoint) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, ballRadius, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.fillColor = color
        self.strokeColor = color
        self.lineWidth = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        self.physicsBody!.categoryBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.arc.rawValue
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = true
        
        var ballOffset = SKShapeNode(circleOfRadius: ballRadius)
        ballOffset.fillColor = color.darkerColor(0.1)
        ballOffset.strokeColor = color.darkerColor(0.1)
        ballOffset.lineWidth = 1
        ballOffset.zPosition = -1
        ballOffset.position = CGPoint(x: 0, y: -2)
        self.addChild(ballOffset)
        
        self.nodeColor = color
    }
    
    func fadeIn() -> Ball {
        self.xScale = 0.0
        self.yScale = 0.0
        
        self.runAction(
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.15),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.0, duration: 0.1)
                ])
        )
        
        return self
    }
    
    func fadeOut() -> Ball {
        self.runAction(SKAction.scaleTo(0.0, duration: 0.3))
        return self
    }
    
    func shoot() {
        // shoot the ball wide enough to get it off scree
        self.runAction(SKAction.moveTo(CGPoint(x: 0, y: 1000), duration: ballSpeed))
    }
}