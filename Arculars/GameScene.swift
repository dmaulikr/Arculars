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
    
    private var circles = [Circle]()
    
    private var nextBall : Ball!
    private var ballRadius : CGFloat!
    private var ballSpeed : NSTimeInterval!
    private var score : Score!
    
    private var isGameOver = false
    
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
        
        // Add Root Node
        self.addChild(rootNode)
        
        // Setup Scene Physics
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(self.size.width / 2), -(self.size.height / 2), self.size.width, self.size.height))
        self.physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
        
        initScene()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        for circle in circles {
            circle.fadeIn()
        }
        
        reset()
    }
    
    private func initScene() {
        ballRadius = self.size.height / 64
        ballSpeed = 9.0
        
        score = Score(position: scorePosition)
        rootNode.addChild(score)
        
        addCircle(Colors.ArcularsColor1, clockwise: false, speed: 3.2, points: 4)
        addCircle(Colors.ArcularsColor2, clockwise: true, speed: 2.6, points: 3)
        addCircle(Colors.ArcularsColor3, clockwise: false, speed: 2.0, points: 2)
        addCircle(Colors.ArcularsColor4, clockwise: true, speed: 1.5, points: 1)
    }
    
    private func addCircle(color: UIColor, clockwise: Bool, speed: NSTimeInterval, points: Int) {
        var radius : CGFloat!
        var thickness : CGFloat!
        
        if circles.count == 0 {
            radius = self.size.height / 16
            thickness = self.size.height / 32
        }
        else {
            var lastradius = circles.last!.radius
            var lastthickness = circles.last!.thickness
            
            radius = lastradius + lastthickness
            thickness = lastthickness
        }
        var c = Circle(color: color, position: circlePosition, radius: radius, thickness: thickness, clockwise: clockwise, secondsPerRound: speed, pointsPerHit: points)
        circles.append(c)
        rootNode.addChild(c)
    }
    
    private func addBall() {
        nextBall = Ball(color: Colors.getRandomBallColor(), position: ballPosition, radius: ballRadius, speed: ballSpeed)
        rootNode.addChild(nextBall.fadeIn())
    }
    
    private func shootBall() {
        nextBall.shoot()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !isGameOver {
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
            gameover()
        }
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        println("ball did collide with border")
        ball.runAction(SKAction.removeFromParent())
    }
    
    private func gameover() {
        isGameOver = true
        
        addLeaderboardScore(self.score.getScore())
        addLocalScore(self.score.getScore())
        
        self.sceneDelegate!.showGameoverScene()
    }
    
    private func reset() {
        isGameOver = false
        score.reset()
        nextBall?.removeFromParent()
        addBall()
    }
    
    private func addLocalScore(score: Int) -> Bool {
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "lastscore")
        NSUserDefaults.standardUserDefaults().synchronize()
        
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
                success = false
            } else {
                println("Score submitted")
                success = true
            }
        })
        return success
    }
}
