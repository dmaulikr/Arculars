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
}