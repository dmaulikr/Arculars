//
//  Circle.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Circle {
    
    private var color : SKColor!
    private var radius : CGFloat!
    private var thickness : CGFloat!
    private var clockwise : Bool
    private var secondsPerRound : NSTimeInterval!
    
    private var circle : SKShapeNode!
    private var arc : SKShapeNode!
    
    let sizeOfArc = CGFloat(M_PI / 2) // in radians
    
    init(color: SKColor, radius: CGFloat, thickness: CGFloat, clockwise: Bool, secondsPerRound: NSTimeInterval) {
        self.color = color
        self.radius = radius
        self.thickness = thickness
        self.clockwise = clockwise
        self.secondsPerRound = secondsPerRound
    }
    
    func addTo(parentNode: SKSpriteNode) -> Circle {
        circle = SKShapeNode(circleOfRadius: radius)
        circle.strokeColor = color.colorWithAlphaComponent(0.2)
        circle.lineWidth = thickness
        circle.position = CGPointMake(0, parentNode.size.height / 4)
        
        let arcpath = UIBezierPath(arcCenter: CGPointMake(0, 0), radius: radius, startAngle: 0.0, endAngle: sizeOfArc, clockwise: true)
        arc = SKShapeNode(path: arcpath.CGPath)
        arc.position = CGPointMake(0, 0)
        arc.lineCap = kCGLineCapRound
        arc.strokeColor = color
        
        circle.addChild(arc)
        
        // Add physicsbody of Arc
        var currentpoint = CGPointMake(radius, 0)
        var physicsparts = 10;
        var bodypath : CGMutablePath = CGPathCreateMutable();
        var offsetangle = CGFloat(sizeOfArc / CGFloat(physicsparts))
        
        for var index = 0; index < physicsparts + 1; index++ {
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
        
        parentNode.addChild(circle)
        return self
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
        arc.runAction(repeatAction)
    }
    
    func stopAnimation() {
        arc.removeAllActions()
    }
}