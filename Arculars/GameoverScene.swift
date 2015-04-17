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
        backgroundColor = Colors.BackgroundColor
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
    }
    
    override func didMoveToView(view: SKView) {
        startRandomBallTimer()
        getScores()
        if (RateHandler.checkIfRate(StatsHandler.getPlayedGames())) {
            sceneDelegate?.presentRateOnAppStore()
        }
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
        
        // Add sharing buttons
        var shareLabel = SKLabelNode(text: "SHARE ON")
        shareLabel.position = CGPoint(x: 0, y: -(size.height / 6))
        shareLabel.fontName = Fonts.FontNameNormal
        shareLabel.fontSize = size.height / 48
        shareLabel.fontColor = Colors.DisabledColor
        shareLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        shareLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(shareLabel)
        
        var radius = size.height / 20
        
        btnShareOnFacebook = Nodes.getCircleButton(CGPoint(x: -(size.width / 4), y: -(size.height / 4)), radius: radius, color: Colors.AppColorOne, content1: "FACEBOOK")
        rootNode.addChild(btnShareOnFacebook)
        
        btnShareOnTwitter = Nodes.getCircleButton(CGPoint(x: 0, y: -(size.height / 4)), radius: radius, color: Colors.AppColorTwo, content1: "TWITTER")
        rootNode.addChild(btnShareOnTwitter)
        
        btnShare = Nodes.getCircleButton(CGPoint(x: (size.width / 4), y: -(size.height / 4)), radius: radius, color: Colors.PowerupColor, content1: "...")
        rootNode.addChild(btnShare)
        //
        
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "BACK TO MENU")
        rootNode.addChild(btnClose)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
        ball.fillColor = Colors.randomAppColor()
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