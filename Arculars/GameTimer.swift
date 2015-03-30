//
//  Timer.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimer : SKLabelNode {

    var delegate : GameTimerDelegate!

    private var remaining : Int!
    private var timer = NSTimer()
    private let seconds : Int!
    
    init(position: CGPoint, seconds: Int) {
        super.init()
        
        self.seconds = seconds
        self.remaining = seconds
        
        self.zPosition = 2
        self.fontName = Fonts.FontNameLight
        self.fontColor = Colors.FontColor
        self.fontSize = 20
        self.position = position
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        updateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
    }
    
    func reset() {
        remaining = seconds
        updateText()
    }
    
    func stop() {
        timer.invalidate()
    }
    
    private func updateText() {
        self.text = "\(remaining)"
    }
    
    @objc func tick(timer: NSTimer) {
        remaining = remaining - 1
        updateText()
        
        if remaining == 0 {
            stop()
            delegate.gameTimerFinished()
        }
    }
}