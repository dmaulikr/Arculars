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
    
    var nodeColor : UIColor!
    
    init(color: SKColor, radius: CGFloat, position: CGPoint) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.fillColor = color
        self.strokeColor = color
        self.lineWidth = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.categoryBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.arc.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
        
        var ballOffset = SKShapeNode(circleOfRadius: radius)
        ballOffset.fillColor = color.darkerColor(0.1)
        ballOffset.strokeColor = color.darkerColor(0.1)
        ballOffset.lineWidth = 1
        ballOffset.zPosition = -1
        ballOffset.position = CGPoint(x: 0, y: -3)
        self.addChild(ballOffset)
        
        self.nodeColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shootTo(location: CGPoint, speed: NSTimeInterval) {
        let move = SKAction.moveTo(location, duration: speed)
        self.runAction(move)
    }
}