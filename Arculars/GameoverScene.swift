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
    
    private var facebook : SKSpriteNode!
    private var twitter : SKSpriteNode!
    private var whatsapp : SKSpriteNode!
    private var shareother : SKSpriteNode!
    
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
        backgroundColor = Colors.BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
    }
    
    override func didMoveToView(view: SKView) {
        getScores()
        if (RateHandler.checkIfRate(StatsHandler.getPlayedGames())) {
            sceneDelegate?.presentRateOnAppStore()
        }
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
        
        var radius = size.height / 24
        
        var shareLabel = SKLabelNode(text: "SHARE YOUR SCORE")
        shareLabel.position = CGPoint(x: 0, y: -(size.height / 6))
        shareLabel.fontName = Fonts.FontNameNormal
        shareLabel.fontSize = size.height / 48
        shareLabel.fontColor = Colors.DisabledColor
        shareLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        shareLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(shareLabel)
        
        facebook = SKSpriteNode(imageNamed: "icon-facebook")
        facebook.position = CGPoint(x: -(size.width / 2) + (size.width / 5), y: -(size.height / 4))
        var arFacebook = facebook.size.width / facebook.size.height
        facebook.size = CGSize(width: 2 * radius, height: (2 * radius) / arFacebook)
        rootNode.addChild(facebook)
        
        twitter = SKSpriteNode(imageNamed: "icon-twitter")
        twitter.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 2), y: -(size.height / 4))
        var arTwitter = twitter.size.width / twitter.size.height
        twitter.size = CGSize(width: 2 * radius, height: (2 * radius) / arTwitter)
        rootNode.addChild(twitter)
        
        whatsapp = SKSpriteNode(imageNamed: "icon-whatsapp")
        whatsapp.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 3), y: -(size.height / 4))
        var arWhatsapp = whatsapp.size.width / whatsapp.size.height
        whatsapp.size = CGSize(width: 2 * radius, height: (2 * radius) / arWhatsapp)
        rootNode.addChild(whatsapp)
        
        shareother = SKSpriteNode(imageNamed: "icon-share")
        shareother.position = CGPoint(x: -(size.width / 2) + ((size.width / 5) * 4), y: -(size.height / 4))
        var arShare = shareother.size.width / shareother.size.height
        shareother.size = CGSize(width: 2 * radius, height: (2 * radius) / arShare)
        rootNode.addChild(shareother)
        
        var tomenuLabel = SKLabelNode(text: "BACK TO MENU")
        tomenuLabel.fontName = Fonts.FontNameNormal
        tomenuLabel.fontColor = Colors.DisabledColor
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
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (tomenu.containsPoint(location)) {
                self.sceneDelegate!.showMenuScene()
            } else if (twitter.containsPoint(location)) {
                sceneDelegate!.shareOnTwitter()
            } else if (facebook.containsPoint(location)) {
                sceneDelegate!.shareOnFacebook()
            } else if (whatsapp.containsPoint(location)) {
                sceneDelegate!.shareOnWhatsApp()
            } else if (shareother.containsPoint(location)) {
                sceneDelegate!.shareOnOther()
            } else {
                sceneDelegate!.showGameScene(gameMode)
            }
        }
    }
}