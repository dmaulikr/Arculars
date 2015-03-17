//
//  Button.swift
//  Arculars
//
//  Created by Roman Blum on 15/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Button : SKShapeNode {
    
    init(name: String, position: CGPoint, color: UIColor, content: SKNode, radius: CGFloat) {
        super.init()
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius, CGFloat(M_PI * 2), 0, true)
        self.path = circlepath
        self.fillColor = color
        self.strokeColor = color
        self.zPosition = 0
        self.lineWidth = 1
        self.position = position
        
        var buttonOffset = SKShapeNode(circleOfRadius: radius)
        buttonOffset.fillColor = color.darkerColor(0.1)
        buttonOffset.strokeColor = color.darkerColor(0.1)
        buttonOffset.lineWidth = 1
        buttonOffset.zPosition = -1
        buttonOffset.position = CGPoint(x: 0, y: -3)
        self.addChild(buttonOffset)
        
        content.zPosition = 1
        self.addChild(content)
        
        var touchNode = SKShapeNode(circleOfRadius: radius)
        touchNode.zPosition = 10
        touchNode.lineWidth = 0
        touchNode.name = name
        self.addChild(touchNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fadeIn() -> Button {
        
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
    
    func fadeOut() -> Button {
        self.runAction(SKAction.scaleTo(0.0, duration: 0.3))
        return self
    }
}