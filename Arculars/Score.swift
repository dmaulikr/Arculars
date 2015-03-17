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
    private var currentScore : UInt32 = 0
    
    init(){}
    
    func addTo(parentNode: SKSpriteNode) -> Score {
        score = SKLabelNode()
        score.fontName = "Helvetica Neue UltraLight"
        score.fontColor = Colors.FontColor
        score.fontSize = 30
        score.position = CGPoint(x: 0, y: -(parentNode.size.height / 2) + 32)
        updateText()
        parentNode.addChild(score)
        return self
    }
    
    private func updateText() {
        score.text = "Score \(currentScore)"
    }
    
    func increase() {
        currentScore += 1
        updateText()
    }
    
    func increaseBy(newScore: UInt32) {
        currentScore += newScore
        updateText()
    }
    
    func getScore() -> UInt32 {
        return currentScore
    }
    
    func reset() {
        currentScore = 0
        score.text = "Score \(currentScore)"
    }
}