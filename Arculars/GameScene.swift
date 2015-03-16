//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let ballSize = CGFloat(12.0)
    let ballSpeed = NSTimeInterval(1.8)
    var circlePosition : CGPoint!
    
    var isGameOver = false
    private var gameoverNode : SKSpriteNode!
    private var gameoverScoreLabel : SKLabelNode!
    
    private var circles = [Circle]()
    private var ballQueue = [Ball]()
    private var screenNode : SKSpriteNode!
    private var score : Score!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        screenNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        addChild(screenNode)
        
        gameoverNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        gameoverNode.alpha = 0.0
        addChild(gameoverNode)
        
        score = Score().addTo(screenNode)
        
        initCircles()
        initGameOver()
        addBallToQueue()
        
        // Setup Physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(self.size.width / 2), -(self.size.height / 2), self.size.width, self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
    }
    
    func initCircles() {
        circlePosition = CGPoint(x: 0, y: self.size.height / 4)
        
        circles.append(
            Circle(position: circlePosition, arcColor: Colors.Blue, circleColor: Colors.LightBlue, radius: 100.0, thickness: 40.0, clockwise: true, secondsPerRound: 1.2))
        circles.append(
            Circle(position: circlePosition, arcColor: Colors.Orange, circleColor: Colors.LightOrange, radius: 50.0, thickness: 25.0, clockwise: false, secondsPerRound: 1.8))
        circles.append(
            Circle(position: circlePosition, arcColor: Colors.Red, circleColor: Colors.LightRed, radius: 20.0, thickness: 12.0, clockwise: true, secondsPerRound: 2.4))
        
        for circle in circles {
            circle.addTo(screenNode).startAnimation()
        }
    }
    
    func initGameOver() {
        
        var content = SKNode()
        var image = SKSpriteNode(imageNamed: "highscore")
        image.position = CGPoint(x: 0, y: 30)
        content.addChild(image)
        
        gameoverScoreLabel = SKLabelNode()
        gameoverScoreLabel.position = CGPoint(x: 0, y: -30)
        content.addChild(gameoverScoreLabel)
        
        var scoreContent = Button(name: "scoreContent", position: CGPoint(x: 0, y: 80), color: Colors.Red, content: content, radius: 100)
        scoreContent.addTo(gameoverNode)
        
        var replayButton = Button(name: "replaybutton", position: CGPoint(x: 0, y: -80), color: Colors.Red, content: SKSpriteNode(imageNamed: "replay"), radius: 30)
        replayButton.addTo(gameoverNode)
    }
    
    private func shootBall() {
        var ball = ballQueue[0]
        ballQueue.removeAtIndex(0)
        ball.shootTo(CGPointMake(0, size.height), speed: ballSpeed)
    }
    
    private func addBallToQueue() {
        var ball = Ball(color: Colors.randomBallColor(), radius: ballSize)
        ballQueue.append(ball)
        ball.addTo(screenNode)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isGameOver {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(gameoverNode)
                var nodeAtLocation = self.nodeAtPoint(location)
                
                if (nodeAtLocation.name == "replaybutton") {
                    replay()
                }
            }
        } else {
            shootBall()
            addBallToQueue()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
            case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
                var ballNode : SKShapeNode!
                var circleNode : SKShapeNode!
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as? SKShapeNode
                    circleNode = contact.bodyB.node as? SKShapeNode
                } else{
                    ballNode = contact.bodyB.node as? SKShapeNode
                    circleNode = contact.bodyA.node as? SKShapeNode
                }
                if ballNode != nil && circleNode != nil {
                    ballDidCollideWithArc(ballNode, circle: circleNode)
                }
                break
            case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
                var ballNode : SKShapeNode!
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                    ballNode = contact.bodyA.node as SKShapeNode
                } else{
                    ballNode = contact.bodyB.node as SKShapeNode
                }
                
                ballNode.removeFromParent()
                break
            default:
                return
        }
    }
    
    private func ballDidCollideWithArc(ball: SKShapeNode, circle: SKShapeNode) {
        if (ball.fillColor == circle.strokeColor) {
            score.increase()
        } else {
            gameover()
        }
        
        ball.removeFromParent();
    }
    
    func gameover() {
        isGameOver = true
        gameoverScoreLabel.text = "Score \(self.score.getScore())"
        
        screenNode.alpha = 0.1
        gameoverNode.alpha = 1.0
    }
    
    func replay() {
        screenNode.alpha = 1.0
        gameoverNode.alpha = 0.0
        score.reset()
        isGameOver = false
    }
}
