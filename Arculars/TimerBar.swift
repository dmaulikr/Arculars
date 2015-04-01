//
//  TimerBar.swift
//  Arculars
//
//  Created by Roman Blum on 01/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

protocol TimerBarDelegate : class {
    func timerBarExpired()
}

class TimerBar : SKNode {
    
    weak var delegate : TimerBarDelegate!
    
    private var max : Int!
    private var current : Int!
    private var bar : SKSpriteNode!
    
    private var timer = NSTimer()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, color: UIColor, max: Int) {
        super.init()
        
        self.max = max
        
        bar = SKSpriteNode(color: color, size: size)
        bar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(bar)
    }
    
    func start() {
        stop()
        reset()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
    }
    
    func reset() {
        current = 0
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func add(seconds: Int) {
        current = current - seconds
        if current < 0 {
            current = 0
        }
        if seconds < 0 {
            bar.runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(0.1, duration: 0.2),
                SKAction.fadeAlphaTo(1.0, duration: 0.2)
            ]))
        }
    }
    
    @objc func tick(timer: NSTimer) {
        current = current + 1
        var scale = 1.0 - (CGFloat(1.0 / CGFloat(max)) * CGFloat(current))
        bar.runAction(SKAction.scaleXTo(scale, duration: 1.0))
        
        if current >= max {
            stop()
            delegate.timerBarExpired()
        }
    }
}