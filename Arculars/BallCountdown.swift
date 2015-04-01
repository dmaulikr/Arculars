//
//  PointCountdown.swift
//  Arculars
//
//  Created by Roman Blum on 26/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

protocol BallCountdownDelegate : class {
    func ballCountdownExpired()
}

class BallCountdown : SKNode {
    
    weak var delegate : BallCountdownDelegate!
    
    private var remaining = 0
    private var timer = NSTimer()
    private let seconds : Int!
    private var parts = [SKShapeNode]()
    
    init(rect: CGRect, seconds: Int) {
        super.init()
        
        self.seconds = seconds
        
        self.zPosition = 2
        
        var diameter = rect.height
        var radius = diameter / 3
        var gap = (diameter - radius) / 2
        
        for index in 0...(seconds - 1) {
            var part = SKShapeNode(circleOfRadius: radius)
            part.fillColor = Colors.FontColor
            part.strokeColor = Colors.FontColor
            part.lineWidth = 1
            var xPos = radius + gap + (CGFloat(index) * ((radius * 2) + (gap * 2)))
            var yPos = CGFloat(rect.height / 2)
            part.position = CGPoint(x: xPos, y: yPos)
            parts.append(part)
            self.addChild(part)
        }
        
        self.position = CGPoint(
            x: rect.origin.x - self.calculateAccumulatedFrame().width / 2,
            y: rect.midY
        )
    }
    
    func start() {
        stop()
        reset()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
    }
    
    func reset() {
        remaining = seconds
        updateDisplay()
    }
    
    func stop() {
        timer.invalidate()
    }
    
    private func updateDisplay() {
        if remaining < 0 { return }
        
        if remaining > 0 {
            for i1 in 0...(remaining - 1) {
                parts[i1].hidden = false
            }
        }
        if remaining < seconds {
            for i2 in (remaining)...(seconds - 1) {
                parts[i2].hidden = true
            }
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tick(timer: NSTimer) {
        remaining = remaining - 1
        updateDisplay()
        
        if remaining == 0 {
            delegate.ballCountdownExpired()
        }
    }
}