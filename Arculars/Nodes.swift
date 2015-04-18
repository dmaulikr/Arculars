//
//  Nodes.swift
//  Arculars
//
//  Created by Roman Blum on 16/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Nodes {
    class func getTextButton(size: CGSize, content: String) -> SKShapeNode {
        var closeLabel = SKLabelNode(text: content)
        closeLabel.position = Positions.getBottomPosition(size)
        closeLabel.fontName = Fonts.FontNameLight
        closeLabel.fontColor = Colors.DisabledColor
        closeLabel.fontSize = size.height / 32
        closeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        closeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        var btnClose = SKShapeNode(rect: CGRect(x: closeLabel.position.x - closeLabel.frame.width, y: closeLabel.position.y - (closeLabel.frame.height * 2), width: closeLabel.frame.width * 2, height: closeLabel.frame.height * 4))
        btnClose.lineWidth = 0
        btnClose.addChild(closeLabel)
        return btnClose
    }
    
    class func getSceneTitle(size: CGSize, content: String) -> SKShapeNode {
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: size.height / 12))
        title.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: content)
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        return title
    }
    
    class func getCircleButton(position: CGPoint, radius: CGFloat, color: UIColor, content1: String) -> SKShapeNode {
        return Nodes.getCircleButton(position, radius: radius, color: color, fontSize: radius / 3, content1: content1, content2: "")
    }
    class func getCircleButton(position: CGPoint, radius: CGFloat, color: UIColor, fontSize: CGFloat, content1: String) -> SKShapeNode {
        return Nodes.getCircleButton(position, radius: radius, color: color, fontSize: fontSize, content1: content1, content2: "")
    }
    class func getCircleButton(position: CGPoint, radius: CGFloat, color: UIColor, content1: String, content2: String) -> SKShapeNode {
        return Nodes.getCircleButton(position, radius: radius, color: color, fontSize: radius / 3, content1: content1, content2: content2)
    }
    class func getCircleButton(position: CGPoint, radius: CGFloat, color: UIColor, fontSize: CGFloat, content1: String, content2: String) -> SKShapeNode {
        
        var button = SKShapeNode(circleOfRadius: radius)
        button.position = position
        button.lineWidth = 1
        button.strokeColor = color
        button.fillColor = button.strokeColor
        
        var label = SKLabelNode(text: content1)
        label.userInteractionEnabled = false
        label.fontSize = fontSize
        label.fontName = Fonts.FontNameLight
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        if (content2 == "") {
            label.position = CGPoint(x: 0, y: 0)
        } else {
            var label2 = label.copy() as! SKLabelNode
            label2.text = content2
            label2.position = CGPoint(x: 0, y: -(label.frame.height))
            label.addChild(label2)
            label.position = CGPoint(x: 0, y: label.calculateAccumulatedFrame().height / 4)
        }
        
        button.addChild(label)
        return button
    }
}