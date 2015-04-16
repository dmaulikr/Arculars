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
        
        btnShareOnFacebook = SKShapeNode(circleOfRadius: radius)
        btnShareOnFacebook.position = CGPoint(x: -(size.width / 4), y: -(size.height / 4))
        btnShareOnFacebook.lineWidth = 1
        btnShareOnFacebook.strokeColor = Colors.AppColorOne
        btnShareOnFacebook.fillColor = btnShareOnFacebook.strokeColor
        var sfl = SKLabelNode(text: "FACEBOOK")
        sfl.userInteractionEnabled = false
        sfl.fontSize = radius / 3
        sfl.fontName = Fonts.FontNameNormal
        sfl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        sfl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnShareOnFacebook.addChild(sfl)
        rootNode.addChild(btnShareOnFacebook)
        
        btnShareOnTwitter = SKShapeNode(circleOfRadius: radius)
        btnShareOnTwitter.position = CGPoint(x: 0, y: -(size.height / 4))
        btnShareOnTwitter.lineWidth = 1
        btnShareOnTwitter.strokeColor = Colors.AppColorTwo
        btnShareOnTwitter.fillColor = btnShareOnTwitter.strokeColor
        var stl = SKLabelNode(text: "TWITTER")
        stl.userInteractionEnabled = false
        stl.fontSize = radius / 3
        stl.fontName = Fonts.FontNameNormal
        stl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        stl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnShareOnTwitter.addChild(stl)
        rootNode.addChild(btnShareOnTwitter)
        
        btnShare = SKShapeNode(circleOfRadius: radius)
        btnShare.position = CGPoint(x: (size.width / 4), y: -(size.height / 4))
        btnShare.lineWidth = 1
        btnShare.strokeColor = Colors.AppColorThree
        btnShare.fillColor = btnShare.strokeColor
        var shl = SKLabelNode(text: "...")
        shl.userInteractionEnabled = false
        shl.fontSize = size.height / 24
        shl.fontName = Fonts.FontNameNormal
        shl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        shl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnShare.addChild(shl)
        rootNode.addChild(btnShare)
        //
        
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getBottomButton(frame.size, content: "CLOSE")
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
}