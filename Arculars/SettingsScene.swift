//
//  SettingsScene.swift
//  Arculars
//
//  Created by Roman Blum on 23/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class SettingsScene : SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var btnDarkTheme : SKShapeNode!
    private var btnLightTheme : SKShapeNode!
    
    private var btnToggleVibration : SKShapeNode!
    private var vStateLabel : SKLabelNode!
    private var btnToggleSound : SKShapeNode!
    private var sStateLabel : SKLabelNode!
    private var btnRestorePurchases : SKShapeNode!
    private var btnClose : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = ThemeHandler.Instance.getCurrentColors().BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
        
        alpha = 0.0
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.1))
        getSettings()
    }
    
    deinit {
        #if DEBUG
            println("SettingsScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        // INIT TITLE
        rootNode.addChild(Nodes.getSceneTitle(frame.size, content: "SETTINGS"))
        
        var rowheight = size.height / 8
        
        // INIT THEMES
        var themeLabel = SKLabelNode(text: "THEME")
        themeLabel.position = CGPoint(x: 0, y: size.height / 3)
        themeLabel.fontSize = size.height / 48
        themeLabel.fontName = Fonts.FontNameNormal
        themeLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        themeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        themeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        rootNode.addChild(themeLabel)
        
        btnDarkTheme = Nodes.getCircleButton(CGPoint(x: -size.width / 5, y: size.height / 5), radius: size.height / 16, color: Colors.BackgroundColor, fontColor: Colors.FontColor, content1: "DARK")
        rootNode.addChild(btnDarkTheme)
        
        btnLightTheme = Nodes.getCircleButton(CGPoint(x: size.width / 5, y: size.height / 5), radius: size.height / 16, color: Colors.FontColor, fontColor: Colors.BackgroundColor, content1: "LIGHT")
        rootNode.addChild(btnLightTheme)
        
        // INIT TOGGLE VIBRATION BUTTON
        btnToggleVibration = createButton("VIBRATION")
        btnToggleVibration.position = CGPoint(x: (frame.width / 5), y: 0)
        vStateLabel = (btnToggleVibration.childNodeWithName("label") as! SKLabelNode)
        rootNode.addChild(btnToggleVibration)
        
        // INIT TOGGLE SOUND BUTTON
        btnToggleSound = createButton("SOUND")
        btnToggleSound.position = CGPoint(x: -(frame.width / 5), y: 0)
        sStateLabel = (btnToggleSound.childNodeWithName("label") as! SKLabelNode)
        rootNode.addChild(btnToggleSound)
        
        // INIT RESTORE PURCHASES BUTTON
        btnRestorePurchases = Nodes.getCircleButton(CGPoint(x: 0, y: -(frame.height / 4)), radius: frame.height / 16, color: ThemeHandler.Instance.getCurrentColors().AppColorOne, fontSize: frame.height / 56, content1: "RESTORE", content2: "PURCHASES")
        rootNode.addChild(btnRestorePurchases)
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "CLOSE")
        rootNode.addChild(btnClose)
    }
    
    // MARK: SETTINGS FUNCTIONS
    func getSettings() {
        if (SettingsHandler.getVibrationSetting()) { vStateLabel.text = "ON" } else { vStateLabel.text = "OFF" }
        if (SettingsHandler.getSoundSetting()) { sStateLabel.text = "ON" } else { sStateLabel.text = "OFF" }
    }
    
    // MARK: TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (btnClose.containsPoint(location)) {
                sceneDelegate!.showMenuScene()
            } else if (btnToggleVibration.containsPoint(location)) {
                if SettingsHandler.toggleVibration() {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                getSettings()
            } else if (btnToggleSound.containsPoint(location)) {
                if SettingsHandler.toggleSound() {
                    runAction(SKAction.playSoundFileNamed("hit1.wav", waitForCompletion: false))
                }
                getSettings()
            } else if (btnDarkTheme.containsPoint(location)) {
                SettingsHandler.setTheme(Theme.Dark)
                self.sceneDelegate?.showSettingsScene()
            } else if (btnLightTheme.containsPoint(location)) {
                SettingsHandler.setTheme(Theme.Light)
                self.sceneDelegate?.showSettingsScene()
            } else if (btnRestorePurchases.containsPoint(location)) {
                self.sceneDelegate!.restorePurchases()
            }
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func createButton(labelText: NSString) -> SKShapeNode {
        var vLabel = SKLabelNode(text: labelText as String)
        vLabel.fontSize = size.height / 48
        vLabel.fontName = Fonts.FontNameNormal
        vLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        vLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        vLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        var button = SKShapeNode(rectOfSize: CGSize(width: size.width / 4, height: size.height / 12))
        button.lineWidth = 0
        var label = SKLabelNode(text: "NaN")
        label.name = "label"
        label.zPosition = -1
        label.fontSize = size.height / 24
        label.fontName = Fonts.FontNameBold
        label.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        vLabel.position = CGPoint(x: 0, y: button.calculateAccumulatedFrame().height * 0.5)
        button.addChild(vLabel)
        button.addChild(label)
        
        return button
    }
}