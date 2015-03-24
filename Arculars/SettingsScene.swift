//
//  SettingsScene.swift
//  Arculars
//
//  Created by Roman Blum on 23/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene : SKScene {
    
    var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var btnToggleVibration : SKShapeNode!
    private var vStateLabel : SKLabelNode!
    private var btnToggleSound : SKShapeNode!
    private var sStateLabel : SKLabelNode!
    private var btnToMenu : SKShapeNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Add Root Node
        self.addChild(rootNode)
        
        initScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initScene() {
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: self.size.width / 3, height: self.size.height / 12))
        title.position = CGPoint(x: 0, y: (self.size.height / 2) - (self.size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "SETTINGS")
        titleLabel.fontSize = self.size.height / 32
        titleLabel.fontName = "Avenir-Black"
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT TOGGLE VIBRATION BUTTON
        var vLabel = SKLabelNode(text: "VIBRATION")
        vLabel.fontSize = self.size.height / 32
        vLabel.fontName = "Avenir"
        vLabel.fontColor = Colors.FontColor
        vLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        vLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnToggleVibration = SKShapeNode(rectOfSize: CGSize(width: self.size.width / 4, height: self.size.height / 12))
        btnToggleVibration.position = CGPoint(x: 0, y: -2 * vLabel.frame.height)
        btnToggleVibration.lineWidth = 0
        vStateLabel = SKLabelNode(text: "NaN")
        vStateLabel.zPosition = -1
        vStateLabel.fontSize = self.size.height / 24
        vStateLabel.fontName = "Avenir-Black"
        vStateLabel.fontColor = Colors.FontColor
        vStateLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        vStateLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        vLabel.position = CGPoint(x: 0, y: btnToggleVibration.calculateAccumulatedFrame().height * 0.75)
        btnToggleVibration.addChild(vLabel)
        btnToggleVibration.addChild(vStateLabel)
        btnToggleVibration.position = CGPoint(x: 0, y: self.size.height / 12)
        rootNode.addChild(btnToggleVibration)
        
        // INIT TOGGLE SOUND BUTTON
        var sLabel = SKLabelNode(text: "SOUND")
        sLabel.fontSize = self.size.height / 32
        sLabel.fontName = "Avenir"
        sLabel.fontColor = Colors.FontColor
        sLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        sLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnToggleSound = SKShapeNode(rectOfSize: CGSize(width: self.size.width / 4, height: self.size.height / 12))
        btnToggleSound.position = CGPoint(x: 0, y: 0)
        btnToggleSound.lineWidth = 0
        sStateLabel = SKLabelNode(text: "NaN")
        sStateLabel.zPosition = -1
        sStateLabel.fontSize = self.size.height / 24
        sStateLabel.fontName = "Avenir-Black"
        sStateLabel.fontColor = Colors.FontColor
        sStateLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        sStateLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        sLabel.position = CGPoint(x: 0, y: btnToggleSound.calculateAccumulatedFrame().height * 0.75)
        btnToggleSound.addChild(sLabel)
        btnToggleSound.addChild(sStateLabel)
        btnToggleSound.position = CGPoint(x: 0, y: -self.size.height / 12)
        rootNode.addChild(btnToggleSound)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "BACK TO MENU")
        tml.position = CGPoint(x: 0, y: -(self.size.height / 2) + (self.size.height / 24))
        tml.fontName = "Avenir"
        tml.fontColor = Colors.FontColor
        tml.fontSize = self.size.height / 32
        btnToMenu = SKShapeNode(rect: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
    }
    
    override func didMoveToView(view: SKView) {
        self.getSettings()
        self.runAction(SKAction.fadeInWithDuration(0.3))
    }
    
    func getSettings() {
        if (ConfigHandler.getVibrationSetting()) { vStateLabel.text = "ON" } else { vStateLabel.text = "OFF" }
        if (ConfigHandler.getSoundSetting()) { sStateLabel.text = "ON" } else { sStateLabel.text = "OFF" }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (btnToMenu.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            } else if (btnToggleVibration.containsPoint(location)) {
                ConfigHandler.toggleVibration()
                self.getSettings()
            } else if (btnToggleSound.containsPoint(location)) {
                ConfigHandler.toggleSound()
                self.getSettings()
            }
        }
    }
}