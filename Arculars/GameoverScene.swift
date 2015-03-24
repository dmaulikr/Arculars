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
    private var tomenu : SKShapeNode!
    
    private var facebook : SKShapeNode!
    private var twitter : SKShapeNode!
    private var whatsapp : SKShapeNode!
    private var shareother : SKShapeNode!
    
    private var ttpLabel : SKLabelNode!
    private var scoreLabel : SKLabelNode!
    private var hscoreLabel : SKLabelNode!
    private var hscoreBadge : SKShapeNode!
    
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
        var offset = CGFloat(8)
        
        ttpLabel = SKLabelNode(text: "TAP TO PLAY")
        ttpLabel.fontName = "Avenir"
        ttpLabel.fontSize = self.size.height / 32
        ttpLabel.position = CGPoint(x: 0, y: self.size.height / 4)
        
        rootNode.addChild(ttpLabel)
        
        scoreLabel = SKLabelNode(text: "Score")
        scoreLabel.fontName = "Avenir-Black"
        scoreLabel.fontColor = Colors.FontColor
        scoreLabel.fontSize = self.size.height / 12
        scoreLabel.position = CGPoint(x: 0, y: 0)
        rootNode.addChild(scoreLabel)
        
        hscoreLabel = SKLabelNode(text: "Highscore")
        hscoreLabel.fontName = "Avenir-Light"
        hscoreLabel.fontSize = self.size.height / 36
        hscoreLabel.fontColor = Colors.FontColor
        hscoreLabel.position = CGPoint(x: 0, y: -scoreLabel.frame.size.height)
        rootNode.addChild(hscoreLabel)
        
        hscoreBadge = SKShapeNode(circleOfRadius: hscoreLabel.frame.height / 4)
        hscoreBadge.fillColor = Colors.AppColorThree
        hscoreBadge.strokeColor = Colors.AppColorThree
        hscoreBadge.lineWidth = 1
        
        facebook = SKShapeNode(circleOfRadius: radius)
        facebook.fillColor = Colors.FacebookBlue
        facebook.strokeColor = Colors.FacebookBlue
        facebook.antialiased = true
        facebook.lineWidth = 1
        facebook.zPosition = 3
        facebook.position = CGPoint(x: -radius + offset, y: -(self.size.height / 4))
        facebook.addChild(SKSpriteNode(imageNamed: "facebook"))
        rootNode.addChild(facebook)
        
        twitter = SKShapeNode(circleOfRadius: radius)
        twitter.fillColor = Colors.TwitterBlue
        twitter.strokeColor = Colors.TwitterBlue
        twitter.antialiased = true
        twitter.lineWidth = 1
        twitter.zPosition = 4
        twitter.position = CGPoint(x: facebook.position.x - (2 * radius) + offset, y: -(self.size.height / 4))
        twitter.addChild(SKSpriteNode(imageNamed: "twitter"))
        rootNode.addChild(twitter)
        
        whatsapp = SKShapeNode(circleOfRadius: radius)
        whatsapp.fillColor = Colors.WhatsAppGreen
        whatsapp.strokeColor = Colors.WhatsAppGreen
        whatsapp.antialiased = true
        whatsapp.lineWidth = 1
        whatsapp.zPosition = 2
        whatsapp.position = CGPoint(x: radius - offset, y: -(self.size.height / 4))
        whatsapp.addChild(SKSpriteNode(imageNamed: "whatsapp"))
        rootNode.addChild(whatsapp)
        
        shareother = SKShapeNode(circleOfRadius: radius)
        shareother.fillColor = Colors.SharingGray
        shareother.strokeColor = Colors.SharingGray
        shareother.antialiased = true
        shareother.lineWidth = 1
        shareother.zPosition = 1
        shareother.position = CGPoint(x: whatsapp.position.x + (2 * radius) - offset, y: -(self.size.height / 4))
        shareother.addChild(SKSpriteNode(imageNamed: "sharing"))
        rootNode.addChild(shareother)
        
        var tomenuLabel = SKLabelNode(text: "BACK TO MENU")
        tomenuLabel.fontName = "Avenir"
        tomenuLabel.fontColor = Colors.FontColor
        tomenuLabel.fontSize = self.size.height / 32
        tomenu = SKShapeNode(rect: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: tomenuLabel.frame.height * 4))
        tomenu.lineWidth = 0
        tomenu.fillColor = UIColor.clearColor()
        tomenu.strokeColor = UIColor.clearColor()
        tomenuLabel.position = CGPoint(x: 0, y: -(self.size.height / 2) + (tomenuLabel.frame.height * 1.5))
        tomenu.addChild(tomenuLabel)
        rootNode.addChild(tomenu)
    }
    
    override func didMoveToView(view: SKView) {
        var lastscore = StatsHandler.getLastscore(Globals.currentGameType)
        var highscore = StatsHandler.getHighscore(Globals.currentGameType)
        
        ttpLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.fadeAlphaTo(0.0, duration: 0.2),
            SKAction.fadeAlphaTo(1.0, duration: 0.2),
            SKAction.waitForDuration(1.5)
        ])))
        
        hscoreBadge.removeFromParent()
        scoreLabel.text = "Score \(lastscore)"
        hscoreLabel.text = "HIGHSCORE \(highscore)"
        
        if (highscore != 0 && lastscore == highscore) {
            hscoreLabel.text = "NEW HIGHSCORE \(highscore)"
            hscoreBadge.position = CGPoint(x: hscoreLabel.position.x - hscoreLabel.frame.width / 2 - (hscoreBadge.frame.width * 1.5), y: hscoreLabel.frame.height / 2)
            hscoreLabel.position = CGPoint(x: hscoreLabel.position.x + (hscoreBadge.frame.width / 2), y: hscoreLabel.position.y)
            hscoreLabel.addChild(hscoreBadge)
        }
        
        self.runAction(SKAction.fadeInWithDuration(0.15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            
            if (tomenu.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            } else if (twitter.containsPoint(location)) {
                self.sceneDelegate!.shareOnTwitter()
            } else if (facebook.containsPoint(location)) {
                self.sceneDelegate!.shareOnFacebook()
            } else if (whatsapp.containsPoint(location)) {
                self.sceneDelegate!.shareOnWhatsApp()
            } else if (shareother.containsPoint(location)) {
                self.sceneDelegate!.shareOnOther()
            } else {
                self.runAction(SKAction.fadeOutWithDuration(0.15), completion: { ()
                    self.sceneDelegate!.startGame()
                })
            }
        }
    }
}