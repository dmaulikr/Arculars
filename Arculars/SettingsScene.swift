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
    
    private var btnToggleVibration : SKShapeNode!
    private var vStateLabel : SKLabelNode!
    private var btnToggleSound : SKShapeNode!
    private var sStateLabel : SKLabelNode!
    private var dStateLabel : SKLabelNode!
    private var dInfoLabel : SKLabelNode!
    private var btnDifficulty : SKShapeNode!
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
        backgroundColor = Colors.BackgroundColor
        
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
        
        // INIT TOGGLE VIBRATION BUTTON
        btnToggleVibration = createButton("VIBRATION")
        btnToggleVibration.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 2))
        vStateLabel = (btnToggleVibration.childNodeWithName("label") as! SKLabelNode)
        rootNode.addChild(btnToggleVibration)
        
        // INIT TOGGLE SOUND BUTTON
        btnToggleSound = createButton("SOUND")
        btnToggleSound.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 3))
        sStateLabel = (btnToggleSound.childNodeWithName("label") as! SKLabelNode)
        rootNode.addChild(btnToggleSound)
        
        // INIT DIFFICULTY BUTTON
        btnDifficulty = createButton("DIFFICULTY")
        btnDifficulty.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 4))
        dStateLabel = (btnDifficulty.childNodeWithName("label") as! SKLabelNode)
        dInfoLabel = SKLabelNode(text: "")
        dInfoLabel.fontColor = UIColor.grayColor()
        dInfoLabel.fontSize = size.height / 64
        dInfoLabel.fontName = Fonts.FontNameNormal
        dInfoLabel.position = CGPoint(x: 0, y: -btnDifficulty.calculateAccumulatedFrame().height / 2)
        btnDifficulty.addChild(dInfoLabel)
        rootNode.addChild(btnDifficulty)
        
        // INIT RESTORE PURCHASES BUTTON
        btnRestorePurchases = Nodes.getCircleButton(CGPoint(x: 0, y: -(frame.height / 4)), radius: frame.height / 16, color: Colors.AppColorOne, content1: "RESTORE", content2: "PURCHASES")
        rootNode.addChild(btnRestorePurchases)
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "CLOSE")
        rootNode.addChild(btnClose)
    }
    
    // MARK: SETTINGS FUNCTIONS
    func getSettings() {
        if (SettingsHandler.getVibrationSetting()) { vStateLabel.text = "ON" } else { vStateLabel.text = "OFF" }
        if (SettingsHandler.getSoundSetting()) { sStateLabel.text = "ON" } else { sStateLabel.text = "OFF" }
        
        var difficulty = SettingsHandler.getDifficulty()
        dStateLabel.text = difficulty.description.uppercaseString
        switch difficulty {
        case .Easy:
            dInfoLabel.text = "Slow circle speed - Points x 1".uppercaseString
            break
        case .Normal:
            dInfoLabel.text = "Normal circle speed - Points x 2".uppercaseString
            break
        case .Hard:
            dInfoLabel.text = "Fast circle speed - Points x 4".uppercaseString
            break
        }
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
            } else if (btnDifficulty.containsPoint(location)) {
                SettingsHandler.toggleDifficulty()
                getSettings()
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
        vLabel.fontColor = Colors.FontColor
        vLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        vLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        var button = SKShapeNode(rectOfSize: CGSize(width: size.width / 4, height: size.height / 12))
        button.lineWidth = 0
        var label = SKLabelNode(text: "NaN")
        label.name = "label"
        label.zPosition = -1
        label.fontSize = size.height / 24
        label.fontName = Fonts.FontNameBold
        label.fontColor = Colors.FontColor
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        vLabel.position = CGPoint(x: 0, y: button.calculateAccumulatedFrame().height * 0.5)
        button.addChild(vLabel)
        button.addChild(label)
        
        return button
    }
}