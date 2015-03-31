//
//  GameoverScene.swift
//  Arculars
//
//  Created by Roman Blum on 22/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Social

class GameoverScene: SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    var gameMode : GameMode!
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var replay : SKShapeNode!
    private var tomenu : SKShapeNode!
    
    private var facebook : SKShapeNode!
    private var twitter : SKShapeNode!
    private var whatsapp : SKShapeNode!
    private var shareother : SKShapeNode!
    
    private var ttpLabel : SKLabelNode!
    private var score : SKLabelNode!
    private var hscore : SKLabelNode!
    
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
        getScores()
    }
    
    deinit {
        #if DEBUG
            println("GameOverScene deinit is called")
        #endif
    }
    
    // MARK: - SCORES 
    private func getScores() {
        var lastscore = StatsHandler.getLastscore(gameMode)
        var highscore = StatsHandler.getHighscore(gameMode)
        
        ttpLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.fadeAlphaTo(0.0, duration: 0.2),
            SKAction.fadeAlphaTo(1.0, duration: 0.2),
            SKAction.waitForDuration(1.5)
            ])), withKey: "blinking")
        
        score.text = "\(lastscore)"
        hscore.text = "\(highscore)"
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        var radius = size.height / 21
        
        ttpLabel = SKLabelNode(text: "TAP TO PLAY")
        ttpLabel.fontName = Fonts.FontNameNormal
        ttpLabel.fontSize = size.height / 32
        ttpLabel.position = CGPoint(x: 0, y: 0)
        
        rootNode.addChild(ttpLabel)
        
        var gameoverLabel = SKLabelNode(text: "GAME OVER!")
        gameoverLabel.fontName = Fonts.FontNameBold
        gameoverLabel.fontColor = Colors.FontColor
        gameoverLabel.fontSize = size.height / 20
        gameoverLabel.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 5))
        rootNode.addChild(gameoverLabel)
        
        var scoreLabel = SKLabelNode(text: "YOUR SCORE")
        scoreLabel.fontName = Fonts.FontNameLight
        scoreLabel.fontColor = Colors.AppColorThree
        scoreLabel.fontSize = size.height / 48
        scoreLabel.position = CGPoint(x: -size.width / 6, y: size.height / 4)
        
        score = SKLabelNode()
        score.fontName = Fonts.FontNameNormal
        score.fontColor = Colors.AppColorThree
        score.fontSize = size.height / 20
        score.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        score.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height * 2)
        scoreLabel.addChild(score)
        
        rootNode.addChild(scoreLabel)
        
        var hscoreLabel = SKLabelNode(text: "HIGH SCORE")
        hscoreLabel.fontName = Fonts.FontNameLight
        hscoreLabel.fontSize = size.height / 48
        hscoreLabel.fontColor = Colors.FontColor
        hscoreLabel.position = CGPoint(x: size.width / 6, y: size.height / 4)
        
        hscore = SKLabelNode()
        hscore.fontName = Fonts.FontNameNormal
        hscore.fontColor = Colors.FontColor
        hscore.fontSize = size.height / 20
        hscore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        hscore.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height * 2)
        hscoreLabel.addChild(hscore)
        
        rootNode.addChild(hscoreLabel)
        
        facebook = SKShapeNode(circleOfRadius: radius)
        facebook.fillColor = Colors.FacebookBlue
        facebook.strokeColor = Colors.FacebookBlue
        facebook.antialiased = true
        facebook.lineWidth = 1
        facebook.zPosition = 3
        facebook.position = CGPoint(x: -(size.width / 2) + (size.width / 5), y: -(size.height / 4))
        facebook.addChild(SKSpriteNode(imageNamed: "icon-facebook"))
        rootNode.addChild(facebook)
        
        twitter = SKShapeNode(circleOfRadius: radius)
        twitter.fillColor = Colors.TwitterBlue
        twitter.strokeColor = Colors.TwitterBlue
        twitter.antialiased = true
        twitter.lineWidth = 1
        twitter.zPosition = 4
        twitter.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 2), y: -(size.height / 4))
        var twitterSprite = SKSpriteNode(imageNamed: "icon-twitter")
        twitter.addChild(twitterSprite)
        rootNode.addChild(twitter)
        
        whatsapp = SKShapeNode(circleOfRadius: radius)
        whatsapp.fillColor = Colors.WhatsAppGreen
        whatsapp.strokeColor = Colors.WhatsAppGreen
        whatsapp.antialiased = true
        whatsapp.lineWidth = 1
        whatsapp.zPosition = 2
        whatsapp.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 3), y: -(size.height / 4))
        whatsapp.addChild(SKSpriteNode(imageNamed: "icon-whatsapp"))
        rootNode.addChild(whatsapp)
        
        shareother = SKShapeNode(circleOfRadius: radius)
        shareother.fillColor = Colors.SharingGray
        shareother.strokeColor = Colors.SharingGray
        shareother.antialiased = true
        shareother.lineWidth = 1
        shareother.zPosition = 1
        shareother.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 4), y: -(size.height / 4))
        shareother.addChild(SKSpriteNode(imageNamed: "icon-share"))
        rootNode.addChild(shareother)
        
        var tomenuLabel = SKLabelNode(text: "BACK TO MENU")
        tomenuLabel.fontName = Fonts.FontNameNormal
        tomenuLabel.fontColor = Colors.FontColor
        tomenuLabel.fontSize = size.height / 32
        tomenu = SKShapeNode(rect: CGRect(x: -(size.width / 2), y: -(size.height / 2), width: size.width, height: tomenuLabel.frame.height * 4))
        tomenu.lineWidth = 0
        tomenu.fillColor = UIColor.clearColor()
        tomenu.strokeColor = UIColor.clearColor()
        tomenuLabel.position = CGPoint(x: 0, y: -(size.height / 2) + (tomenuLabel.frame.height * 1.5))
        tomenu.addChild(tomenuLabel)
        rootNode.addChild(tomenu)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (tomenu.containsPoint(location)) {
                runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenu()
                })
            } else if (twitter.containsPoint(location)) {
                sceneDelegate!.shareOnTwitter()
            } else if (facebook.containsPoint(location)) {
                sceneDelegate!.shareOnFacebook()
            } else if (whatsapp.containsPoint(location)) {
                sceneDelegate!.shareOnWhatsApp()
            } else if (shareother.containsPoint(location)) {
                sceneDelegate!.shareOnOther()
            } else {
                runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.startGame(self.gameMode)
                })
            }
        }
    }
}