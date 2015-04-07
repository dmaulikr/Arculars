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
    var nodeColor : UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: SKColor, position: CGPoint, radius: CGFloat) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius - 1, CGFloat(M_PI * 2), 0, true)
        path = circlepath
        
        lineWidth = 1
        self.position = position
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.ball.rawValue
        physicsBody!.contactTestBitMask = PhysicsCategory.arc.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.dynamic = true
        
        setColor(color)
    }
    
    func setColor(color: UIColor) {
        fillColor = color
        strokeColor = color
        nodeColor = color
    }
    
    func fadeIn() -> Ball {
        
        // disable the physicsbody because otherwise this will fail
        let temp = physicsBody
        physicsBody = nil
        
        xScale = 0.0
        yScale = 0.0
        
        runAction(
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
        runAction(SKAction.scaleTo(0.0, duration: 0.3))
        return self
    }
    
    func shoot(range: CGFloat) {
        runAction(SKAction.moveTo(CGPoint(x: 0, y:range), duration: NSTimeInterval(range / ballSpeed)))
    }
}