//
//  Score.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import SpriteKit

class Score : SKLabelNode {
    
    private var currentScore : UInt32 = 0
    
    init(position: CGPoint) {
        super.init()
        
        self.fontName = "Helvetica Neue UltraLight"
        self.fontColor = Colors.FontColor
        self.fontSize = 30
        self.position = position
        updateText()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateText() {
        self.text = "Score \(currentScore)"
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
        self.text = "Score \(currentScore)"
    }
}