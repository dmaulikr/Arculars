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
    private var count : Int!
    
    init(radius: CGFloat, type: PowerupType) {
        super.init()
        
        powerupType = type
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius - 1, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.fillColor = Colors.PowerupColor
        self.strokeColor = Colors.PowerupColor
        self.lineWidth = 1
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody!.categoryBitMask = PhysicsCategory.powerup.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.dynamic = true
        
        label = SKLabelNode(text: "00")
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.fontSize = self.frame.height / 2
        label.fontName = Fonts.FontNameBold
        label.fontColor = Colors.PowerupColor
        label.hidden = true
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn() -> Powerup {
        
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
    
    func fadeOut() -> Powerup {
        self.runAction(SKAction.scaleTo(0.0, duration: 0.1), completion: {()
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
        self.physicsBody = nil
        
        count = seconds
        updateText()
        label.hidden = false
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