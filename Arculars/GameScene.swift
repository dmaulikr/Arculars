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
    
    let ballSize = CGFloat(9.0)
    let ballSpeed = NSTimeInterval(1.8)
    var circlePosition : CGPoint!
    
    var isGameOver = false
    
    private var screenNode : SKSpriteNode!
    private var overlayNode : SKSpriteNode!
    
    private var circles = [Circle]()
    private var ballQueue = [Ball]()
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
        screenNode.zPosition = 10
        addChild(screenNode)
        
        initScore()
        initCircles()
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
    
    func initScore() {
        score = Score(position: CGPoint(x: 0, y: -(self.size.height / 2) + 32))
        screenNode.addChild(score)
    }
    
    func initCircles() {
        circlePosition = CGPoint(x: 0, y: self.size.height / 4)
        
        circles.append(Circle(circleColor: Colors.LightBlue, arcColor: Colors.Blue, position: circlePosition, radius: 100.0, thickness: 40.0, clockwise: true, secondsPerRound: 1.2, pointsPerHit: 1))
        circles.append(Circle(circleColor: Colors.LightOrange, arcColor: Colors.Orange, position: circlePosition, radius: 50, thickness: 25.0, clockwise: false, secondsPerRound: 1.8, pointsPerHit: 2))
        circles.append(Circle(circleColor: Colors.LightRed, arcColor: Colors.Red, position: circlePosition, radius: 20.0, thickness: 18.0, clockwise: true, secondsPerRound: 2.4, pointsPerHit: 3))
        
        for circle in circles {
            screenNode.addChild(circle)
        }
    }
    
    
    private func shootBall() {
        var ball = ballQueue[0]
        ballQueue.removeAtIndex(0)
        ball.shootTo(CGPointMake(0, size.height), speed: ballSpeed)
    }
    
    private func addBallToQueue() {
        var ball = Ball(color: Colors.randomBallColor(), radius: ballSize, position: CGPoint(x: 0, y: -(size.height / 4)))
        ballQueue.append(ball)
        screenNode.addChild(ball)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if isGameOver {
            for touch: AnyObject in touches {
                let location = touch.locationInNode(overlayNode)
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
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        if isGameOver { return }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch (contactMask) {
        case PhysicsCategory.ball.rawValue | PhysicsCategory.arc.rawValue:
            var ball : Ball!
            var circle : Circle!
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node? as? Ball
                circle = contact.bodyB.node?.parent as? Circle // parent because the arc's parent
            } else {
                ball = contact.bodyB.node? as? Ball
                circle = contact.bodyA.node?.parent as? Circle // parent because the arc's parent
            }
            if ball != nil && circle != nil {
                ballDidCollideWithArc(ball, circle: circle)
            }
            break
        case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball!
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as Ball
            } else{
                ball = contact.bodyB.node as Ball
            }
            
            if ball != nil {
                ballDidCollideWithBorder(ball)
            }
            break
        default:
            return
        }
    }
    
    private func ballDidCollideWithArc(ball: Ball, circle: Circle) {
        ball.removeAllActions()
        
        if (ball.nodeColor == circle.nodeColor) {
            
            for circle in circles {
                // circle.modifySpeedBy(1.05)
            }
            
            self.score.increaseBy(UInt32(circle.pointsPerHit))
            
        } else {
            gameover()
        }
        
        ball.removeFromParent()
        
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        ball.removeFromParent()
    }
    
    func gameover() {
        isGameOver = true
        screenNode.alpha = 0.1
        
        overlayNode = SKSpriteNode(color: UIColor.clearColor(), size: self.size)
        overlayNode.zPosition = 100
        self.addChild(overlayNode)
        
        var content = SKNode()
        var image = SKSpriteNode(imageNamed: "highscore")
        image.position = CGPoint(x: 0, y: 30)
        content.addChild(image)
        
        var label = SKLabelNode()
        label.position = CGPoint(x: 0, y: -30)
        label.text = "Score \(self.score.getScore())"
        content.addChild(label)
        
        var scoreContent = Button(name: "scoreContent", position: CGPoint(x: 0, y: 80), color: Colors.Red, content: content, radius: 100)
        overlayNode.addChild(scoreContent.fadeIn())
        
        var replayButton = Button(name: "replaybutton", position: CGPoint(x: 0, y: -80), color: Colors.Red, content: SKSpriteNode(imageNamed: "replay"), radius: 30)
        overlayNode.addChild(replayButton.fadeIn())
    }
    
    func replay() {
        screenNode.alpha = 1.0
        score.reset()
        overlayNode?.removeFromParent()
        isGameOver = false
    }
}
