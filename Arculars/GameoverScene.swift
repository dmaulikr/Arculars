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
    
    private var touchEnabled = false
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    private var topNode = SKNode()
    
    private var replay : SKShapeNode!
    private var btnClose : SKShapeNode!
    
    private var btnShareOnFacebook : SKShapeNode!
    private var btnShareOnTwitter : SKShapeNode!
    private var btnShare : SKShapeNode!
    
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
        backgroundColor = ThemeHandler.Instance.getCurrentColors().BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        rootNode.addChild(topNode)
        topNode.position = CGPoint(x: 0, y: size.height / 2)
        
        initScene()
    }
    
    override func didMoveToView(view: SKView) {
        ttpLabel.hidden = true
        touchEnabled = false
        
        startRandomBallTimer()
        getScores()
        
        var popin = SKAction.sequence([
            SKAction.scaleTo(1.05, duration: 0.1),
            SKAction.scaleTo(0.95, duration: 0.1),
            SKAction.scaleTo(1.00, duration: 0.1),
            SKAction.waitForDuration(0.2)
            ])
        
        var flyin = SKAction.sequence([
            SKAction.moveTo(CGPoint(x: 0, y: (size.height / 2) - (size.height / 5) - 10), duration: 0.1),
            SKAction.moveTo(CGPoint(x: 0, y: (size.height / 2) - (size.height / 5) + 10), duration: 0.1),
            SKAction.moveTo(CGPoint(x: 0, y: (size.height / 2) - (size.height / 5)), duration: 0.1),
            SKAction.waitForDuration(0.2)
            ])
        
        btnShareOnFacebook.runAction(popin)
        btnShareOnTwitter.runAction(popin)
        btnShare.runAction(popin)
        
        topNode.runAction(flyin, completion: {()
            if (RateHandler.checkIfRate(StatsHandler.getPlayedGames())) {
                self.sceneDelegate?.presentRateOnAppStore()
            }
            self.touchEnabled = true
            self.ttpLabel.hidden = false
            self.ttpLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([
                SKAction.fadeAlphaTo(0.0, duration: 0.2),
                SKAction.fadeAlphaTo(1.0, duration: 0.2),
                SKAction.waitForDuration(1.5)
                ])), withKey: "blinking")
        })
    }
    
    override func willMoveFromView(view: SKView) {
        stopRandomBallTimer()
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
        
        score.text = "\(lastscore)"
        hscore.text = "\(highscore)"
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        
        ttpLabel = SKLabelNode(text: "TAP TO PLAY")
        ttpLabel.fontName = Fonts.FontNameNormal
        ttpLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        ttpLabel.fontSize = size.height / 32
        ttpLabel.position = CGPoint(x: 0, y: 0)
        
        rootNode.addChild(ttpLabel)
        
        var gameoverLabel = SKLabelNode(text: "GAME OVER!")
        gameoverLabel.fontName = Fonts.FontNameBold
        gameoverLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        gameoverLabel.fontSize = size.height / 20
        gameoverLabel.position = CGPoint(x: 0, y: 0)
        topNode.addChild(gameoverLabel)
        
        var scoreLabel = SKLabelNode(text: "YOUR SCORE")
        scoreLabel.fontName = Fonts.FontNameLight
        scoreLabel.fontColor = ThemeHandler.Instance.getCurrentColors().AppColorThree
        scoreLabel.fontSize = size.height / 48
        scoreLabel.position = CGPoint(x: -size.width / 6, y: -gameoverLabel.frame.height)
        
        score = SKLabelNode()
        score.fontName = Fonts.FontNameNormal
        score.fontColor = ThemeHandler.Instance.getCurrentColors().AppColorThree
        score.fontSize = size.height / 20
        score.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        score.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height * 2)
        scoreLabel.addChild(score)
        
        topNode.addChild(scoreLabel)
        
        var hscoreLabel = SKLabelNode(text: "HIGH SCORE")
        hscoreLabel.fontName = Fonts.FontNameLight
        hscoreLabel.fontSize = size.height / 48
        hscoreLabel.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        hscoreLabel.position = CGPoint(x: size.width / 6, y: -gameoverLabel.frame.height)
        
        hscore = SKLabelNode()
        hscore.fontName = Fonts.FontNameNormal
        hscore.fontColor = ThemeHandler.Instance.getCurrentColors().FontColor
        hscore.fontSize = size.height / 20
        hscore.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        hscore.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height * 2)
        hscoreLabel.addChild(hscore)
        
        topNode.addChild(hscoreLabel)
        
        // Add sharing buttons
        var shareLabel = SKLabelNode(text: "SHARE ON")
        shareLabel.position = CGPoint(x: 0, y: -(size.height / 6))
        shareLabel.fontName = Fonts.FontNameNormal
        shareLabel.fontSize = size.height / 48
        shareLabel.fontColor = ThemeHandler.Instance.getCurrentColors().DisabledColor
        shareLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        shareLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(shareLabel)
        
        var radius = size.height / 20
        
        btnShareOnFacebook = Nodes.getCircleButton(CGPoint(x: -(size.width / 4), y: -(size.height / 4)), radius: radius, color: ThemeHandler.Instance.getCurrentColors().AppColorOne, content1: "FACEBOOK")
        btnShareOnFacebook.yScale = 0.0
        btnShareOnFacebook.xScale = 0.0
        rootNode.addChild(btnShareOnFacebook)
        
        btnShareOnTwitter = Nodes.getCircleButton(CGPoint(x: 0, y: -(size.height / 4)), radius: radius, color: ThemeHandler.Instance.getCurrentColors().AppColorTwo, content1: "TWITTER")
        btnShareOnTwitter.yScale = 0.0
        btnShareOnTwitter.xScale = 0.0
        rootNode.addChild(btnShareOnTwitter)
        
        btnShare = Nodes.getCircleButton(CGPoint(x: (size.width / 4), y: -(size.height / 4)), radius: radius, color: ThemeHandler.Instance.getCurrentColors().DisabledColor, fontSize: radius, content1: "...")
        btnShare.yScale = 0.0
        btnShare.xScale = 0.0
        rootNode.addChild(btnShare)
        //
        
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "BACK TO MENU")
        rootNode.addChild(btnClose)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (!touchEnabled) { return }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            if (btnClose.containsPoint(location)) { }
            else if (btnShareOnFacebook.containsPoint(location)) {
                sceneDelegate!.shareScore("facebook", score: StatsHandler.getLastscore(gameMode), gameType: gameMode)
            } else if (btnShareOnTwitter.containsPoint(location)) {
                sceneDelegate!.shareScore("twitter", score: StatsHandler.getLastscore(gameMode), gameType: gameMode)
            } else if (btnShare.containsPoint(location)) {
                sceneDelegate!.shareScore("", score: StatsHandler.getLastscore(gameMode), gameType: gameMode)
            } else {
                sceneDelegate!.showGameScene(gameMode)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (!touchEnabled) { return }
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            if (btnClose.containsPoint(location)) {
                self.sceneDelegate!.showMenuScene()
            }
        }
    }
    
    // MARK: - CREATE RANDOM BALLS
    private func startRandomBallTimer() {
        var wait = SKAction.waitForDuration(0.8)
        var run = SKAction.runBlock({
            self.randomBallTimerTick()
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])), withKey: "actionTimer")
    }
    
    private func stopRandomBallTimer() {
        removeActionForKey("actionTimer")
    }
    
    private func randomBallTimerTick() {
        createRandomBall(Positions.randomPoint(frame.size))
    }
    
    private func createRandomBall(position: CGPoint) {
        var ball = SKShapeNode(circleOfRadius: frame.height / 64)
        ball.fillColor = ThemeHandler.Instance.getCurrentColors().randomAppColor()
        ball.lineWidth = 1
        ball.strokeColor = ball.fillColor
        ball.antialiased = true
        ball.position = position
        ball.zPosition = -10
        rootNode.addChild(ball)
        ball.runAction(SKAction.scaleTo(0.0, duration: NSTimeInterval((arc4random_uniform(5) + 1))), completion: {()
            ball.removeFromParent()
        })
    }
}