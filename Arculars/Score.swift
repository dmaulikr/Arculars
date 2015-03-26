//
//  Score.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import SpriteKit

class Score : SKLabelNode {
    
    private var currentScore : Int = 0
    
    init(position: CGPoint) {
        super.init()
        
        self.zPosition = 2
        self.fontName = "Avenir-Black"
        self.fontColor = Colors.FontColor
        self.fontSize = 26
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
        self.increaseBy(1)
    }
    
    func increaseBy(newScore: Int) {
        self.currentScore += newScore
        self.updateText()
        
    }
    
    func increaseByWithColor(newScore: Int, color: UIColor) {
        var label = SKLabelNode(text: "+\(newScore)")
        
        // Calculate position
        var x = (self.frame.width / 2) + (label.frame.width / 2) + 8 
        
        label.position = CGPoint(x: x, y: 0)
        label.fontColor = color
        label.fontName = "Avenir-Black"
        label.xScale = 0.0
        label.yScale = 0.0
        label.zPosition = 1
        self.addChild(label)
        
        var fadeIn = SKAction.scaleTo(1.0, duration: 0.1)
        var wait = SKAction.waitForDuration(0.2)
        var fadeOut = SKAction.group([SKAction.moveTo(CGPoint(x: (self.frame.width / 2), y: 0), duration: 0.2), SKAction.fadeAlphaTo(0.0, duration: 0.2)])
        var sequence = SKAction.sequence([fadeIn, wait, fadeOut])
        
        label.runAction(sequence, completion: {()
            self.increaseBy(newScore)
        })
    }
    
    func getScore() -> Int {
        return currentScore
    }
    
    func reset() {
        currentScore = 0
        self.text = "Score \(currentScore)"
    }
}