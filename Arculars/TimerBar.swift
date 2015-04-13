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
    func timerBarZero()
}

class TimerBar : SKNode {
    
    weak var delegate : TimerBarDelegate!
    
    
    private var max : Double!
    private var current : Double!
    
    private var bar : SKSpriteNode!
    private var interval = 0.5
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, color: UIColor, max: Double) {
        super.init()
        
        self.max = max
        self.zPosition = 100
        
        bar = SKSpriteNode(color: color, size: size)
        bar.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        addChild(bar)
    }
    
    func start() {
        stop()
        reset()
    }
    
    func reset() {
        current = 0
        bar.removeAllActions()
        bar.runAction(SKAction.scaleXTo(1.0, duration: 1.0), completion: {()
            var wait = SKAction.waitForDuration(self.interval)
            var run = SKAction.runBlock({
                self.timerBarTick()
            })
            self.bar.runAction(SKAction.repeatActionForever(SKAction.sequence([run, wait])), withKey: "timer")
        })
    }
    
    func stop() {
        bar.removeActionForKey("timer")
    }
    
    func addTime(seconds: Double) {
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
    
    func timerBarTick() {
        current = current + interval
        var scale = 1.0 - (CGFloat(1.0 / CGFloat(max)) * CGFloat(current))
        bar.runAction(SKAction.scaleXTo(scale, duration: 1.0), completion: {()
            if scale <= 0 {
                self.delegate.timerBarZero()
            }
        })
    }
}