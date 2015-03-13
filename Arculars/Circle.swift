//
//  Circle.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Circle : SKShapeNode {
    
    let color : SKColor
    let radius : CGFloat
    let thickness: CGFloat
    let clockwise: Bool
    let secondsPerRound: NSTimeInterval
    
    let sizeOfArc = CGFloat(M_PI / 2) // in radians
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: SKColor, radius: CGFloat, thickness: CGFloat, clockwise: Bool, secondsPerRound: NSTimeInterval) {
        self.color = color
        self.radius = radius
        self.thickness = thickness
        self.clockwise = clockwise
        self.secondsPerRound = secondsPerRound
        super.init()
        
        // Init Circle (self)
        var circle = CGPathCreateMutable()
        CGPathAddArc(circle, nil, 0, 0, radius, CGFloat(2 * M_PI), 0, true)
        self.path = circle
        self.strokeColor = color.colorWithAlphaComponent(0.2)
        self.lineWidth = thickness
        self.position = CGPointMake(0, 0)
        
        // Init Arc
        let arcpath = UIBezierPath(arcCenter: CGPointMake(0, 0), radius: radius, startAngle: 0.0, endAngle: sizeOfArc, clockwise: true)
        var arc = SKShapeNode(path: arcpath.CGPath)
        arc.position = CGPointMake(0, 0)
        arc.lineCap = kCGLineCapRound
        arc.strokeColor = color
        
        // Add physicsbody of arc
        var currentpoint = CGPointMake(radius, 0)
        var bodyparts = 10;
        var bodypath : CGMutablePath = CGPathCreateMutable();
        var offsetangle = CGFloat(sizeOfArc / CGFloat(bodyparts))
        
        for var index = 0; index < bodyparts + 1; index++ {
            CGPathAddArc(bodypath, nil, currentpoint.x, currentpoint.y, CGFloat(thickness / 2), CGFloat(2 * M_PI), 0, true)
            currentpoint = CGPointApplyAffineTransform(currentpoint, CGAffineTransformMakeRotation(offsetangle));
        }
        
        arc.lineWidth = thickness
        arc.physicsBody = SKPhysicsBody(polygonFromPath: bodypath)
        arc.physicsBody?.categoryBitMask = PhysicsCategory.arc.rawValue
        arc.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        arc.physicsBody?.collisionBitMask = 0
        arc.physicsBody?.usesPreciseCollisionDetection = true
        arc.physicsBody?.dynamic = true
        
        // Add animation
        var rotationangle : CGFloat
        if clockwise {
            rotationangle = CGFloat(2 * M_PI)
        }
        else {
            rotationangle = -CGFloat(2 * M_PI)
        }
        let rotate = SKAction.rotateByAngle(rotationangle, duration: secondsPerRound)
        let repeatAction = SKAction.repeatActionForever(rotate)
        arc.runAction(repeatAction)
        
        self.addChild(arc)
    }
    
}