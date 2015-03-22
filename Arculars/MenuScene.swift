//
//  MenuScene.swift
//  Arculars
//
//  Created by Roman Blum on 14/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var btnGo : SKShapeNode!
    private var btnPlay : SKShapeNode!
    private var btnSettings: SKShapeNode!
    private var btnGC : SKShapeNode!
    
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
        label.position = CGPoint(x: 0, y: -label.frame.height / 2)
        content.addChild(label)
        rootNode.addChild(btnGo)
        
        btnPlay = SKShapeNode(circleOfRadius: radius)
        btnPlay.fillColor = Colors.ArcularsColor3
        btnPlay.strokeColor = Colors.ArcularsColor3
        btnPlay.lineWidth = 1
        btnPlay.antialiased = true
        btnPlay.position = CGPoint(x: 0, y: 0)
        btnPlay.xScale = 0.0
        btnPlay.yScale = 0.0
        btnPlay.zPosition = -1
        btnPlay.addChild(SKSpriteNode(imageNamed: "play"))
        btnGo.addChild(self.btnPlay)
        
        btnGC = SKShapeNode(circleOfRadius: radius)
        btnGC.fillColor = Colors.ArcularsColor3
        btnGC.strokeColor = Colors.ArcularsColor3
        btnGC.lineWidth = 1
        btnGC.antialiased = true
        btnGC.position = CGPoint(x: 0, y: 0)
        btnGC.xScale = 0.0
        btnGC.yScale = 0.0
        btnGC.zPosition = -1
        btnGC.addChild(SKSpriteNode(imageNamed: "stats"))
        btnGo.addChild(self.btnGC)
        
        btnSettings = SKShapeNode(circleOfRadius: radius)
        btnSettings.fillColor = Colors.ArcularsColor3
        btnSettings.strokeColor = Colors.ArcularsColor3
        btnSettings.lineWidth = 1
        btnSettings.antialiased = true
        btnSettings.position = CGPoint(x: 0, y: 0)
        btnSettings.xScale = 0.0
        btnSettings.yScale = 0.0
        btnSettings.zPosition = -1
        btnSettings.addChild(SKSpriteNode(imageNamed: "settings"))
        btnGo.addChild(self.btnSettings)
    }
    
    private func initActions() {
        var go_action_normal : SKAction!
        var go_action_reversed : SKAction!
        var play_action : SKAction!
        var settings_action : SKAction!
        var gc_action : SKAction!
        
        go_action_normal = SKAction.runBlock({
            var play_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x, y: self.btnGo.position.y + (self.btnGo.frame.height + (self.btnGo.frame.height / 4))), duration: 0.2)
            play_move.timingMode = SKActionTimingMode.EaseIn
            var play_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnPlay.runAction(SKAction.group([play_move, play_scale]))
            
            var gc_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x + (self.btnGo.frame.width + (self.btnGo.frame.width / 4)), y: self.btnGo.position.y), duration: 0.2)
            gc_move.timingMode = SKActionTimingMode.EaseIn
            var gc_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnGC.runAction(SKAction.group([gc_move, gc_scale]))
            
            var settings_move = SKAction.moveTo(CGPoint(x: self.btnGo.position.x - (self.btnGo.frame.width + (self.btnGo.frame.width / 4)), y: self.btnGo.position.y), duration: 0.2)
            settings_move.timingMode = SKActionTimingMode.EaseIn
            var settings_scale = SKAction.scaleTo(1.0, duration: 0.2)
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(0.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.userData?.setObject(go_action_reversed, forKey: "go_action")
        })
        
        go_action_reversed = SKAction.runBlock({
            var play_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            play_move.timingMode = SKActionTimingMode.EaseIn
            var play_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnPlay.runAction(SKAction.group([play_move, play_scale]))
            
            var gc_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            gc_move.timingMode = SKActionTimingMode.EaseIn
            var gc_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnGC.runAction(SKAction.group([gc_move, gc_scale]))
            
            var settings_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            settings_move.timingMode = SKActionTimingMode.EaseIn
            var settings_scale = SKAction.scaleTo(0.0, duration: 0.2)
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var content = self.btnGo.childNodeWithName("content") as SKShapeNode
            var content_scale = SKAction.scaleTo(1.0, duration: 0.2)
            content_scale.timingMode = SKActionTimingMode.EaseIn
            content.runAction(content_scale)
            
            self.userData?.setObject(go_action_normal, forKey: "go_action")
        })
        
        play_action = SKAction.runBlock({
            var gc_path = CGPathCreateMutable()
            CGPathMoveToPoint(gc_path, nil, self.btnGC.position.x, self.btnGC.position.y)
            CGPathAddArc(gc_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnGC.position), 0, CGFloat(M_PI / 2), false)
            var gc_move = SKAction.followPath(gc_path, asOffset: false, orientToPath: false, duration: 0.15)
            var gc_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnGC.zPosition = -2
            self.btnGC.runAction(SKAction.group([gc_move, gc_scale]))
            
            var settings_path = CGPathCreateMutable()
            CGPathMoveToPoint(settings_path, nil, self.btnSettings.position.x, self.btnSettings.position.y)
            CGPathAddArc(settings_path, nil, self.btnGo.position.x, self.btnGo.position.y, self.distanceFrom(self.btnGo.position, point2: self.btnSettings.position), CGFloat(M_PI), CGFloat(M_PI / 2), true)
            var settings_move = SKAction.followPath(settings_path, asOffset: false, orientToPath: false, duration: 0.15)
            var settings_scale = SKAction.scaleTo(0.0, duration: 0.15)
            self.btnSettings.runAction(SKAction.group([settings_move, settings_scale]))
            
            var play_wait = SKAction.waitForDuration(0.3)
            var play_move = SKAction.moveTo(self.btnGo.position, duration: 0.2)
            play_move.timingMode = SKActionTimingMode.EaseInEaseOut
            self.btnPlay.runAction(SKAction.sequence([play_wait, play_move]), completion: {()
                self.sceneDelegate!.showGameScene()
            })
        })
        
        self.userData?.setObject(go_action_normal, forKey: "go_action")
        self.userData?.setObject(play_action, forKey: "play_action")
    }
    
    private func distanceFrom(point1: CGPoint, point2: CGPoint) -> CGFloat {
        var xDist = (point2.x - point1.x);
        var yDist = (point2.y - point1.y);
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    private func reset() {
        rootNode.removeAllChildren()
        rootNode.removeAllActions()
        
        initButtons()
        initActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        reset()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (btnGo.containsPoint(location)) {
                var action = self.userData?.valueForKey("go_action") as SKAction
                self.runAction(action)
            }
            else if (btnPlay.containsPoint(location)) {
                var action = self.userData?.valueForKey("play_action") as SKAction
                self.runAction(action)
            }
        }
    }
}