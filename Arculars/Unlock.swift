//
//  Unlock.swift
//  Arculars
//
//  Created by Roman Blum on 07/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import SpriteKit

class Unlock : SKShapeNode {
    
    private var color : UIColor!
    private var fontColor : UIColor!
    
    private var cost : UInt32!
    private var unlockedText : String!
    private var label : SKLabelNode!
    
    init(radius: CGFloat, cost: UInt32, color: UIColor, fontColor: UIColor, unlockedText: String) {
        super.init()
        
        self.color = color
        self.fontColor = fontColor
        self.cost = cost
        self.unlockedText = unlockedText
        
        var circlepath = CGPathCreateMutable()
        CGPathAddArc(circlepath, nil, 0, 0, radius - 1, CGFloat(M_PI * 2), 0, true)
        path = circlepath
        antialiased = true
        fillColor = color
        strokeColor = color
        lineWidth = 1
        
        label = SKLabelNode(text: "\(cost)")
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.fontSize = frame.height / 6
        label.fontName = Fonts.FontNameLight
        label.fontColor = fontColor
        addChild(label)
    }
    
    func setActive() {
        label.fontColor = fillColor
        label.text = unlockedText
        fillColor = UIColor.clearColor()
    }
    
    func setUnlocked() {
        fillColor = color
        label.fontColor = fontColor
        label.text = unlockedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

