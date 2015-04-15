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
    
    var hasAdsRemoved = false
    
    private var rootNode = SKNode()
    private var distance : CGFloat!
    
    private var title : SKNode!
    private var lblArculars : SKLabelNode!
    private var btnAbout : SKSpriteNode!
    private var btnStats : SKShapeNode!
    private var btnHelp : SKShapeNode!
    private var btnSettings : SKShapeNode!
    private var btnGamecenter : SKShapeNode!
    
    private var btnGo : SKShapeNode!
    private var btnPlayEndless: SKShapeNode!
    private var btnPlayTimed : SKShapeNode!
    private var btnRemoveAds : SKShapeNode!
    private var dashedCircle : SKShapeNode!
    
    // Actions
    private var FADEINaction : SKAction!
    private var FADEOUTaction : SKAction!
    private var GOaction : SKAction!
    private var GOaction_normal : SKAction!
    private var GOaction_reverse : SKAction!
    private var ENDLESSaction : SKAction!
    private var TIMEDaction : SKAction!
    private var REMOVEADSaction : SKAction!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        hasAdsRemoved = NSUserDefaults.standardUserDefaults().boolForKey("hasAdsRemoved")
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.BackgroundColor
        
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
        ENDLESSaction       = nil
        TIMEDaction         = nil
        REMOVEADSaction     = nil
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
        
        // INIT TITLE
        title = SKNode()
        title.position = CGPoint(x: 0, y: size.height / 2)
        
        lblArculars = SKLabelNode(text: "ARCULARS")
        lblArculars.fontName = Fonts.FontNameBold
        lblArculars.fontSize = size.height / 16
        lblArculars.fontColor = Colors.FontColor
        lblArculars.position = CGPoint(x: 0, y: 0)
        lblArculars.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        lblArculars.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        title.addChild(lblArculars)
        
        btnAbout = SKSpriteNode(imageNamed: "icon-arculars")
        btnAbout.colorBlendFactor = 1
        btnAbout.color = Colors.FontColor
        btnAbout.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnAbout.position = CGPoint(x: 0, y: lblArculars.frame.height + (btnAbout.frame.height / 2))
        title.addChild(btnAbout)
        
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
        btnHelp.position = CGPoint(x: -helpSprite.frame.width * 3, y: -(size.height / 2) + (size.height / 12))
        btnHelp.lineWidth = 0
        btnHelp.addChild(helpSprite)
        btnHelp.xScale = 0.0
        btnHelp.yScale = 0.0
        rootNode.addChild(btnHelp)
        
        // INIT ABOUT BUTTON
        var statsSprite = SKSpriteNode(imageNamed: "icon-statistics")
        statsSprite.colorBlendFactor = 1
        statsSprite.color = Colors.DisabledColor
        statsSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnStats = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnStats.position = CGPoint(x: -statsSprite.frame.width, y: -(size.height / 2) + (size.height / 12))
        btnStats.lineWidth = 0
        btnStats.addChild(statsSprite)
        btnStats.xScale = 0.0
        btnStats.yScale = 0.0
        rootNode.addChild(btnStats)
        
        // INIT SETTINGS BUTTON
        var settingsSprite = SKSpriteNode(imageNamed: "icon-settings")
        settingsSprite.colorBlendFactor = 1
        settingsSprite.color = Colors.DisabledColor
        settingsSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        btnSettings = SKShapeNode(rectOfSize: CGSize(width: size.width / 8, height: size.width / 8))
        btnSettings.position = CGPoint(x: settingsSprite.frame.width, y: -(size.height / 2) + (size.height / 12))
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
        btnGamecenter.position = CGPoint(x: gamecenterSprite.frame.width * 3, y: -(size.height / 2) + (size.height / 12))
        btnGamecenter.lineWidth = 0
        btnGamecenter.addChild(gamecenterSprite)
        btnGamecenter.xScale = 0.0
        btnGamecenter.yScale = 0.0
        rootNode.addChild(btnGamecenter)
        
        // INIT GO BUTTON
        btnGo = SKShapeNode(circleOfRadius: radius)
        btnGo.strokeColor = Colors.AppColorThree
        btnGo.lineWidth = 1
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
        dashedCircle.strokeColor = Colors.DisabledColor
        dashedCircle.zPosition = -10
        dashedCircle.xScale = 0.0
        dashedCircle.yScale = 0.0
        btnGo.addChild(dashedCircle)
        
        // INIT TIMED GAME BUTTON
        btnPlayTimed = SKShapeNode(circleOfRadius: radius)
        btnPlayTimed.fillColor = Colors.AppColorThree
        btnPlayTimed.strokeColor = Colors.AppColorThree
        btnPlayTimed.lineWidth = 3
        btnPlayTimed.antialiased = true
        btnPlayTimed.position = CGPoint(x: 0, y: 0)
        btnPlayTimed.xScale = 0.0
        btnPlayTimed.yScale = 0.0
        btnPlayTimed.zPosition = -1
        var clockIcon = SKSpriteNode(imageNamed: "icon-clock")
        clockIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var aspectRatioClock = clockIcon.size.width / clockIcon.size.height
        clockIcon.size = CGSize(width: radius, height: radius / aspectRatioClock)
        btnPlayTimed.addChild(clockIcon)
        btnGo.addChild(btnPlayTimed)
        
        var playtLabel = SKLabelNode(text: "Timed")
        playtLabel.name = "label"
        playtLabel.fontName = Fonts.FontNameLight
        playtLabel.fontSize = size.height / 40
        playtLabel.position = CGPoint(x: 0, y: (1.5 * radius))
        playtLabel.alpha = 0.0
        playtLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        playtLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnPlayTimed.addChild(playtLabel)
        
        // INIT ENDLESS GAME BUTTON
        btnPlayEndless = SKShapeNode(circleOfRadius: radius)
        btnPlayEndless.fillColor = Colors.AppColorThree
        btnPlayEndless.strokeColor = Colors.AppColorThree
        btnPlayEndless.lineWidth = 3
        btnPlayEndless.antialiased = true
        btnPlayEndless.position = CGPoint(x: 0, y: 0)
        btnPlayEndless.xScale = 0.0
        btnPlayEndless.yScale = 0.0
        btnPlayEndless.zPosition = -1
        var iconInfinity = SKSpriteNode(imageNamed: "icon-infinity")
        iconInfinity.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var aspectRatioInfinity = iconInfinity.size.width / iconInfinity.size.height
        iconInfinity.size = CGSize(width: radius, height: radius / aspectRatioInfinity)
        btnPlayEndless.addChild(iconInfinity)
        btnGo.addChild(btnPlayEndless)
        
        var playeLabel = SKLabelNode(text: "Endless")
        playeLabel.name = "label"
        playeLabel.fontName = Fonts.FontNameLight
        playeLabel.fontSize = size.height / 40
        playeLabel.position = CGPoint(x: 0, y: (1.5 * radius))
        playeLabel.alpha = 0.0
        playeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        playeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnPlayEndless.addChild(playeLabel)
        
        // INIT REMOVE ADS BUTTON
        btnRemoveAds = SKShapeNode(circleOfRadius: radius)
        btnRemoveAds.fillColor = Colors.AppColorOne
        btnRemoveAds.strokeColor = Colors.AppColorOne
        btnRemoveAds.lineWidth = 3
        btnRemoveAds.antialiased = true
        btnRemoveAds.position = CGPoint(x: 0, y: 0)
        btnRemoveAds.xScale = 0.0
        btnRemoveAds.yScale = 0.0
        btnRemoveAds.zPosition = -1
        var iconRemoveAds = SKSpriteNode(imageNamed: "icon-noads")
        iconRemoveAds.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var aspectRatioRemoveAds = iconRemoveAds.size.width / iconRemoveAds.size.height
        iconRemoveAds.size = CGSize(width: radius, height: radius / aspectRatioRemoveAds)
        btnRemoveAds.addChild(iconRemoveAds)
        if !hasAdsRemoved {  btnGo.addChild(btnRemoveAds) }
        
        var remadslabel = SKLabelNode(text: "Remove Ads")
        remadslabel.name = "label"
        remadslabel.fontName = Fonts.FontNameLight
        remadslabel.fontSize = size.height / 40
        remadslabel.position = CGPoint(x: 0, y: -(1.5 * radius))
        remadslabel.alpha = 0.0
        remadslabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        remadslabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnRemoveAds.addChild(remadslabel)
        
    }
    
    private func initActions() {
        FADEINaction = SKAction.runBlock({
            var popin = SKAction.sequence([
                SKAction.scaleTo(1.05, duration: 0.1),
                SKAction.scaleTo(0.95, duration: 0.1),
                SKAction.scaleTo(1.00, duration: 0.1)
            ])
            
            var flyin = SKAction.sequence([
                SKAction.moveTo(CGPoint(x: 0, y: ((self.size.height / 7) * 2) - 10), duration: 0.1),
                SKAction.moveTo(CGPoint(x: 0, y: ((self.size.height / 7) * 2) + 10), duration: 0.1),
                SKAction.moveTo(CGPoint(x: 0, y: (self.size.height / 7) * 2), duration: 0.1)
            ])
            
            self.title.runAction(flyin)
            
            self.btnGo.runAction(popin)
            self.btnStats.runAction(popin)
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
            self.btnStats.runAction(popout)
            self.btnSettings.runAction(popout)
            self.btnHelp.runAction(popout)
            self.btnGamecenter.runAction(popout)
        })
        
        GOaction_normal = SKAction.runBlock({
            var TIMEDendpoint = CGPoint(x: self.btnGo.position.x + self.distance, y: self.btnGo.position.y)
            var TIMEDmove = SKAction.moveTo(TIMEDendpoint, duration: 0.2)
            TIMEDmove.timingMode = SKActionTimingMode.EaseIn
            var TIMEDscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([TIMEDmove, TIMEDscale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as! SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var ENDLESSendpoint = CGPoint(x: self.btnGo.position.x - self.distance, y: self.btnGo.position.y)
            var ENDLESSmove = SKAction.moveTo(ENDLESSendpoint, duration: 0.2)
            ENDLESSmove.timingMode = SKActionTimingMode.EaseIn
            var ENDLESSscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([ENDLESSmove, ENDLESSscale]), completion: {()
                var label = self.btnPlayEndless.childNodeWithName("label") as! SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var REMOVEADSendpoint = CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y - self.distance)
            var REMOVEADSmove = SKAction.moveTo(REMOVEADSendpoint, duration: 0.2)
            REMOVEADSmove.timingMode = SKActionTimingMode.EaseIn
            var REMOVEADSscale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnRemoveAds.runAction(SKAction.group([REMOVEADSmove, REMOVEADSscale]), completion: {()
                var label = self.btnRemoveAds.childNodeWithName("label") as! SKLabelNode
                label.runAction(SKAction.fadeInWithDuration(0.1))
            })
            
            var dashedcircle_scale = SKAction.scaleTo(1.0, duration: 0.2)
            var dashedcircle_rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: 10.0))
            self.dashedCircle.runAction(SKAction.group([dashedcircle_scale, dashedcircle_rotate]), withKey: "rotating")
            
            var content = self.btnGo.childNodeWithName("content") as! SKShapeNode
            var content_scale = SKAction.scaleTo(0.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.GOaction = self.GOaction_reverse
        })
        
        GOaction_reverse = SKAction.runBlock({
            var TIMEDmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            TIMEDmove.timingMode = SKActionTimingMode.EaseIn
            var TIMEDscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([TIMEDmove, TIMEDscale]), completion: {()
                var label = self.btnPlayTimed.childNodeWithName("label") as! SKLabelNode
                label.alpha = 0.0
            })
            
            var ENDLESSmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            ENDLESSmove.timingMode = SKActionTimingMode.EaseIn
            var ENDLESSscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([ENDLESSmove, ENDLESSscale]), completion: {()
                var label = self.btnPlayEndless.childNodeWithName("label") as! SKLabelNode
                label.alpha = 0.0
            })
            
            var REMOVEADSmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            REMOVEADSmove.timingMode = SKActionTimingMode.EaseIn
            var REMOVEADSscale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnRemoveAds.runAction(SKAction.group([REMOVEADSmove, REMOVEADSscale]), completion: {()
                var label = self.btnRemoveAds.childNodeWithName("label") as! SKLabelNode
                label.alpha = 0.0
            })
            
            var dashedcircle_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.dashedCircle.runAction(dashedcircle_scale, completion: { ()
            })
            
            var content = self.btnGo.childNodeWithName("content") as! SKShapeNode
            var content_scale = SKAction.scaleTo(1.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.GOaction = self.GOaction_normal
        })
        
        ENDLESSaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var TIMEDpath = CGPathCreateMutable()
            CGPathMoveToPoint(TIMEDpath, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(TIMEDpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, 0, CGFloat(M_PI), false)
            var TIMEDmove = SKAction.followPath(TIMEDpath, asOffset: false, orientToPath: false, duration: single_duration)
            var TIMEDscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([TIMEDmove, TIMEDscale]))
            
            var REMOVEADSpath = CGPathCreateMutable()
            CGPathMoveToPoint(REMOVEADSpath, nil, self.btnRemoveAds.position.x, self.btnRemoveAds.position.y)
            CGPathAddArc(REMOVEADSpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 2), -CGFloat(M_PI), true)
            var REMOVEADSmove = SKAction.followPath(REMOVEADSpath, asOffset: false, orientToPath: false, duration: single_duration)
            var REMOVEADSscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnRemoveAds.zPosition = -2
            self.btnRemoveAds.runAction(SKAction.group([REMOVEADSmove, REMOVEADSscale]))
            
            var ENDLESSwait = SKAction.waitForDuration(2 * single_duration)
            var ENDLESSmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            ENDLESSmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayEndless.zPosition = 0
            self.btnPlayEndless.runAction(SKAction.sequence([ENDLESSwait, ENDLESSmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showGameScene(GameMode.Endless)
            })
        })
        
        TIMEDaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var ENDLESSpath = CGPathCreateMutable()
            CGPathMoveToPoint(ENDLESSpath, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(ENDLESSpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, CGFloat(M_PI), 0, false)
            var ENDLESSmove = SKAction.followPath(ENDLESSpath, asOffset: false, orientToPath: false, duration: single_duration)
            var ENDLESSscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([ENDLESSmove, ENDLESSscale]))
            
            var REMOVEADSpath = CGPathCreateMutable()
            CGPathMoveToPoint(REMOVEADSpath, nil, self.btnRemoveAds.position.x, self.btnRemoveAds.position.y)
            CGPathAddArc(REMOVEADSpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI / 2), 0, false)
            var REMOVEADSmove = SKAction.followPath(REMOVEADSpath, asOffset: false, orientToPath: false, duration: single_duration)
            var REMOVEADSscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnRemoveAds.zPosition = -2
            self.btnRemoveAds.runAction(SKAction.group([REMOVEADSmove, REMOVEADSscale]))
            
            var TIMEDwait = SKAction.waitForDuration(2 * single_duration)
            var TIMEDmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            TIMEDmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayTimed.zPosition = 0
            self.btnPlayTimed.runAction(SKAction.sequence([TIMEDwait, TIMEDmove, SKAction.waitForDuration(0.1)]), completion: {()
                self.sceneDelegate!.showGameScene(GameMode.Timed)
            })
        })
        
        REMOVEADSaction = SKAction.runBlock({
            var single_duration = 0.2
            
            var ENDLESSpath = CGPathCreateMutable()
            CGPathMoveToPoint(ENDLESSpath, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(ENDLESSpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, -CGFloat(M_PI), -CGFloat(M_PI / 2), false)
            var ENDLESSmove = SKAction.followPath(ENDLESSpath, asOffset: false, orientToPath: false, duration: single_duration)
            var ENDLESSscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([ENDLESSmove, ENDLESSscale]))
            
            var TIMEDpath = CGPathCreateMutable()
            CGPathMoveToPoint(TIMEDpath, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(TIMEDpath, nil, self.btnGo.position.x, self.btnGo.position.y, self.distance, 0, -CGFloat(M_PI / 2), true)
            var TIMEDmove = SKAction.followPath(TIMEDpath, asOffset: false, orientToPath: false, duration: single_duration)
            var TIMEDscale = SKAction.scaleTo(0.0, duration: single_duration)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([TIMEDmove, TIMEDscale]))
            
            var REMOVEADSwait = SKAction.waitForDuration(2 * single_duration)
            var REMOVEADSmove = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            REMOVEADSmove.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnRemoveAds.zPosition = 0
            self.btnRemoveAds.runAction(SKAction.sequence([REMOVEADSwait, REMOVEADSmove, SKAction.waitForDuration(0.1)]), completion: {()
                
            })
        })
        
        GOaction = GOaction_normal
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (title.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showAboutScene()
                })
            } else if (btnGo.containsPoint(location)) {
                runAction(GOaction)
            } else if (btnHelp.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showHelpScene()
                })
            } else if (btnSettings.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showSettingsScene()
                })
            } else if (btnStats.containsPoint(location)) {
                self.runAction(SKAction.sequence([FADEOUTaction, SKAction.waitForDuration(0.1)]), completion: {()
                    self.sceneDelegate!.showStatsScene()
                })
            } else if (btnGamecenter.containsPoint(location)) {
                self.sceneDelegate!.presentGameCenter()
            } else if (btnPlayEndless.containsPoint(location)) {
                runAction(ENDLESSaction)
            } else if (btnPlayTimed.containsPoint(location)) {
                runAction(TIMEDaction)
            } else if (btnRemoveAds.containsPoint(location)) {
                runAction(REMOVEADSaction)
            } else {
                createRandomBall(location)
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            var random = Int(arc4random_uniform(6));
            if random == 3 {
                createRandomBall(location)
            }
        }
    }
    
    // MARK: - CREATE RANDOM BALLS
    func createRandomBall(position: CGPoint) {
        var ball = SKShapeNode(circleOfRadius: frame.height / 64)
        ball.fillColor = Colors.randomAppColor()
        ball.lineWidth = 1
        ball.strokeColor = ball.fillColor
        ball.antialiased = true
        ball.position = position
        ball.zPosition = -10
        rootNode.addChild(ball)
        ball.runAction(SKAction.scaleTo(0.0, duration: 0.5), completion: {()
            ball.removeFromParent()
        })
    }
}