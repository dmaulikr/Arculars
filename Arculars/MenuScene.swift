//
//  MenuScene.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var distance : CGFloat!
    
    private var btnAbout : SKShapeNode!
    private var btnGo : SKShapeNode!
    private var btnStats : SKShapeNode!
    private var btnSettings: SKShapeNode!
    private var btnPlayEndless: SKShapeNode!
    private var btnPlayTimed : SKShapeNode!
    private var dashedCircle : SKShapeNode!
    
    // Actions
    private var go_action : SKAction!
    private var go_action_normal : SKAction!
    private var go_action_reversed : SKAction!
    private var stats_action : SKAction!
    private var playe_action : SKAction!
    private var playt_action : SKAction!
    private var settings_action : SKAction!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.Background
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.3))
    }
    
    override func willMoveFromView(view: SKView) {
        // Explicitly set actions to nil so deinit is called
        go_action = nil
        go_action_normal = nil
        go_action_reversed = nil
        settings_action = nil
        stats_action = nil
        playe_action = nil
        playt_action = nil
    }
    
    deinit {
        #if DEBUG
            println("MenuScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        initButtons()
        initActions()
        
        var title = SKLabelNode(text: "ARCULARS")
        title.fontName = Fonts.FontNameBold
        title.fontSize = size.height / 16
        title.fontColor = Colors.FontColor
        title.position = CGPoint(x: 0, y: (size.height / 6) * 2)
        rootNode.addChild(title)
    }
    
    private func initButtons() {
        var radius = size.height / 18
        
        // INIT ABOUT BUTTON
        btnAbout = SKShapeNode(rectOfSize: CGSize(width: size.width, height: size.height / 12))
        btnAbout.position = CGPoint(x: 0, y: -(size.height / 2) + (btnAbout.frame.height / 2))
        btnAbout.lineWidth = 0
        btnAbout.strokeColor = UIColor.clearColor()
        btnAbout.fillColor = UIColor.clearColor()
        var aboutLabel = SKLabelNode(text: "ABOUT")
        aboutLabel.name = "label"
        aboutLabel.fontSize = size.height / 32
        aboutLabel.fontName = Fonts.FontNameBold
        aboutLabel.fontColor = UIColor.grayColor()
        aboutLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        aboutLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnAbout.addChild(aboutLabel)
        rootNode.addChild(btnAbout)
        
        // INIT GO BUTTON
        btnGo = SKShapeNode(circleOfRadius: radius)
        btnGo.strokeColor = Colors.AppColorThree
        btnGo.lineWidth = 2
        btnGo.antialiased = true
        btnGo.position = CGPoint(x: 0, y: 0)
        
        distance = (radius * 3)
        
        var goContent = SKShapeNode(circleOfRadius: radius)
        goContent.fillColor = Colors.AppColorThree
        goContent.strokeColor = Colors.AppColorThree
        goContent.lineWidth = 1
        goContent.antialiased = true
        goContent.name = "content"
        btnGo.addChild(goContent)
        var goLabel = SKLabelNode(text: "GO")
        goLabel.fontName = Fonts.FontNameBold
        goLabel.fontSize = size.height / 24
        goLabel.position = CGPoint(x: 0, y: -goLabel.frame.height / 2)
        goContent.addChild(goLabel)
        rootNode.addChild(btnGo)
        
        var bezierpath = UIBezierPath()
        bezierpath.addArcWithCenter(btnGo.position, radius: distance, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        var dashed = CGPathCreateCopyByDashingPath(bezierpath.CGPath, nil, 0, [10.0,10.0], 2)
        dashedCircle = SKShapeNode(path: dashed)
        dashedCircle.position = btnGo.position
        dashedCircle.fillColor = UIColor.clearColor()
        dashedCircle.lineWidth = 1
        dashedCircle.strokeColor = Colors.FontColor
        dashedCircle.zPosition = -10
        dashedCircle.xScale = 0.0
        dashedCircle.yScale = 0.0
        btnGo.addChild(dashedCircle)
        
        // INIT STATS BUTTON
        btnStats = SKShapeNode(circleOfRadius: radius)
        btnStats.fillColor = Colors.AppColorThree
        btnStats.strokeColor = Colors.AppColorThree
        btnStats.lineWidth = 1
        btnStats.antialiased = true
        btnStats.position = CGPoint(x: 0, y: 0)
        btnStats.xScale = 0.0
        btnStats.yScale = 0.0
        btnStats.zPosition = -1
        var statsIcon = SKSpriteNode(imageNamed: "icon-statistics")
        statsIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnStats.addChild(statsIcon)
        btnGo.addChild(btnStats)
        
        var statsLabel = SKLabelNode(text: "Stats")
        statsLabel.name = "label"
        statsLabel.fontName = Fonts.FontNameLight
        statsLabel.fontSize = size.height / 40
        statsLabel.position = CGPoint(x: 0, y: -(1.75 * radius))
        statsLabel.alpha = 0.0
        btnStats.addChild(statsLabel)
        
        // INIT SETTINGS BUTTON
        btnSettings = SKShapeNode(circleOfRadius: radius)
        btnSettings.fillColor = Colors.AppColorThree
        btnSettings.strokeColor = Colors.AppColorThree
        btnSettings.lineWidth = 1
        btnSettings.antialiased = true
        btnSettings.position = CGPoint(x: 0, y: 0)
        btnSettings.xScale = 0.0
        btnSettings.yScale = 0.0
        btnSettings.zPosition = -1
        var settingsIcon = SKSpriteNode(imageNamed: "icon-settings")
        settingsIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnSettings.addChild(settingsIcon)
        btnGo.addChild(btnSettings)
        
        var settingsLabel = SKLabelNode(text: "Settings")
        settingsLabel.name = "label"
        settingsLabel.fontName = Fonts.FontNameLight
        settingsLabel.fontSize = size.height / 40
        settingsLabel.position = CGPoint(x: 0, y: -(1.75 * radius))
        settingsLabel.alpha = 0.0
        btnSettings.addChild(settingsLabel)
        
        // INIT TIMED GAME BUTTON
        btnPlayTimed = SKShapeNode(circleOfRadius: radius)
        btnPlayTimed.fillColor = Colors.AppColorThree
        btnPlayTimed.strokeColor = Colors.AppColorThree
        btnPlayTimed.lineWidth = 1
        btnPlayTimed.antialiased = true
        btnPlayTimed.position = CGPoint(x: 0, y: 0)
        btnPlayTimed.xScale = 0.0
        btnPlayTimed.yScale = 0.0
        btnPlayTimed.zPosition = -1
        var clockIcon = SKSpriteNode(imageNamed: "icon-clock")
        clockIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnPlayTimed.addChild(clockIcon)
        btnGo.addChild(btnPlayTimed)
        
        var playtLabel = SKLabelNode(text: "Timed")
        playtLabel.name = "label"
        playtLabel.fontName = Fonts.FontNameLight
        playtLabel.fontSize = size.height / 40
        playtLabel.position = CGPoint(x: 0, y: (1.25 * radius))
        playtLabel.alpha = 0.0
        btnPlayTimed.addChild(playtLabel)
        
        // INIT ENDLESS GAME BUTTON
        btnPlayEndless = SKShapeNode(circleOfRadius: radius)
        btnPlayEndless.fillColor = Colors.AppColorThree
        btnPlayEndless.strokeColor = Colors.AppColorThree
        btnPlayEndless.lineWidth = 1
        btnPlayEndless.antialiased = true
        btnPlayEndless.position = CGPoint(x: 0, y: 0)
        btnPlayEndless.xScale = 0.0
        btnPlayEndless.yScale = 0.0
        btnPlayEndless.zPosition = -1
        var iconInfinity = SKSpriteNode(imageNamed: "icon-infinity")
        iconInfinity.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnPlayEndless.addChild(iconInfinity)
        btnGo.addChild(btnPlayEndless)
        
        var playeLabel = SKLabelNode(text: "Endless")
        playeLabel.name = "label"
        playeLabel.fontName = Fonts.FontNameLight
        playeLabel.fontSize = size.height / 40
        playeLabel.position = CGPoint(x: 0, y: (1.25 * radius))
        playeLabel.alpha = 0.0
        btnPlayEndless.addChild(playeLabel)
    }
    
    private func initActions() {
        go_action_normal = SKAction.runBlock({
            var stats_endpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y - self.distance), CGAffineTransformMakeRotation(-CGFloat(M_PI_4)))
            var stats_move = SKAction.moveTo(stats_endpoint, duration: 0.2)
            stats_move.timingMode = SKActionTimingMode.EaseIn
            var stats_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]), completion: {()
                var label = self.btnStats.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var settings_endpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y - self.distance), CGAffineTransformMakeRotation(CGFloat(M_PI_4)))
            var settings_move = SKAction.moveTo(settings_endpoint, duration: 0.2)
            settings_move.timingMode = SKActionTimingMode.EaseIn
            var settings_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]), completion: {()
                var label = self.btnSettings.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var playt_endpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + self.distance), CGAffineTransformMakeRotation(-CGFloat(M_PI_4)))
            var playt_move = SKAction.moveTo(playt_endpoint, duration: 0.2)
            playt_move.timingMode = SKActionTimingMode.EaseIn
            var playt_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var playe_endpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + self.distance), CGAffineTransformMakeRotation(CGFloat(M_PI_4)))
            var playe_move = SKAction.moveTo(playe_endpoint, duration: 0.2)
            playe_move.timingMode = SKActionTimingMode.EaseIn
            var playe_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]), completion: {()
                var label = self.btnPlayEndless.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var dashedcircle_scale = SKAction.scaleTo(1.0, duration: 0.2)
            var dashedcircle_rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: 10.0))
            self.dashedCircle.runAction(SKAction.group([dashedcircle_scale, dashedcircle_rotate]), withKey: "rotating")
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(0.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.go_action = self.go_action_reversed
        })
        
        go_action_reversed = SKAction.runBlock({
            var stats_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            stats_move.timingMode = SKActionTimingMode.EaseIn
            var stats_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]), completion: {()
                var label = self.btnStats.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var settings_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            settings_move.timingMode = SKActionTimingMode.EaseIn
            var settings_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]), completion: {()
                var label = self.btnSettings.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var playt_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playt_move.timingMode = SKActionTimingMode.EaseIn
            var playt_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var playe_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playe_move.timingMode = SKActionTimingMode.EaseIn
            var playe_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]), completion: {()
                var label = self.btnPlayEndless.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var dashedcircle_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.dashedCircle.runAction(dashedcircle_scale, completion: { ()
            })
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(1.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.go_action = self.go_action_normal
        })
        
        stats_action = SKAction.runBlock({
            var single_duration = 0.2
            
            var playt_path = CGPathCreateMutable()
            CGPathMoveToPoint(playt_path, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(playt_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), -CGFloat(M_PI * 0.75), false)
            var playt_move = SKAction.followPath(playt_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playt_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]))
            
            var playe_path = CGPathCreateMutable()
            CGPathMoveToPoint(playe_path, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(playe_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75)  , -CGFloat(M_PI * 0.75), false)
            var playe_move = SKAction.followPath(playe_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playe_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]))
            
            var settings_path = CGPathCreateMutable()
            CGPathMoveToPoint(settings_path, nil, self.btnSettings.position.x, self.btnSettings.position.y)
            CGPathAddArc(settings_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), -CGFloat(M_PI * 0.75), true)
            var settings_move = SKAction.followPath(settings_path, asOffset: false, orientToPath: false, duration: single_duration)
            var settings_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnSettings.zPosition = -2
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var stats_wait = SKAction.waitForDuration(2 * single_duration)
            var stats_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            stats_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnStats.zPosition = 0
            self.btnStats.runAction(SKAction.sequence([stats_wait, stats_move, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showStatsScene()
            })
        })
        
        settings_action = SKAction.runBlock({
            var single_duration = 0.2
            
            var playt_path = CGPathCreateMutable()
            CGPathMoveToPoint(playt_path, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(playt_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), -CGFloat(M_PI / 4), true)
            var playt_move = SKAction.followPath(playt_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playt_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]))
            
            var playe_path = CGPathCreateMutable()
            CGPathMoveToPoint(playe_path, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(playe_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75)  , -CGFloat(M_PI / 4), true)
            var playe_move = SKAction.followPath(playe_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playe_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]))
            
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), -CGFloat(M_PI / 4), false)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: single_duration)
            var stats_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]))
            
            var settings_wait = SKAction.waitForDuration(2 * single_duration)
            var settings_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            settings_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnSettings.zPosition = 0
            self.btnSettings.runAction(SKAction.sequence([settings_wait, settings_move, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showSettingsScene()
            })
        })
        
        playe_action = SKAction.runBlock({
            var single_duration = 0.2
            
            var playt_path = CGPathCreateMutable()
            CGPathMoveToPoint(playt_path, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(playt_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), CGFloat(M_PI * 0.75), false)
            var playt_move = SKAction.followPath(playt_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playt_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]))
            
            var settings_path = CGPathCreateMutable()
            CGPathMoveToPoint(settings_path, nil, self.btnSettings.position.x, self.btnSettings.position.y)
            CGPathAddArc(settings_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), CGFloat(M_PI * 0.75), true)
            var settings_move = SKAction.followPath(settings_path, asOffset: false, orientToPath: false, duration: single_duration)
            var settings_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnSettings.zPosition = -2
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), CGFloat(M_PI * 0.75), true)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: single_duration)
            var stats_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]))
            
            var playe_wait = SKAction.waitForDuration(2 * single_duration)
            var playe_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playe_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayEndless.zPosition = 0
            self.btnPlayEndless.runAction(SKAction.sequence([playe_wait, playe_move, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.startGame(GameMode.Endless)
            })
        })
        
        playt_action = SKAction.runBlock({
            var single_duration = 0.2
            
            var playe_path = CGPathCreateMutable()
            CGPathMoveToPoint(playe_path, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(playe_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75), CGFloat(M_PI / 4), true)
            var playe_move = SKAction.followPath(playe_path, asOffset: false, orientToPath: false, duration: single_duration)
            var playe_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]))
            
            var settings_path = CGPathCreateMutable()
            CGPathMoveToPoint(settings_path, nil, self.btnSettings.position.x, self.btnSettings.position.y)
            CGPathAddArc(settings_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), CGFloat(M_PI / 4), false)
            var settings_move = SKAction.followPath(settings_path, asOffset: false, orientToPath: false, duration: single_duration)
            var settings_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnSettings.zPosition = -2
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), CGFloat(M_PI / 4), false)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: single_duration)
            var stats_scale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]))
            
            var playt_wait = SKAction.waitForDuration(2 * single_duration)
            var playt_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playt_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayTimed.zPosition = 0
            self.btnPlayTimed.runAction(SKAction.sequence([playt_wait, playt_move, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.startGame(GameMode.Timed)
            })
        })
        
        go_action = go_action_normal
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (btnGo.containsPoint(location)) {
                runAction(go_action)
            } else if (btnAbout.containsPoint(location)) {
                
            } else if (btnStats.containsPoint(location)) {
                runAction(stats_action)
            } else if (btnSettings.containsPoint(location)) {
                runAction(settings_action)
            } else if (btnPlayEndless.containsPoint(location)) {
                runAction(playe_action)
            } else if (btnPlayTimed.containsPoint(location)) {
                runAction(playt_action)
            } else {
                // Just a little 'easteregg' ;)
                var ball = SKShapeNode(circleOfRadius: frame.height / 32)
                ball.fillColor = Colors.getRandomBallColor()
                ball.lineWidth = 1
                ball.strokeColor = ball.fillColor
                ball.position = location
                ball.zPosition = -10
                rootNode.addChild(ball)
                ball.runAction(SKAction.scaleTo(0.0, duration: 0.5), completion: {()
                    ball.removeFromParent()
                })
            }
        }
    }
}