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
    private var btnToMenu : SKShapeNode!
    
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
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: size.height / 12))
        title.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "SETTINGS")
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT TOGGLE VIBRATION BUTTON
        btnToggleVibration = createButton("VIBRATION")
        btnToggleVibration.position = CGPoint(x: 0, y: size.height / 6)
        vStateLabel = (btnToggleVibration.childNodeWithName("label") as SKLabelNode)
        rootNode.addChild(btnToggleVibration)
        
        // INIT TOGGLE SOUND BUTTON
        btnToggleSound = createButton("SOUND")
        btnToggleSound.position = CGPoint(x: 0, y: 0)
        sStateLabel = (btnToggleSound.childNodeWithName("label") as SKLabelNode)
        rootNode.addChild(btnToggleSound)
        
        // INIT DIFFICULTY BUTTON
        btnDifficulty = createButton("DIFFICULTY")
        btnDifficulty.position = CGPoint(x: 0, y: -size.height / 6)
        dStateLabel = (btnDifficulty.childNodeWithName("label") as SKLabelNode)
        dInfoLabel = SKLabelNode(text: "")
        dInfoLabel.fontColor = UIColor.grayColor()
        dInfoLabel.fontSize = size.height / 48
        dInfoLabel.fontName = Fonts.FontNameNormal
        dInfoLabel.position = CGPoint(x: 0, y: -btnDifficulty.calculateAccumulatedFrame().height / 2)
        btnDifficulty.addChild(dInfoLabel)
        rootNode.addChild(btnDifficulty)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "BACK TO MENU")
        tml.position = CGPoint(x: 0, y: -(size.height / 2) + (size.height / 12))
        tml.fontName = Fonts.FontNameNormal
        tml.fontColor = Colors.DisabledColor
        tml.fontSize = size.height / 32
        tml.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tml.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnToMenu = SKShapeNode(rect: CGRect(x: -(size.width / 2), y: -(size.height / 2), width: size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
    }
    
    // MARK: SETTINGS FUNCTIONS
    func getSettings() {
        if (SettingsHandler.getVibrationSetting()) { vStateLabel.text = "ON" } else { vStateLabel.text = "OFF" }
        if (SettingsHandler.getSoundSetting()) { sStateLabel.text = "ON" } else { sStateLabel.text = "OFF" }
        
        var difficulty = SettingsHandler.getDifficulty()
        dStateLabel.text = difficulty.description.uppercaseString
        switch difficulty {
        case .Easy:
            dInfoLabel.text = "Slow circle speed, Points x 1"
            break
        case .Normal:
            dInfoLabel.text = "Normal circle speed, Points x 2"
            break
        case .Hard:
            dInfoLabel.text = "Fast circle speed, Points x 3"
            break
        }
    }
    
    // MARK: TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (btnToMenu.containsPoint(location)) {
                sceneDelegate!.showMenu()
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
            }
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func createButton(labelText: NSString) -> SKShapeNode {
        var vLabel = SKLabelNode(text: labelText)
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