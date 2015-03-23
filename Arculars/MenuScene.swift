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
    
    var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var btnGo : SKShapeNode!
    private var btnStats : SKShapeNode!
    private var btnPlayEndless: SKShapeNode!
    private var btnPlayTimed : SKShapeNode!
    
    private var hscoreLabel : SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Add Root Node
        self.addChild(rootNode)
        
        // Init userdata dictionary
        self.userData = NSMutableDictionary()
    }
    
    private func initScene() {
        rootNode.removeAllChildren()
        rootNode.removeAllActions()
        
        initButtons()
        initActions()
        
        hscoreLabel = SKLabelNode(text: "Highscore")
        hscoreLabel.fontName = "Avenir-Light"
        hscoreLabel.fontSize = self.size.height / 24
        hscoreLabel.fontColor = Colors.FontColor
        hscoreLabel.position = CGPoint(x: 0, y: -self.size.height / 4)
        rootNode.addChild(hscoreLabel)
    }
    
    private func initButtons() {
        var radius = self.size.height / 16
        
        btnGo = SKShapeNode(circleOfRadius: radius)
        btnGo.strokeColor = Colors.ArcularsColor3
        btnGo.lineWidth = 2
        btnGo.antialiased = true
        btnGo.position = CGPoint(x: 0, y: 0)
        
        var content = SKShapeNode(circleOfRadius: radius)
        content.fillColor = Colors.ArcularsColor3
        content.strokeColor = Colors.ArcularsColor3
        content.lineWidth = 1
        content.antialiased = true
        content.name = "content"
        btnGo.addChild(content)
        var label = SKLabelNode(text: "GO")
        label.fontName = "Avenir-Black"
        label.fontSize = self.frame.size.height / 18
        label.position = CGPoint(x: 0, y: -label.frame.height / 2)
        content.addChild(label)
        rootNode.addChild(btnGo)
        
        btnStats = SKShapeNode(circleOfRadius: radius)
        btnStats.fillColor = Colors.ArcularsColor3
        btnStats.strokeColor = Colors.ArcularsColor3
        btnStats.lineWidth = 1
        btnStats.antialiased = true
        btnStats.position = CGPoint(x: 0, y: 0)
        btnStats.xScale = 0.0
        btnStats.yScale = 0.0
        btnStats.zPosition = -1
        btnStats.addChild(SKSpriteNode(imageNamed: "stats"))
        btnGo.addChild(self.btnStats)
        
        btnPlayTimed = SKShapeNode(circleOfRadius: radius)
        btnPlayTimed.fillColor = Colors.ArcularsColor3
        btnPlayTimed.strokeColor = Colors.ArcularsColor3
        btnPlayTimed.lineWidth = 1
        btnPlayTimed.antialiased = true
        btnPlayTimed.position = CGPoint(x: 0, y: 0)
        btnPlayTimed.xScale = 0.0
        btnPlayTimed.yScale = 0.0
        btnPlayTimed.zPosition = -1
        btnPlayTimed.addChild(SKSpriteNode(imageNamed: "play"))
        btnGo.addChild(self.btnPlayTimed)
        
        btnPlayEndless = SKShapeNode(circleOfRadius: radius)
        btnPlayEndless.fillColor = Colors.ArcularsColor3
        btnPlayEndless.strokeColor = Colors.ArcularsColor3
        btnPlayEndless.lineWidth = 1
        btnPlayEndless.antialiased = true
        btnPlayEndless.position = CGPoint(x: 0, y: 0)
        btnPlayEndless.xScale = 0.0
        btnPlayEndless.yScale = 0.0
        btnPlayEndless.zPosition = -1
        btnPlayEndless.addChild(SKSpriteNode(imageNamed: "play"))
        btnGo.addChild(self.btnPlayEndless)
    }
    
    private func initActions() {
        var go_action_normal : SKAction!
        var go_action_reversed : SKAction!
        var stats_action : SKAction!
        var playe_action : SKAction!
        var playt_action : SKAction!
        
        go_action_normal = SKAction.runBlock({
            var north_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + (self.btnGo.frame.height + (self.btnGo.frame.height / 4))), duration: 0.2)
            north_move.timingMode = SKActionTimingMode.EaseIn
            var north_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([north_move, north_scale]))
            
            var east_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x + (self.btnGo.frame.width + (self.btnGo.frame.width / 4)), y: self.btnGo.position.y), duration: 0.2)
            east_move.timingMode = SKActionTimingMode.EaseIn
            var east_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([east_move, east_scale]))
            
            var west_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x - (self.btnGo.frame.width + (self.btnGo.frame.width / 4)), y: self.btnGo.position.y), duration: 0.2)
            west_move.timingMode = SKActionTimingMode.EaseIn
            var west_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([west_move, west_scale]))
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(0.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.userData?.setObject(go_action_reversed, forKey: "go_action")
        })
        
        go_action_reversed = SKAction.runBlock({
            var north_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            north_move.timingMode = SKActionTimingMode.EaseIn
            var north_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnStats.runAction(SKAction.group([north_move, north_scale]))
            
            var east_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            east_move.timingMode = SKActionTimingMode.EaseIn
            var east_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayTimed.runAction(SKAction.group([east_move, east_scale]))
            
            var west_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            west_move.timingMode = SKActionTimingMode.EaseIn
            var west_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlayEndless.runAction(SKAction.group([west_move, west_scale]))
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(1.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.userData?.setObject(go_action_normal, forKey: "go_action")
        })
        
        stats_action = SKAction.runBlock({
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnPlayTimed.position), 0, CGFloat(M_PI / 2), false)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: 0.15)
            var stats_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([stats_move, stats_scale]))
            
            var settings_path = CGPathCreateMutable()
            CGPathMoveToPoint(settings_path, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(settings_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnPlayEndless.position), CGFloat(M_PI), CGFloat(M_PI / 2), true)
            var settings_move = SKAction.followPath(settings_path, asOffset: false, orientToPath: false, duration: 0.15)
            var settings_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnPlayEndless.runAction(SKAction.group([settings_move, settings_scale]))
            
            var play_wait = SKAction.waitForDuration(0.3)
            var play_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            play_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnStats.runAction(SKAction.sequence([play_wait, play_move]), completion: {()
                self.sceneDelegate!.showStatsScene()
            })
        })
        
        playe_action = SKAction.runBlock({
            var playt_path = CGPathCreateMutable()
            CGPathMoveToPoint(playt_path, nil, self.btnPlayTimed.position.x, self.btnPlayTimed.position.y)
            CGPathAddArc(playt_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnPlayTimed.position), 0, CGFloat(M_PI), false)
            var playt_move = SKAction.followPath(playt_path, asOffset: false, orientToPath: false, duration: 0.15)
            var playt_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnPlayTimed.zPosition = -2
            self.btnPlayTimed.runAction(SKAction.group([playt_move, playt_scale]))
            
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnStats.position), CGFloat(M_PI / 2), CGFloat(M_PI), false)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: 0.15)
            var stats_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]))
            
            var playe_wait = SKAction.waitForDuration(0.3)
            var playe_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playe_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayEndless.runAction(SKAction.sequence([playe_wait, playe_move]), completion: {()
                self.sceneDelegate!.startEndlessGame()
            })
        })
        
        playt_action = SKAction.runBlock({
            var playe_path = CGPathCreateMutable()
            CGPathMoveToPoint(playe_path, nil, self.btnPlayEndless.position.x, self.btnPlayEndless.position.y)
            CGPathAddArc(playe_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnPlayEndless.position), CGFloat(M_PI), 0, true)
            var playe_move = SKAction.followPath(playe_path, asOffset: false, orientToPath: false, duration: 0.15)
            var playe_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnPlayEndless.zPosition = -2
            self.btnPlayEndless.runAction(SKAction.group([playe_move, playe_scale]))
            
            var stats_path = CGPathCreateMutable()
            CGPathMoveToPoint(stats_path, nil, self.btnStats.position.x, self.btnStats.position.y)
            CGPathAddArc(stats_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnStats.position), CGFloat(M_PI / 2), 0, true)
            var stats_move = SKAction.followPath(stats_path, asOffset: false, orientToPath: false, duration: 0.15)
            var stats_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnStats.runAction(SKAction.group([stats_move, stats_scale]))
            
            var playt_wait = SKAction.waitForDuration(0.3)
            var playt_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            playt_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlayTimed.runAction(SKAction.sequence([playt_wait, playt_move]), completion: {()
                self.sceneDelegate!.startTimedGame()
            })
        })
        
        self.userData?.setObject(go_action_normal, forKey: "go_action")
        self.userData?.setObject(stats_action, forKey: "stats_action")
        self.userData?.setObject(playe_action, forKey: "playe_action")
        self.userData?.setObject(playt_action, forKey: "playt_action")
    }
    
    private func distanceFrom(point1: CGPoint, point2: CGPoint) -> CGFloat {
        var xDist = (point2.x - point1.x);
        var yDist = (point2.y - point1.y);
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        initScene()
        
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("game_highscore")
        hscoreLabel.text = "HIGHSCORE \(highscore)"
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (btnGo.containsPoint(location)) {
                var action = self.userData?.valueForKey("go_action") as SKAction
                self.runAction(action)
            }
            else if (btnStats.containsPoint(location)) {
                var action = self.userData?.valueForKey("stats_action") as SKAction
                self.runAction(action)
            } else if (btnPlayEndless.containsPoint(location)) {
                var action = self.userData?.valueForKey("playe_action") as SKAction
                self.runAction(action)
            } else if (btnPlayTimed.containsPoint(location)) {
                var action = self.userData?.valueForKey("playt_action") as SKAction
                self.runAction(action)
            } else {
                
                // Just a little 'easteregg' ;)
                var ball = SKShapeNode(circleOfRadius: self.frame.height / 32)
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