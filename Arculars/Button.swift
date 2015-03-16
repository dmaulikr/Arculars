//
//  Button.swift
//  Arculars
//
//  Created by Roman Blum on 15/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Button {
    
    var button : SKShapeNode!
    
    private var name : String
    private var position : CGPoint!
    private var color : UIColor!
    private var content : SKNode!
    private var radius : CGFloat!
    
    init(name: String, position: CGPoint, color: UIColor, content: SKNode, radius: CGFloat) {
        self.name = name
        self.position = position
        self.color = color
        self.content = content
        self.radius = radius
    }
    
    func addTo(parentNode: SKSpriteNode) -> Button {
        button = SKShapeNode(circleOfRadius: radius)
        button.fillColor = color
        button.strokeColor = color
        button.zPosition = 0
        button.lineWidth = 1
        button.position = position
        
        var buttonOffset = SKShapeNode(circleOfRadius: radius)
        buttonOffset.fillColor = color.darkerColor(0.1)
        buttonOffset.strokeColor = color.darkerColor(0.1)
        buttonOffset.lineWidth = 1
        buttonOffset.zPosition = -1
        buttonOffset.position = CGPoint(x: 0, y: -3)
        button.addChild(buttonOffset)
        
        content.zPosition = 1
        button.addChild(content)
        
        var touchNode = SKShapeNode(circleOfRadius: radius)
        touchNode.zPosition = 10
        touchNode.lineWidth = 0
        touchNode.name = name
        button.addChild(touchNode)
        
        button.xScale = 0.0
        button.yScale = 0.0
        
        parentNode.addChild(button)
        
        
        button.runAction(
            SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.15),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.0, duration: 0.1)
                ])
        )
        
        return self
    }
}