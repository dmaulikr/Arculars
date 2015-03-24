//
//  Timer.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

class Countdown : SKLabelNode {

    var countdownDelegate : CountdownDelegate!

    private var remaining : Int
    private var timer : NSTimer!
    private let seconds : Int
    
    init(position: CGPoint, seconds: Int) {
        self.seconds = seconds
        remaining = seconds
        
        super.init()
        
        self.zPosition = 2
        self.fontName = "Avenir-Light"
        self.fontColor = Colors.FontColor
        self.fontSize = 20
        self.position = position
        
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
        remaining--
        updateText()
        
        if remaining == 0 {
            stop()
            countdownDelegate.countdownFinished()
        }
    }
}