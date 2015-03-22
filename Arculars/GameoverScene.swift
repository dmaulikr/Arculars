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
    
    var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants
    private var rootNode = SKNode()
    
    private var replay : SKShapeNode!
    private var facebook : SKShapeNode!
    private var twitter : SKShapeNode!
    
    private var tomenuLabel : SKLabelNode!
    private var scoreLabel : SKLabelNode!
    private var hscoreLabel : SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Add Root Node
        self.addChild(rootNode)
        
        initScene()
    }
    
    private func initScene() {
        var radius = self.size.height / 16
        
        var ttpLabel = SKLabelNode(text: "TAB TO PLAY")
        ttpLabel.fontName = "Avenir"
        ttpLabel.fontSize = self.size.height / 32
        ttpLabel.position = CGPoint(x: 0, y: self.size.height / 4)
        ttpLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.fadeAlphaTo(0.0, duration: 0.2),
            SKAction.fadeAlphaTo(1.0, duration: 0.2),
            SKAction.waitForDuration(1.5)
        ])))
        rootNode.addChild(ttpLabel)
        
        scoreLabel = SKLabelNode(text: "Score")
        scoreLabel.fontName = "Avenir-Black"
        scoreLabel.fontColor = Colors.FontColor
        scoreLabel.fontSize = self.size.height / 12
        scoreLabel.position = CGPoint(x: 0, y: 0)
        rootNode.addChild(scoreLabel)
        
        hscoreLabel = SKLabelNode(text: "Highscore")
        hscoreLabel.fontName = "Avenir-Light"
        hscoreLabel.fontSize = self.size.height / 32
        hscoreLabel.fontColor = Colors.FontColor
        hscoreLabel.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height)
        rootNode.addChild(hscoreLabel)
        
        facebook = SKShapeNode(circleOfRadius: radius)
        facebook.fillColor = Colors.FacebookBlue
        facebook.strokeColor = Colors.FacebookBlue
        facebook.antialiased = true
        facebook.lineWidth = 1
        facebook.position = CGPoint(x: -(facebook.frame.width * 0.8), y: -(self.size.height / 4))
        facebook.addChild(SKSpriteNode(imageNamed: "facebook"))
        rootNode.addChild(facebook)
        
        twitter = SKShapeNode(circleOfRadius: radius)
        twitter.fillColor = Colors.TwitterBlue
        twitter.strokeColor = Colors.TwitterBlue
        twitter.antialiased = true
        twitter.lineWidth = 1
        twitter.position = CGPoint(x: (twitter.frame.width * 0.8), y: -(self.size.height / 4))
        twitter.addChild(SKSpriteNode(imageNamed: "twitter"))
        rootNode.addChild(twitter)
        
        tomenuLabel = SKLabelNode(text: "TO MENU")
        tomenuLabel.fontName = "Avenir"
        tomenuLabel.fontColor = Colors.FontColor
        tomenuLabel.fontSize = self.size.height / 32
        tomenuLabel.position = CGPoint(x: 0, y: -(self.size.height / 2) + (self.size.height / 16))
        rootNode.addChild(tomenuLabel)
    }
    
    override func didMoveToView(view: SKView) {
        var lastscore = NSUserDefaults.standardUserDefaults().integerForKey("lastscore")
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        
        scoreLabel.text = "Score \(lastscore)"
        hscoreLabel.text = "Highscore \(highscore)"
        
        self.runAction(SKAction.fadeInWithDuration(0.3))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (tomenuLabel.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            } else if (twitter.containsPoint(location)) {
                shareOnTwitter()
            }
            else if (facebook.containsPoint(location)) {
                shareOnFacebook()
            } else {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showGameScene()
                })
            }
        }
    }
    
    private func shareOnTwitter() {
        
    }
    
    private func shareOnFacebook() {
        
    }
}