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
    
    var arc : SKShapeNode!
    let nodeColor : UIColor!
    
    var pointsPerHit = 0
    let sizeOfArc = CGFloat(M_PI / 2) // in radians
    
    init(circleColor: UIColor, arcColor: UIColor, position: CGPoint, radius: CGFloat, thickness: CGFloat, clockwise: Bool, secondsPerRound: NSTimeInterval, pointsPerHit: Int) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.lineWidth = thickness
        self.zPosition = 0
        self.strokeColor = circleColor
        self.position = position
        
        var circleOffset = SKShapeNode(circleOfRadius: radius)
        circleOffset.strokeColor = circleColor.darkerColor(0.1)
        circleOffset.lineWidth = thickness
        circleOffset.position = CGPoint(x: 0, y: -3)
        circleOffset.zPosition = -1
        self.addChild(circleOffset)
        
        let arcpath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 0.0, endAngle: sizeOfArc, clockwise: true)
        arc = SKShapeNode(path: arcpath.CGPath)
        arc.lineCap = kCGLineCapRound
        arc.strokeColor = arcColor
        arc.antialiased = true
        arc.zPosition = 1
        arc.lineWidth = thickness + 0.5 // one pixel more because of the linewidth of the circle itself
        
        // Setup PhysicsBody of Arc
        var currentpoint = CGPointMake(radius, 0)
        var physicsparts = 10;
        var bodypath : CGMutablePath = CGPathCreateMutable();
        var offsetangle = CGFloat(self.sizeOfArc / CGFloat(physicsparts))
        
        for var index = 0; index < physicsparts + 1; index++ {
            CGPathAddArc(bodypath, nil, currentpoint.x, currentpoint.y, CGFloat(thickness / 2), CGFloat(2 * M_PI), 0, true)
            currentpoint = CGPointApplyAffineTransform(currentpoint, CGAffineTransformMakeRotation(offsetangle));
        }
        
        arc.physicsBody = SKPhysicsBody(polygonFromPath: bodypath)
        arc.physicsBody!.categoryBitMask = PhysicsCategory.arc.rawValue
        arc.physicsBody!.contactTestBitMask = PhysicsCategory.ball.rawValue
        arc.physicsBody!.collisionBitMask = 0
        arc.physicsBody!.usesPreciseCollisionDetection = true
        arc.physicsBody!.dynamic = true
        
        // Setup animation
        var rotationangle : CGFloat
        if clockwise {
            rotationangle = CGFloat(2 * M_PI)
        }
        else {
            rotationangle = -CGFloat(2 * M_PI)
        }
        var rotating = SKAction.repeatActionForever(SKAction.rotateByAngle(rotationangle, duration: secondsPerRound))
        arc.runAction(rotating, withKey: "arcRotationAnimation")
        
        self.nodeColor = arcColor
        self.pointsPerHit = pointsPerHit
        
        self.addChild(arc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn() -> Circle {
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
    
    func modifySpeedBy(factor: CGFloat) {
        var action = arc.actionForKey("arcRotationAnimation")?
        action?.speed *= factor
    }
    
}