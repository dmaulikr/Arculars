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
    
    private var rotateAction : SKAction!
    private var arc : SKShapeNode!
    
    let thickness : CGFloat!
    let radius : CGFloat!
    var nodeColor : UIColor!
    let pointsPerHit : Int!
    
    var minSpeed : NSTimeInterval!
    var maxSpeed : NSTimeInterval!
    
    init(position: CGPoint, radius: CGFloat, thickness: CGFloat, clockwise: Bool, pointsPerHit: Int) {
        self.pointsPerHit = pointsPerHit
        self.radius = radius
        self.thickness = thickness
        
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius, CGFloat(M_PI * 2), 0, true)
        path = circlepath
        lineWidth = thickness
        zPosition = 0
        antialiased = true
        self.position = position
        
        let sizeOfArc = CGFloat(M_PI / 2)
        let arcpath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: 0.0, endAngle: sizeOfArc, clockwise: true)
        arc = SKShapeNode(path: arcpath.CGPath)
        arc.lineCap = kCGLineCapRound
        arc.antialiased = true
        arc.zPosition = 1
        arc.lineWidth = thickness
        
        // Setup PhysicsBody of Arc
        var bodypath : CGMutablePath = CGPathCreateMutable();
        var offsetangle = CGFloat(sizeOfArc / 9)
        
        var p1 = CGPointApplyAffineTransform(CGPoint(x: 0, y: CGFloat(radius - (thickness / 6))), CGAffineTransformMakeRotation(offsetangle))
        CGPathMoveToPoint(bodypath, nil, p1.x, p1.y)
        var p2 = CGPointApplyAffineTransform(CGPoint(x: 0, y: CGFloat(radius + (thickness / 6))), CGAffineTransformMakeRotation(offsetangle))
        CGPathAddLineToPoint(bodypath, nil, p2.x, p2.y)
        CGPathAddArc(bodypath, nil, 0, 0, CGFloat(radius + (thickness / 6)), CGFloat(sizeOfArc + offsetangle), -CGFloat(offsetangle), true)
        var p3 = CGPointApplyAffineTransform(CGPoint(x: CGFloat(radius - (thickness / 6)), y: 0), CGAffineTransformMakeRotation(-offsetangle))
        CGPathAddLineToPoint(bodypath, nil, p3.x, p3.y)
        CGPathAddArc(bodypath, nil, 0, 0, CGFloat(radius - (thickness / 6)), -CGFloat(offsetangle), CGFloat(sizeOfArc + offsetangle), false)
        CGPathCloseSubpath(bodypath)
        
        arc.physicsBody = SKPhysicsBody(polygonFromPath: bodypath)
        arc.physicsBody!.categoryBitMask = PhysicsCategory.arc.rawValue
        arc.physicsBody!.contactTestBitMask = PhysicsCategory.ball.rawValue
        arc.physicsBody!.collisionBitMask = 0
        arc.physicsBody!.dynamic = false

        // Setup animation
        var rotationangle : CGFloat
        if clockwise {
            rotationangle = CGFloat(2 * M_PI)
        }
        else {
            rotationangle = -CGFloat(2 * M_PI)
        }
        rotateAction = SKAction.rotateByAngle(rotationangle, duration: 0.0)
        
        addChild(arc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn() -> Circle {
        
        // disable the physicsbody because otherwise this will fail
        let temp = arc.physicsBody
        arc.physicsBody = nil
        
        xScale = 0.0
        yScale = 0.0
        
        runAction(
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.1),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.0, duration: 0.1)
                ]), completion: {()
            self.arc.physicsBody = temp
        })
        
        return self
    }
    
    func setColor(color: UIColor) {
        arc.strokeColor = color
        strokeColor = color.colorWithAlphaComponent(0.2)
        nodeColor = color
    }
    
    func setSpeed(min: NSTimeInterval, max: NSTimeInterval) {
        minSpeed = min
        maxSpeed = max
        updateAction()
    }
    
    /*
    *
    *   This method updates itself by creating an action 
    *   with a random duration between minSpeed and maxSpeed
    *   and is executed random times between 5 and 10
    *
    */
    private func updateAction() {
        var times = Int(arc4random_uniform(5) + 5)
        var duration = NSTimeInterval(arc4random_uniform(UInt32(maxSpeed * 10) - UInt32(minSpeed * 10)) / 10) + minSpeed
        
        rotateAction.duration = duration
        var action = SKAction.repeatAction(rotateAction, count: times)
        
        arc.removeAllActions()
        arc.runAction(action, completion: {()
            self.updateAction()
        })
    }
}