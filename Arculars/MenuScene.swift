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
    
    private var title : SKLabelNode!
    private var btnAbout : SKShapeNode!
    private var btnHelp : SKShapeNode!
    private var btnSettings : SKShapeNode!
    private var btnGamecenter : SKShapeNode!
    
    private var btnGo : SKShapeNode!
    private var btnStats : SKShapeNode!
    private var btnPlayEndless: SKShapeNode!
    private var btnPlayTimed : SKShapeNode!
    private var btnUnlocks: SKShapeNode!
    private var dashedCircle : SKShapeNode!
    
    // Actions
    private var FADEINaction : SKAction!
    private var FADEOUTaction : SKAction!
    private var GOaction : SKAction!
    private var GOaction_normal : SKAction!
    private var GOaction_reverse : SKAction!
    private var SWaction : SKAction!
    private var NWaction : SKAction!
    private var NEaction : SKAction!
    private var SEaction : SKAction!
    
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
        self.runAction(FADEINaction)
    }
    
    override func willMoveFromView(view: SKView) {
        // Explicitly set actions to nil so deinit is called
        FADEINaction        = nil
        FADEOUTaction       = nil
        GOaction            = nil
        GOaction_normal     = nil
        GOaction_reverse    = nil
        SEaction            = nil
        SWaction            = nil
        NWaction            = nil
        NEaction            = nil
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
        
        title = SKLabelNode(text: "ARCULARS")
        title.fontName = Fonts.FontNameBold
        title.fontSize = size.height / 16
        title.fontColor = Colors.FontColor
        title.position = CGPoint(x: 0, y: self.size.height / 2)
        rootNode.addChild(title)
    }
    
    private func initButtons() {
        var radius = size.height / 18
        
        // INIT HELP BUTTON
        var helpSprite = SKSpriteNode(imageNamed: "icon-help")
        helpSprite.colorBlendFactor = 1
        helpSprite.color = Colors.DisabledColor
        helpSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnHelp = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnHelp.position = CGPoint(x: -(size.width / 4), y: -(size.height / 2) + (size.height / 12))
        btnHelp.lineWidth = 0
        btnHelp.addChild(helpSprite)
        btnHelp.xScale = 0.0
        btnHelp.yScale = 0.0
        rootNode.addChild(btnHelp)
        
        // INIT ABOUT BUTTON
        var aboutSprite = SKSpriteNode(imageNamed: "icon-arculars")
        aboutSprite.colorBlendFactor = 1
        aboutSprite.color = Colors.DisabledColor
        aboutSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnAbout = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnAbout.position = CGPoint(x: -(size.width / 12), y: -(size.height / 2) + (size.height / 12))
        btnAbout.lineWidth = 0
        btnAbout.addChild(aboutSprite)
        btnAbout.xScale = 0.0
        btnAbout.yScale = 0.0
        rootNode.addChild(btnAbout)
        
        // INIT SETTINGS BUTTON
        var settingsSprite = SKSpriteNode(imageNamed: "icon-settings")
        settingsSprite.colorBlendFactor = 1
        settingsSprite.color = Colors.DisabledColor
        settingsSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnSettings = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnSettings.position = CGPoint(x: (size.width / 12), y: -(size.height / 2) + (size.height / 12))
        btnSettings.lineWidth = 0
        btnSettings.addChild(settingsSprite)
        btnSettings.xScale = 0.0
        btnSettings.yScale = 0.0
        rootNode.addChild(btnSettings)
        
        // INIT GAMECENTER BUTTON
        var gamecenterSprite = SKSpriteNode(imageNamed: "icon-achievement")
        gamecenterSprite.colorBlendFactor = 1
        gamecenterSprite.color = Colors.DisabledColor
        gamecenterSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnGamecenter = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnGamecenter.position = CGPoint(x: (size.width / 4), y: -(size.height / 2) + (size.height / 12))
        btnGamecenter.lineWidth = 0
        btnGamecenter.addChild(gamecenterSprite)
        btnGamecenter.xScale = 0.0
        btnGamecenter.yScale = 0.0
        rootNode.addChild(btnGamecenter)
        
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
        btnGo.xScale = 0.0
        btnGo.yScale = 0.0
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
        
        // INIT UNLOCKS BUTTON
        btnUnlocks = SKShapeNode(circleOfRadius: radius)
        btnUnlocks.fillColor = Colors.AppColorThree
        btnUnlocks.strokeColor = Colors.AppColorThree
        btnUnlocks.lineWidth = 1
        btnUnlocks.antialiased = true
        btnUnlocks.position = CGPoint(x: 0, y: 0)
        btnUnlocks.xScale = 0.0
        btnUnlocks.yScale = 0.0
        btnUnlocks.zPosition = -1
        var donutIcon = SKSpriteNode(imageNamed: "icon-donut")
        donutIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnUnlocks.addChild(donutIcon)
        btnGo.addChild(btnUnlocks)
        
        var unlocksLabel = SKLabelNode(text: "Unlocks")
        unlocksLabel.name = "label"
        unlocksLabel.fontName = Fonts.FontNameLight
        unlocksLabel.fontSize = size.height / 40
        unlocksLabel.position = CGPoint(x: 0, y: -(1.75 * radius))
        unlocksLabel.alpha = 0.0
        btnUnlocks.addChild(unlocksLabel)
        
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
        FADEINaction = SKAction.runBlock({
            var popin = SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.1),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.00, duration: 0.1)
            ])
            
            var flyin = SKAction.sequence([
                SKAction.moveTo(CGPoint(x: 0, y: ((self.size.height / 6) * 2) - 10), duration: 0.1),
                SKAction.moveTo(CGPoint(x: 0, y: ((self.size.height / 6) * 2) + 10), duration: 0.1),
                SKAction.moveTo(CGPoint(x: 0, y: (self.size.height / 6) * 2), duration: 0.1)
            ])
            
            self.title.runAction(flyin)
            
            self.btnGo.runAction(popin)
            self.btnAbout.runAction(popin)
            self.btnSettings.runAction(popin)
            self.btnHelp.runAction(popin)
            self.btnGamecenter.runAction(popin)
        })
        
        FADEOUTaction = SKAction.runBlock({
            var popout = SKAction.sequence([
                SKAction.scaleTo(0.0, duration: 0.1)
                ])
            
            var flyout = SKAction.sequence([
                SKAction.moveTo(CGPoint(x: 0, y: (self.size.height / 2)), duration: 0.1)
                ])
            
            self.title.runAction(flyout)
            
            self.btnGo.runAction(popout)
            self.btnAbout.runAction(popout)
            self.btnSettings.runAction(popout)
            self.btnHelp.runAction(popout)
            self.btnGamecenter.runAction(popout)
        })
        
        GOaction_normal = SKAction.runBlock({
            var SWendpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y - self.distance), CGAffineTransformMakeRotation(-CGFloat(M_PI_4)))
            var SWmove = SKAction.moveTo(SWendpoint, duration: 0.2)
            SWmove.timingMode = SKActionTimingMode.EaseIn
            var SWscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([SWmove, SWscale]), completion: {()
                var label = self.btnStats.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var SEendpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y - self.distance), CGAffineTransformMakeRotation(CGFloat(M_PI_4)))
            var SEmove = SKAction.moveTo(SEendpoint, duration: 0.2)
            SEmove.timingMode = SKActionTimingMode.EaseIn
            var SEscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnUnlocks.runAction(SKAction.group([SEmove, SEscale]), completion: {()
                var label = self.btnUnlocks.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var NEendpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + self.distance), CGAffineTransformMakeRotation(-CGFloat(M_PI_4)))
            var NEmove = SKAction.moveTo(NEendpoint, duration: 0.2)
            NEmove.timingMode = SKActionTimingMode.EaseIn
            var NEscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([NEmove, NEscale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var NWendpoint = CGPointApplyAffineTransform(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + self.distance), CGAffineTransformMakeRotation(CGFloat(M_PI_4)))
            var NWmove = SKAction.moveTo(NWendpoint, duration: 0.2)
            NWmove.timingMode = SKActionTimingMode.EaseIn
            var NWscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([NWmove, NWscale]), completion: {()
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
            
            self.GOaction = self.GOaction_reverse
        })
        
        GOaction_reverse = SKAction.runBlock({
            var SWmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            SWmove.timingMode = SKActionTimingMode.EaseIn
            var SWscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([SWmove, SWscale]), completion: {()
                var label = self.btnStats.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var SEmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            SEmove.timingMode = SKActionTimingMode.EaseIn
            var SEscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnUnlocks.runAction(SKAction.group([SEmove, SEscale]), completion: {()
                var label = self.btnUnlocks.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var NEmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            NEmove.timingMode = SKActionTimingMode.EaseIn
            var NEscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([NEmove, NEscale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as SKLabelNode
                label.alpha = 0.0
            })
            
            var NWmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            NWmove.timingMode = SKActionTimingMode.EaseIn
            var NWscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([NWmove, NWscale]), completion: {()
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
            
            self.GOaction = self.GOaction_normal
        })
        
        SWaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var NEpath = CGPathCreateMutable()
            CGPathMoveToPoint(NEpath, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(NEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), -CGFloat(M_PI * 0.75), false)
            var NEmove = SKAction.followPath(NEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([NEmove, NEscale]))
            
            var NWpath = CGPathCreateMutable()
            CGPathMoveToPoint(NWpath, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(NWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75)  , -CGFloat(M_PI * 0.75), false)
            var NWmove = SKAction.followPath(NWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([NWmove, NWscale]))
            
            var SEpath = CGPathCreateMutable()
            CGPathMoveToPoint(SEpath, nil, self.btnUnlocks.position.x, self.btnUnlocks.position.y)
            CGPathAddArc(SEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), -CGFloat(M_PI * 0.75), true)
            var SEmove = SKAction.followPath(SEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnUnlocks.zPosition = -2
            self.btnUnlocks.runAction(SKAction.group([SEmove, SEscale]))
            
            var SWwait = SKAction.waitForDuration(2 * single_duration)
            var SWmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            SWmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnStats.zPosition = 0
            self.btnStats.runAction(SKAction.sequence([SWwait, SWmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showStatistics()
            })
        })
        
        SEaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var NEpath = CGPathCreateMutable()
            CGPathMoveToPoint(NEpath, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(NEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), -CGFloat(M_PI / 4), true)
            var NEmove = SKAction.followPath(NEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([NEmove, NEscale]))
            
            var NWpath = CGPathCreateMutable()
            CGPathMoveToPoint(NWpath, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(NWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75)  , -CGFloat(M_PI / 4), true)
            var NWmove = SKAction.followPath(NWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([NWmove, NWscale]))
            
            var SWpath = CGPathCreateMutable()
            CGPathMoveToPoint(SWpath, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(SWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), -CGFloat(M_PI / 4), false)
            var SWmove = SKAction.followPath(SWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([SWmove, SWscale]))
            
            var SEwait = SKAction.waitForDuration(2 * single_duration)
            var SEmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            SEmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnUnlocks.zPosition = 0
            self.btnUnlocks.runAction(SKAction.sequence([SEwait, SEmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showUnlocks()
            })
        })
        
        NWaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var NEpath = CGPathCreateMutable()
            CGPathMoveToPoint(NEpath, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(NEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI / 4), CGFloat(M_PI * 0.75), false)
            var NEmove = SKAction.followPath(NEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([NEmove, NEscale]))
            
            var SEpath = CGPathCreateMutable()
            CGPathMoveToPoint(SEpath, nil, self.btnUnlocks.position.x, self.btnUnlocks.position.y)
            CGPathAddArc(SEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), CGFloat(M_PI * 0.75), true)
            var SEmove = SKAction.followPath(SEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnUnlocks.zPosition = -2
            self.btnUnlocks.runAction(SKAction.group([SEmove, SEscale]))
            
            var SWpath = CGPathCreateMutable()
            CGPathMoveToPoint(SWpath, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(SWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), CGFloat(M_PI * 0.75), true)
            var SWmove = SKAction.followPath(SWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([SWmove, SWscale]))
            
            var NWwait = SKAction.waitForDuration(2 * single_duration)
            var NWmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            NWmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayEndless.zPosition = 0
            self.btnPlayEndless.runAction(SKAction.sequence([NWwait, NWmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.startGame(GameMode.Endless)
            })
        })
        
        NEaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var NWpath = CGPathCreateMutable()
            CGPathMoveToPoint(NWpath, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(NWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI * 0.75), CGFloat(M_PI / 4), true)
            var NWmove = SKAction.followPath(NWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var NWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([NWmove, NWscale]))
            
            var SEpath = CGPathCreateMutable()
            CGPathMoveToPoint(SEpath, nil, self.btnUnlocks.position.x, self.btnUnlocks.position.y)
            CGPathAddArc(SEpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 4), CGFloat(M_PI / 4), false)
            var SEmove = SKAction.followPath(SEpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SEscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnUnlocks.zPosition = -2
            self.btnUnlocks.runAction(SKAction.group([SEmove, SEscale]))
            
            var SWpath = CGPathCreateMutable()
            CGPathMoveToPoint(SWpath, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(SWpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI * 0.75), CGFloat(M_PI / 4), false)
            var SWmove = SKAction.followPath(SWpath, asOffset: false, orientToPath: false, duration: single_duration)
            var SWscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnStats.zPosition = -2
            self.btnStats.runAction(SKAction.group([SWmove, SWscale]))
            
            var NEwait = SKAction.waitForDuration(2 * single_duration)
            var NEmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            NEmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayTimed.zPosition = 0
            self.btnPlayTimed.runAction(SKAction.sequence([NEwait, NEmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.startGame(GameMode.Timed)
            })
        })
        
        GOaction = GOaction_normal
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (btnGo.containsPoint(location)) {
                runAction(GOaction)
            } else if (btnAbout.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showAbout()
                })
            } else if (btnHelp.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showHelp()
                })
            } else if (btnSettings.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showSettings()
                })
            } else if (btnGamecenter.containsPoint(location)) {
                self.sceneDelegate!.showGamecenter()
            } else if (btnStats.containsPoint(location)) {
                runAction(SWaction)
            } else if (btnUnlocks.containsPoint(location)) {
                runAction(SEaction)
            } else if (btnPlayEndless.containsPoint(location)) {
                runAction(NWaction)
            } else if (btnPlayTimed.containsPoint(location)) {
                runAction(NEaction)
            } else {
                easteregg(location)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            var random = Int(arc4random_uniform(6));
            if random == 3 {
                easteregg(location)
            }
        }
    }
    
    // MARK: - CREATE RANDOM BALLS (EASTEREGG)
    func easteregg(position: CGPoint) {
        // Just a little 'easteregg' ;)
        var ball = SKShapeNode(circleOfRadius: frame.height / 64)
        ball.fillColor = Colors.AppColorThree
        ball.lineWidth = 1
        ball.strokeColor = Colors.AppColorThree
        ball.antialiased = true
        ball.position = position
        ball.zPosition = -10
        rootNode.addChild(ball)
        ball.runAction(SKAction.scaleTo(0.0, duration: 0.5), completion: {()
            ball.removeFromParent()
        })
    }
}