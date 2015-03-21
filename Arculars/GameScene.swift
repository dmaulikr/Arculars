//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let circlePosition : CGPoint!
    private let ballPosition : CGPoint!
    private let scorePosition : CGPoint!
    
    var sceneDelegate : SceneDelegate?
    
    // Node and all it's descendants while playing
    private var rootNode = SKNode()
    private var nextBall : Ball!
    
    private var innerCircle : Circle!
    private var innerCircleRadius : CGFloat!
    private var innerCircleThickness : CGFloat!
    
    private var middleCircle : Circle!
    private var middleCircleRadius : CGFloat!
    private var middleCircleThickness : CGFloat!
    
    private var outerCircle : Circle!
    private var outerCircleRadius : CGFloat!
    private var outerCircleThickness : CGFloat!
    
    private var ballRadius : CGFloat!
    private var ballSpeed : NSTimeInterval!
    
    private var score : Score!
    
    // Node and all it's descendants when game over
    private var gameoverNode = SKNode()
    private var isGameOver = false
    
    private var menuButton : Button!
    private var replayButton : Button!
    private var statsButton : Button!
    private var facebookButton : Button!
    private var twitterButton : Button!
    
    private var gameoverScoreLabel : SKLabelNode!
    private var gameoverHighscoreLabel : SKLabelNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Init positions
        var offset : CGFloat = self.size.height / 8
        scorePosition = CGPoint(x: 0, y: (self.size.height / 2) - offset)
        circlePosition = CGPoint(x: 0, y: self.size.height / 4 - offset)
        ballPosition = CGPoint(x: 0, y: -(size.height / 2) + (offset / 2))
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Setup Scene Physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(self.size.width / 2), -(self.size.height / 2), self.size.width, self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
        
        initializeStartGameLayer()
        initializeGameOverLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        outerCircle.fadeIn()
        middleCircle.fadeIn()
        innerCircle.fadeIn()
        
        reset()
    }
    
    private func initializeStartGameLayer() {
        self.addChild(rootNode)
        
        // Calculate radius and thickness of all circles
        outerCircleRadius = (self.size.height / 4) - (self.size.height / 10)
        outerCircleThickness = (self.size.height / 16)
        
        middleCircleThickness = outerCircleThickness / 2
        middleCircleRadius = outerCircleRadius - (outerCircleThickness / 2) - (middleCircleThickness / 2)
        
        innerCircleThickness = middleCircleThickness
        innerCircleRadius = middleCircleRadius - (middleCircleThickness / 2) - (innerCircleThickness / 2)
        
        ballRadius = innerCircleThickness / 2.0
        ballSpeed = 9.0
        
        score = Score(position: scorePosition)
        rootNode.addChild(score)
        
        outerCircle = Circle(circleColor: Colors.LightBlue, arcColor: Colors.Blue, position: circlePosition, radius: outerCircleRadius, thickness: outerCircleThickness, clockwise: true, secondsPerRound: 1.2, pointsPerHit: 1)
        rootNode.addChild(outerCircle)
        middleCircle = Circle(circleColor: Colors.LightOrange, arcColor: Colors.Orange, position: circlePosition, radius: middleCircleRadius, thickness: middleCircleThickness, clockwise: false, secondsPerRound: 1.8, pointsPerHit: 2)
        rootNode.addChild(middleCircle)
        innerCircle = Circle(circleColor: Colors.LightRed, arcColor: Colors.Red, position: circlePosition, radius: innerCircleRadius, thickness: innerCircleThickness, clockwise: true, secondsPerRound: 2.4, pointsPerHit: 3)
        rootNode.addChild(innerCircle)
    }
    
    private func initializeGameOverLayer() {
        self.addChild(gameoverNode)
        
        gameoverNode.zPosition = 1
        gameoverNode.hidden = true
        
        var content = SKNode()
        var image = SKSpriteNode(imageNamed: "highscore")
        image.position = CGPoint(x: 0, y: 30)
        content.addChild(image)
        
        gameoverScoreLabel = SKLabelNode()
        gameoverScoreLabel.fontName = "Helvetica Neue UltraLight"
        gameoverScoreLabel.fontSize = 32
        gameoverScoreLabel.position = CGPoint(x: 0, y: -30)
        content.addChild(gameoverScoreLabel)
        
        gameoverHighscoreLabel = SKLabelNode()
        gameoverHighscoreLabel.fontName = "Helvetica Neue UltraLight"
        gameoverHighscoreLabel.fontSize = 18
        gameoverHighscoreLabel.position = CGPoint(x: 0, y: -60)
        content.addChild(gameoverHighscoreLabel)
        
        var scoreContent = Button(position: CGPoint(x: 0, y: 80), color: Colors.LightRed, content: content, radius: 100)
        gameoverNode.addChild(scoreContent.fadeIn())
        
        menuButton = Button(position: CGPoint(x: -90, y: -80), color: Colors.LightRed, content: SKSpriteNode(imageNamed: "home"), radius: 30)
        gameoverNode.addChild(menuButton)
        
        replayButton = Button(position: CGPoint(x: 0, y: -80), color: Colors.LightRed, content: SKSpriteNode(imageNamed: "play"), radius: 30)
        gameoverNode.addChild(replayButton)
        
        statsButton = Button(position: CGPoint(x: 90, y: -80), color: Colors.LightRed, content: SKSpriteNode(imageNamed: "stats"), radius: 30)
        gameoverNode.addChild(statsButton)
        
        facebookButton = Button(position: CGPoint(x: 40, y: -150), color: Colors.FacebookBlue, content: SKSpriteNode(imageNamed: "facebook"), radius: 30)
        gameoverNode.addChild(facebookButton)
        
        twitterButton = Button(position: CGPoint(x: -40, y: -150), color: Colors.TwitterBlue, content: SKSpriteNode(imageNamed: "twitter"), radius: 30)
        gameoverNode.addChild(twitterButton)
    }
    
    private func addBall() {
        nextBall = Ball(color: Colors.randomBallColor(), position: ballPosition, radius: ballRadius, speed: ballSpeed)
        rootNode.addChild(nextBall.fadeIn())
    }
    
    private func shootBall() {
        nextBall.shoot()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isGameOver {
            let touch = touches.anyObject() as UITouch
            let location = touch.locationInNode(gameoverNode)
            
            if (menuButton.containsPoint(location)) {
                sceneDelegate?.showMenuScene()
            } else if (replayButton.containsPoint(location)) {
                reset()
            } else if (statsButton.containsPoint(location)) {
                sceneDelegate?.showGameCenter()
            }
        } else {
            println("*** SHOOT ***")
            shootBall()
            addBall()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("did begin contact")
        
        if isGameOver { return }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        println("contact mask \(contactMask)")
        switch (contactMask) {
        case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
            var ball : Ball
            var circle : Circle
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as Ball
                circle = contact.bodyB.node?.parent as Circle // parent because the arc's parent
            } else {
                ball = contact.bodyB.node as Ball
                circle = contact.bodyA.node?.parent as Circle // parent because the arc's parent
            }
            ballDidCollideWithCircle(ball, circle: circle)
            
            break
        case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as Ball
            } else{
                ball = contact.bodyB.node as Ball
            }
            
            ballDidCollideWithBorder(ball)
            break
        default:
            return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        println("did end contact")
    }
    
    private func ballDidCollideWithCircle(ball: Ball, circle: Circle) {
        println("ball did collide with circle")
        
        // because of the complex shape of the arc's physicsbody
        // there are multiple contacts when a ball collides with an arc
        // so this is a fix to avoid multiple points being counted to the score
        ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
        //  ball.hidden = true
        ball.runAction(SKAction.removeFromParent())
        
        if (ball.nodeColor == circle.nodeColor) {
            println("=== score +\(circle.pointsPerHit)")
            self.score.increaseByWithColor(circle.pointsPerHit, color: ball.nodeColor)
        } else {
            println("=== ball and circle color don't match -> game is over")
            gameOver()
        }
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        println("ball did collide with border")
        ball.runAction(SKAction.removeFromParent())
    }
    
    private func gameOver() {
        // First, set the current gamescene state to GameOver
        isGameOver = true
        rootNode.alpha = 0.1
        gameoverNode.hidden = false
        
        // Then, save to local storage and to Game Center (if logged in)
        addLocalScore(self.score.getScore())
        addLeaderboardScore(self.score.getScore())
        
        // Now show the score to the user
        gameoverScoreLabel.text = "Score \(self.score.getScore())"
        gameoverHighscoreLabel.text = "Highscore \(self.getLocalScore())"
        
        // Fade in all buttons
        menuButton.fadeIn()
        replayButton.fadeIn()
        statsButton.fadeIn()
        facebookButton.fadeIn()
        twitterButton.fadeIn()
    }
    
    private func reset() {
        isGameOver = false
        rootNode.alpha = 1.0
        
        gameoverNode.hidden = true
        score.reset()
        
        nextBall?.removeFromParent()
        addBall()
    }
    
    private func getLocalScore() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    }
    
    private func addLocalScore(score: Int) -> Bool {
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        if score > highscore {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
    
    func addLeaderboardScore(score: Int) -> Bool {
        var success = false
        var newGCScore = GKScore(leaderboardIdentifier: "io.rmnblm.arculars.endless")
        newGCScore.value = Int64(score)
        GKScore.reportScores([newGCScore], withCompletionHandler: {(error) -> Void in
            if error != nil {
                println("Score not submitted")
                // Continue
                // self.gameOver = false
                success = false
            } else {
                // Notify the delegate to show the game center leaderboard
                // self.sceneDelegate!.showGameCenter()
                success = true
            }
        })
        return success
    }
}
