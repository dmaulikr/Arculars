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
    
    private let ballSpeed : CGFloat = 500.0 // pixels per second
    let nodeColor : UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: SKColor, position: CGPoint, radius: CGFloat) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.fillColor = color
        self.strokeColor = color
        self.lineWidth = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody!.categoryBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.arc.rawValue
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.dynamic = true
        
        self.nodeColor = color
    }
    
    func fadeIn() -> Ball {
        
        // disable the physicsbody because otherwise this will fail
        let temp = self.physicsBody
        self.physicsBody = nil
        
        self.xScale = 0.0
        self.yScale = 0.0
        
        self.runAction(
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.1),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.0, duration: 0.1)
                ]), completion: {()
                    self.physicsBody = temp
        })
        
        return self
    }
    
    func fadeOut() -> Ball {
        self.runAction(SKAction.scaleTo(0.0, duration: 0.3))
        return self
    }
    
    func shoot(range: CGFloat) {
        self.runAction(SKAction.moveTo(CGPoint(x: 0, y:range), duration: NSTimeInterval(range / ballSpeed)))
    }
}