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
    class func getBottomButton(size: CGSize, content: String) -> SKShapeNode {
        // INIT CLOSE BUTTON
        var closeLabel = SKLabelNode(text: content)
        closeLabel.position = Positions.getBottomPosition(size)
        closeLabel.fontName = Fonts.FontNameLight
        closeLabel.fontColor = Colors.DisabledColor
        closeLabel.fontSize = size.height / 32
        closeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        closeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        var btnClose = SKShapeNode(rect: CGRect(x: closeLabel.position.x - closeLabel.frame.width, y: closeLabel.position.y - closeLabel.frame.height, width: closeLabel.frame.width * 2, height: closeLabel.frame.height * 2))
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
}