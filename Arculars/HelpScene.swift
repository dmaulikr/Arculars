//
//  HelpScene.swift
//  Arculars
//
//  Created by Roman Blum on 30/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import AudioToolbox

class HelpScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var isPageSwitching = false
    private var current : SKNode?
    private var currentPage : Int!
    
    private var ballRadius : CGFloat
    private let hit1Sound = SKAction.playSoundFileNamed("hit1.wav", waitForCompletion: false)
    
    // PAGE ONE
    private var btnGotoPage2 : SKShapeNode!
    private var p1Ball : Ball!
    private var p1Score : Score!
    
    // PAGE TWO
    private var btnGotoPage3 : SKShapeNode!
    private var p2Ball : Ball!
    private var p2Score : Score!
    private var p2Powerup : Powerup!
    private var p2Circles = [Circle]()
    
    // PAGE THREE
    private var btnGotoPage4 : SKShapeNode!
    
    // PAGE FOUR
    private var btnDarkTheme : SKShapeNode!
    private var btnLightTheme : SKShapeNode!
    private var btnToggleVibration : SKShapeNode!
    private var vStateLabel : SKLabelNode!
    private var btnToggleSound : SKShapeNode!
    private var sStateLabel : SKLabelNode!
    
    private var btnClose : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, page: Int) {
        ballRadius = size.height / 80
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = ThemeHandler.Instance.getCurrentColors().BackgroundColor
        
        // Setup Scene Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(size.width / 2), -(size.height / 2), size.width, size.height))
        physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.dynamic = true

        switch page {
        case 1:
            current = initPageOne()
            break
        case 2:
            current = initPageTwo()
            break
        case 3:
            current = initPageThree()
            break
        case 4:
            current = initPageFour()
            break
        default:
            break
        }
        
        currentPage = page
        addChild(current!)
        
        alpha = 0.0
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.1))
    }
    
    deinit {
        #if DEBUG
            println("HelpScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initPageOne() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "HOW TO PLAY"))
        
        var pageLabel_1 = createLabel("Hit the arc matching")
        pageLabel_1.position = CGPoint(x: 0, y: -size.height / 6)
        page.addChild(pageLabel_1)
        var pageLabel_2 = createLabel("the ball's color")
        pageLabel_2.position = CGPoint(x: 0, y: pageLabel_1.position.y - (pageLabel_1.frame.height))
        page.addChild(pageLabel_2)
        
        btnGotoPage2 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage2)
        
        var sub = SKNode()
        page.addChild(sub)
        var create = SKAction.runBlock({()
            sub.removeAllChildren()
            
            var radius = self.size.height / 24
            var thickness = self.size.height / 40
            
            var c1 = Circle(position: CGPoint(x: 0, y: (self.size.height / 4)), radius: radius, thickness: thickness, clockwise: false, pointsPerHit: 2, color: ThemeHandler.Instance.getCurrentColors().AppColorOne)
            c1.setSpeed(3.0, max: 3.0)
            sub.addChild(c1)
            
            var c2 = Circle(position: CGPoint(x: 0, y: (self.size.height / 4)), radius: radius + thickness, thickness: thickness, clockwise: true, pointsPerHit: 1, color: ThemeHandler.Instance.getCurrentColors().AppColorThree)
            c2.setSpeed(2.0, max: 2.0)
            sub.addChild(c2)
            
            self.p1Score = Score(position: CGPoint(x: 0, y: (self.size.height / 4) + radius + (3 * thickness)))
            self.p1Score.fontSize = self.size.height / 40
            sub.addChild(self.p1Score)
            
        })
        var add = SKAction.runBlock({()
            self.p1Ball = Ball(color: ThemeHandler.Instance.getCurrentColors().AppColorOne, position: CGPoint(x: 0, y: 0), radius: self.ballRadius)
            sub.addChild(self.p1Ball.fadeIn())
        })
        var wait = SKAction.waitForDuration(2.0)
        var shoot = SKAction.runBlock({()
            self.p1Ball.shoot(self.size.height)
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([create, add, wait, shoot, add, wait, shoot, add, wait])))
        
        return page
    }
    
    private func initPageTwo() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "POWERUPS"))
        
        var pageLabel_1 = createLabel("Collect powerups")
        pageLabel_1.position = CGPoint(x: 0, y: -size.height / 6)
        page.addChild(pageLabel_1)
        var pageLabel_2 = createLabel("to boost your score")
        pageLabel_2.position = CGPoint(x: 0, y: pageLabel_1.position.y - (pageLabel_1.frame.height))
        page.addChild(pageLabel_2)
        var pageLabel_3 = createLabel("There are various powerups in the game")
        pageLabel_3.fontSize = size.height / 48
        pageLabel_3.position = CGPoint(x: 0, y: pageLabel_1.position.y - (2 * pageLabel_1.frame.height))
        page.addChild(pageLabel_3)
        
        btnGotoPage3 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage3)
        
        var sub = SKNode()
        page.addChild(sub)
        var create = SKAction.runBlock({()
            sub.removeAllChildren()
            
            var radius = self.size.height / 24
            var thickness = self.size.height / 40
            
            self.p2Score = Score(position: CGPoint(x: 0, y: (self.size.height / 4) + radius + (3 * thickness)))
            self.p2Score.fontSize = self.size.height / 40
            sub.addChild(self.p2Score)
            
            var c1 = Circle(position: CGPoint(x: 0, y: (self.size.height / 4)), radius: radius, thickness: thickness, clockwise: false, pointsPerHit: 2, color: ThemeHandler.Instance.getCurrentColors().AppColorOne)
            c1.setSpeed(3.0, max: 3.0)
            self.p2Circles.append(c1)
            sub.addChild(c1)
            
            var c2 = Circle(position: CGPoint(x: 0, y: (self.size.height / 4)), radius: radius + thickness, thickness: thickness, clockwise: true, pointsPerHit: 1, color: ThemeHandler.Instance.getCurrentColors().AppColorThree)
            c2.setSpeed(2.0, max: 2.0)
            self.p2Circles.append(c2)
            sub.addChild(c2)
            
            self.p2Powerup = Powerup(radius: self.ballRadius * 2, type: PowerupType.Unicolor)
            self.p2Powerup.position = c1.position
            sub.addChild(self.p2Powerup)
            
            self.p2Ball = Ball(color: ThemeHandler.Instance.getCurrentColors().AppColorOne, position: CGPoint(x: 0, y: 0), radius: self.ballRadius)
            sub.addChild(self.p2Ball.fadeIn())
        })
        var wait1 = SKAction.waitForDuration(2.0)
        var shoot = SKAction.runBlock({()
            self.p2Ball.shoot(self.size.height)
        })
        var wait2 = SKAction.waitForDuration(4.0)
        runAction(SKAction.repeatActionForever(SKAction.sequence([create, wait1, shoot, wait2])))
        
        return page
    }
    
    private func initPageThree() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "GAME CENTER"))
        
        var icon = SKSpriteNode(imageNamed: "icon-trophy")
        icon.colorBlendFactor = 1.0
        icon.color = ThemeHandler.Instance.getCurrentColors().PowerupColor
        icon.position = CGPoint(x: 0, y: size.height / 6)
        page.addChild(icon)
        
        var pageLabel_1 = createLabel("Log in to Game Center")
        pageLabel_1.position = CGPoint(x: 0, y: 0)
        page.addChild(pageLabel_1)
        var pageLabel_2 = createLabel("to earn achievements and")
        pageLabel_2.position = CGPoint(x: 0, y: pageLabel_1.position.y - (pageLabel_1.frame.height))
        page.addChild(pageLabel_2)
        var pageLabel_3 = createLabel("rank in leaderboards")
        pageLabel_3.position = CGPoint(x: 0, y: pageLabel_1.position.y - (2 * pageLabel_1.frame.height))
        page.addChild(pageLabel_3)
        
        btnGotoPage4 = Nodes.getTextButton(frame.size, content: "NEXT")
        page.addChild(btnGotoPage4)
        
        return page
    }
    
    private func initPageFour() -> SKNode {
        var page = SKNode()
        page.addChild(Nodes.getSceneTitle(frame.size, content: "SETTINGS"))
        
        var rowheight = size.height / 8
        
        // INIT THEMES
        btnDarkTheme = Nodes.getCircleButton(CGPoint(x: -size.width / 5, y: size.height / 8), radius: size.height / 16, color: Colors.BackgroundColor, fontColor: Colors.FontColor, content1: "DARK")
        page.addChild(btnDarkTheme)
        
        btnLightTheme = Nodes.getCircleButton(CGPoint(x: size.width / 5, y: size.height / 8), radius: size.height / 16, color: Colors.FontColor, fontColor: Colors.BackgroundColor, content1: "LIGHT")
        page.addChild(btnLightTheme)
        
        var themeLabel = SKLabelNode(text: "CHOOSE THEME")
        themeLabel.position = CGPoint(x: 0, y: btnDarkTheme.position.y + (btnDarkTheme.frame.height / 2) + themeLabel.frame.height)
        themeLabel.fontSize = size.height / 48
        themeLabel.fontName = Fonts.FontNameNormal
        themeLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        themeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        themeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        page.addChild(themeLabel)
        
        // INIT TOGGLE VIBRATION BUTTON
        btnToggleVibration = createButton("VIBRATION")
        btnToggleVibration.position = CGPoint(x: (frame.width / 5), y: -size.height / 8)
        vStateLabel = (btnToggleVibration.childNodeWithName("label") as! SKLabelNode)
        page.addChild(btnToggleVibration)
        
        // INIT TOGGLE SOUND BUTTON
        btnToggleSound = createButton("SOUND")
        btnToggleSound.position = CGPoint(x: -(frame.width / 5), y: -size.height / 8)
        sStateLabel = (btnToggleSound.childNodeWithName("label") as! SKLabelNode)
        page.addChild(btnToggleSound)
        
        getSettings()
        
        btnClose = Nodes.getTextButton(frame.size, content: "LET'S GO")
        page.addChild(btnClose)
        
        return page
    }
    
    func getSettings() {
        if (SettingsHandler.getVibrationSetting()) { vStateLabel.text = "ON" } else { vStateLabel.text = "OFF" }
        if (SettingsHandler.getSoundSetting()) { sStateLabel.text = "ON" } else { sStateLabel.text = "OFF" }
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (isPageSwitching) { return }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            switch currentPage {
            case 1:
                self.removeAllActions()
                currentPage = 2
                pageSwitch(current!, right: initPageTwo())
                break
            case 2:
                self.removeAllActions()
                currentPage = 3
                pageSwitch(current!, right: initPageThree())
                break
            case 3:
                self.removeAllActions()
                currentPage = 4
                pageSwitch(current!, right: initPageFour())
                break
            case 4:
                if (btnToggleVibration.containsPoint(location)) {
                    if SettingsHandler.toggleVibration() {
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                    getSettings()
                } else if (btnToggleSound.containsPoint(location)) {
                    if SettingsHandler.toggleSound() {
                        runAction(hit1Sound)
                    }
                    getSettings()
                } else if (btnDarkTheme.containsPoint(location)) {
                    if (ThemeHandler.Instance.getTheme() != Theme.Dark) {
                        ThemeHandler.Instance.setTheme(Theme.Dark)
                        self.sceneDelegate?.showHelpScene(4)
                    }
                } else if (btnLightTheme.containsPoint(location)) {
                    if (ThemeHandler.Instance.getTheme() != Theme.Light) {
                        ThemeHandler.Instance.setTheme(Theme.Light)
                        self.sceneDelegate?.showHelpScene(4)
                    }
                } else {
                    self.removeAllActions()
                    sceneDelegate?.showMenuScene()
                }
                break
            default:
                break
            }
        }
    }
    
    // MARK: - CONTACTS DELEGATE
    func didBeginContact(contact: SKPhysicsContact) {
        var ball : Ball
        var circle : Circle
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
        case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
                circle = contact.bodyB.node!.parent as! Circle // parent because the arc's parent
            } else {
                ball = contact.bodyB.node as! Ball
                circle = contact.bodyA.node!.parent as! Circle // parent because the arc's parent
            }
            
            ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
            ball.removeFromParent()
            
            if (ball.nodeColor == circle.nodeColor) {
                runAction(hit1Sound)
                if (currentPage == 1) {
                    p1Score.increaseByWithColor(circle.pointsPerHit, color: circle.nodeColor)
                } else if (currentPage == 2) {
                    p2Score.increaseByWithColor(circle.pointsPerHit, color: circle.nodeColor)
                }
            } else {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            break
        case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            ball.removeFromParent()
            break
        case PhysicsCategory.powerup.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            
            ball.removeFromParent()
            p2Ball?.removeFromParent()
            p2Powerup.removeFromParent()
            
            for circle in p2Circles {
                circle.setColor(ThemeHandler.Instance.getCurrentColors().PowerupColor)
            }
            var create = SKAction.runBlock({()
                self.p2Ball = Ball(color: ThemeHandler.Instance.getCurrentColors().PowerupColor, position: CGPoint(x: 0, y: 0), radius: self.ballRadius)
                self.current!.addChild(self.p2Ball.fadeIn())
            })
            var wait = SKAction.waitForDuration(0.25)
            var shoot = SKAction.runBlock({()
                self.p2Ball.shoot(self.size.height)
            })
            runAction(SKAction.repeatAction(SKAction.sequence([create, wait, shoot]), count: 10))
            
            break
        default:
            return
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func pageSwitch(left: SKNode, right: SKNode) {
        isPageSwitching = true
        
        right.position = CGPoint(x: size.width, y: 0)
        addChild(right)
        
        var fadeOut = SKAction.moveByX(-size.width, y: 0, duration: 0.3)
        fadeOut.timingMode = SKActionTimingMode.EaseOut
        var fadeIn = SKAction.moveByX(-size.width, y: 0, duration: 0.3)
        fadeIn.timingMode = SKActionTimingMode.EaseOut
        
        left.runAction(fadeOut)
        right.runAction(fadeIn, completion: {()
            left.removeFromParent()
            self.isPageSwitching = false
            self.current = right
        })
    }
    
    private func createLabel(text: String) -> SKLabelNode {
        var label = SKLabelNode(text: text)
        label.fontSize = size.height / 24
        label.fontName = Fonts.FontNameNormal
        label.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return label
    }
    
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