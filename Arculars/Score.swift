//
//  Score.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import SpriteKit

class Score {
    private var score: SKLabelNode!
    private var currentScore = 0
    
    init(){}
    
    func addTo(parentNode: SKSpriteNode) -> Score {
        score = SKLabelNode(text: "Score \(currentScore)")
        score.fontName = "Helvetica Neue UltraLight"
        score.fontColor = Colors.FontColor
        score.fontSize = 30
        score.position = CGPoint(x: 0, y: -(parentNode.size.height / 2) + 32)
        parentNode.addChild(score)
        return self
    }
    
    func increase() {
        currentScore += 1
        score.text = "Score \(currentScore)"
    }
}