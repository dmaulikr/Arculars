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
    
    let color : SKColor
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: SKColor, radius: CGFloat) {
        self.color = color
        super.init()
        
        // Init Ball (self)
        var circle = CGPathCreateMutable()
        CGPathAddArc(circle, nil, 0, 0, radius, CGFloat(2 * M_PI), 0, true)
        self.path = circle
        self.fillColor = color
        self.strokeColor = color
        self.lineWidth = 0
        self.position = CGPointMake(0, 0)
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.categoryBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.arc.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.dynamic = true
    }
    
}