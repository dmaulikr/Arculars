//
//  Powerup.swift
//  Arculars
//
//  Created by Roman Blum on 06/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

protocol PowerupDelegate : class {
    func powerupExpired()
}

class Powerup : SKShapeNode {
    
    var delegate : PowerupDelegate!
    var powerupType : PowerupType!
    
    private var timer = NSTimer()
    
    private var label : SKLabelNode!
    private var icon : SKSpriteNode!
    private var count : Int!
    
    init(radius: CGFloat, type: PowerupType) {
        super.init()
        
        powerupType = type
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius - 1, CGFloat(M_PI * 2), 0, true)
        path = circlepath
        fillColor = Colors.PowerupColor
        strokeColor = Colors.PowerupColor
        lineWidth = 1
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.categoryBitMask = PhysicsCategory.powerup.rawValue
        physicsBody!.contactTestBitMask = PhysicsCategory.ball.rawValue
        physicsBody!.collisionBitMask = 0
        physicsBody!.dynamic = true
        
        label = SKLabelNode(text: "0")
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.fontSize = frame.height / 2
        label.fontName = Fonts.FontNameBold
        label.fontColor = Colors.PowerupColor
        label.hidden = true
        
        icon = SKSpriteNode(imageNamed: "icon-star")
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        icon.size = CGSize(width: radius, height: radius)
        addChild(icon)
        
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn() -> Powerup {
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
    
    func fadeOut() -> Powerup {
        runAction(SKAction.scaleTo(0.0, duration: 0.1), completion: {()
            self.removeFromParent()
        })
        return self
    }
    
    func setCount(count: Int) {
        self.count = count
    }
    
    func decrement() {
        count = count - 1
        updateText()
        if count <= 0 {
            delegate.powerupExpired()
        }
    }
    
    func startWith(seconds: Int) {
        physicsBody = nil
        icon.hidden = true
        label.hidden = false
        
        count = seconds
        updateText()
        fillColor = UIColor.clearColor()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
    }
    
    private func updateText() {
        label.text = "\(count)"
    }
    
    @objc func tick(timer: NSTimer) {
        decrement()
    }
}