//
//  HealthBar.swift
//  Arculars
//
//  Created by Roman Blum on 01/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

protocol HealthBarDelegate : class {
    func healthBarZero()
}

class HealthBar : SKNode {
    
    weak var delegate : HealthBarDelegate!
    
    private var slots = [SKShapeNode]()
    private var current : Int!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, color: UIColor, max: Int) {
        super.init()
        
        self.zPosition = 100
        
        var gapSize = CGFloat(size.width / 64)
        var slotSize : CGFloat = ((size.width - (CGFloat(max - 1) * gapSize)) / CGFloat(max))
        for index in 0...(max - 1) {
            var slot = SKShapeNode(rect: CGRect(
                x: (CGFloat(index) * gapSize) + (CGFloat(index) * slotSize),
                y: 0,
                width: slotSize,
                height: size.height)
            )
            slot.lineWidth = 0
            slot.fillColor = color
            slots.append(slot)
            addChild(slot)
        }
        
        self.current = max
    }
    
    func isFull() -> Bool {
        return slots.count == current
    }
    
    func increment() {
        if current < (slots.count - 1) {
            current = current + 1
            slots[current].runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(1.0, duration: 0.2),
                SKAction.fadeAlphaTo(0.1, duration: 0.2),
                SKAction.fadeAlphaTo(1.0, duration: 0.2)
            ]))
        }
    }
    
    func decrement() {
        current = current - 1
        if current > 0 {
            slots[current].runAction(SKAction.sequence([
                SKAction.fadeAlphaTo(0.1, duration: 0.2),
                SKAction.fadeAlphaTo(1.0, duration: 0.2),
                SKAction.fadeAlphaTo(0.0, duration: 0.2)
            ]))
        } else {
            delegate.healthBarZero()
        }
    }
    
    func reset() {
        current = slots.count
        
        for slot in slots {
            slot.alpha = 1.0
        }
    }
}