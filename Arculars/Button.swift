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
    
    private var button : SKShapeNode!
    private var position : CGPoint!
    private var color : UIColor!
    private var image : String!
    private var radius : CGFloat!
    
    init(position: CGPoint, color: UIColor, image: String, radius: CGFloat) {
        self.position = position
        self.color = color
        self.image = image
        self.radius = radius
    }
    
    func addTo(parentNode: SKSpriteNode) -> Button {
        button = SKShapeNode(circleOfRadius: radius)
        button.fillColor = color
        button.strokeColor = color
        button.zPosition = 0
        button.lineWidth = 1
        button.position = position
        
        var buttonImage = SKSpriteNode(imageNamed: image)
        buttonImage.position = CGPoint(x: 0, y: 0)
        buttonImage.zPosition = 1
        button.addChild(buttonImage)
        
        var buttonOffset = SKShapeNode(circleOfRadius: radius)
        buttonOffset.fillColor = color.darkerColor(0.1)
        buttonOffset.strokeColor = color.darkerColor(0.1)
        buttonOffset.lineWidth = 1
        buttonOffset.zPosition = -1
        buttonOffset.position = CGPoint(x: 0, y: -3)
        button.addChild(buttonOffset)
        
        parentNode.addChild(button)
        return self
    }
    
    func containsPoint(location: CGPoint) -> Bool {
        var rect = CGRect(x: position.x - radius, y: position.y - radius, width: radius * 2, height: radius * 2)
        if CGRectContainsPoint(rect, location) {
            return true
        }
        return false
    }
}