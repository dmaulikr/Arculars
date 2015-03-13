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
    
    let nameOfArc = "arc" // to find it in the child nodes
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
        var arcShape = SKShapeNode(path: arcpath.CGPath)
        arcShape.name = nameOfArc
        arcShape.position = CGPointMake(0, 0)
        arcShape.lineCap = kCGLineCapRound
        arcShape.strokeColor = color
        
        // Add physicsbody of arc
        var currentpoint = CGPointMake(radius, 0)
        var physicsparts = 10;
        var bodypath : CGMutablePath = CGPathCreateMutable();
        var offsetangle = CGFloat(sizeOfArc / CGFloat(physicsparts))
        
        for var index = 0; index < physicsparts + 1; index++ {
            CGPathAddArc(bodypath, nil, currentpoint.x, currentpoint.y, CGFloat(thickness / 2), CGFloat(2 * M_PI), 0, true)
            currentpoint = CGPointApplyAffineTransform(currentpoint, CGAffineTransformMakeRotation(offsetangle));
        }
        
        arcShape.lineWidth = thickness
        arcShape.physicsBody = SKPhysicsBody(polygonFromPath: bodypath)
        arcShape.physicsBody?.categoryBitMask = PhysicsCategory.arc.rawValue
        arcShape.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        arcShape.physicsBody?.collisionBitMask = 0
        arcShape.physicsBody?.usesPreciseCollisionDetection = true
        arcShape.physicsBody?.dynamic = true
        
        self.addChild(arcShape)
        
        startAnimation()
    }
    
    func startAnimation() {
        var rotationangle : CGFloat
        if clockwise {
            rotationangle = CGFloat(2 * M_PI)
        }
        else {
            rotationangle = -CGFloat(2 * M_PI)
        }
        var rotate = SKAction.rotateByAngle(rotationangle, duration: secondsPerRound)
        var repeatAction = SKAction.repeatActionForever(rotate)
        var arcShape = self.childNodeWithName(nameOfArc)
        arcShape?.runAction(repeatAction)
    }
    
    func stopAnimation() {
        var arcShape = self.childNodeWithName(nameOfArc)
        arcShape?.removeAllActions()
    }
}