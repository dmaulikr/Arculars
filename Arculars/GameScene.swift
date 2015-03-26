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
import AudioToolbox

enum GameType {
    case Endless
    case Timed
}

class GameScene: SKScene, SKPhysicsContactDelegate, CountdownDelegate {
    
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
    private var countdown : Countdown!
    private var isGameOver = false
    
    // Preload sound into memory fixes the small delay when playing the mp3 the first time
    private var soundAction = SKAction.playSoundFileNamed("bip.mp3", waitForCompletion: false)
    
    // Variables for Stats
    private var stats_starttime : NSDate!
    private var stats_hits = 0
    private var stats_moves = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Init positions
        var offset : CGFloat = self.size.height / 8
        scorePosition = CGPoint(x: 0, y: (self.size.height / 2) - offset)
        circlePosition = CGPoint(x: 0, y: (self.size.height / 4) - offset)
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
        
        countdown = Countdown(position: CGPoint(x: scorePosition.x, y: scorePosition.y - score.frame.height), seconds: 60)
        countdown.countdownDelegate = self
        rootNode.addChild(countdown)
        
        addCircle(Colors.AppColorOne, clockwise: false, speed: 3.2, points: 4)
        addCircle(Colors.AppColorTwo, clockwise: true, speed: 2.6, points: 3)
        addCircle(Colors.AppColorThree, clockwise: false, speed: 2.0, points: 2)
        addCircle(Colors.AppColorFour, clockwise: true, speed: 1.5, points: 1)
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
            #if DEBUG
                println("*** SHOOT ***")
            #endif
            stats_moves++
            shootBall()
            addBall()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        #if DEBUG
            println("did begin contact")
        #endif
        if isGameOver { return }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        #if DEBUG
            println("contact mask \(contactMask)")
        #endif
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
        #if DEBUG
            println("ball did collide with circle")
        #endif
        // because of the complex shape of the arc's physicsbody
        // there are multiple contacts when a ball collides with an arc
        // so this is a fix to avoid multiple points being counted to the score
        ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
        //  ball.hidden = true
        ball.runAction(SKAction.removeFromParent())
        
        if (ball.nodeColor == circle.nodeColor) {
            #if DEBUG
                println("=== score +\(circle.pointsPerHit)")
            #endif
            runSound()
            stats_hits++
            self.score.increaseByWithColor(circle.pointsPerHit, color: ball.nodeColor)
        } else {
            #if DEBUG
                println("=== ball and circle color don't match -> game is over")
            #endif
            runVibration()
            gameover()
        }
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        #if DEBUG
            println("ball did collide with border")
        #endif
        ball.runAction(SKAction.removeFromParent())
    }
    
    private func gameover() {
        isGameOver = true
        
        countdown.stop()
        
        // Update Stats
        StatsHandler.updatePlayedTimeBy(Int(NSDate().timeIntervalSinceDate(stats_starttime)))
        StatsHandler.updateFiredBallsBy(stats_moves)
        StatsHandler.incrementFails()
        StatsHandler.updateHitsBy(stats_hits)
        StatsHandler.updateOverallPointsBy(self.score.getScore())
        StatsHandler.updateLastscore(self.score.getScore(), gameType: Globals.currentGameType)
        StatsHandler.updateHighscore(self.score.getScore(), gameType: Globals.currentGameType)
        
        // Add Score to Gamecenter
        addLeaderboardScore(self.score.getScore())
        
        self.sceneDelegate!.showGameoverScene()
    }
    
    private func reset() {
        isGameOver = false
        
        if Globals.currentGameType == GameType.Timed {
            countdown.hidden = false
            countdown.start()
        } else if Globals.currentGameType == GameType.Endless {
            countdown.hidden = true
        }
        
        score.reset()
        countdown.reset()
        
        stats_hits = 0
        stats_moves = 0
        stats_starttime = NSDate()
        
        nextBall?.removeFromParent()
        addBall()
    }
    
    func addLeaderboardScore(score: Int) {
        var newGCScore : GKScore!
        switch Globals.currentGameType {
            case .Endless:
                newGCScore = GKScore(leaderboardIdentifier: "io.rmnblm.arculars.endless")
                break
            case .Timed:
                newGCScore = GKScore(leaderboardIdentifier: "io.rmnblm.arculars.timed")
                break
            default:
                return
        }
        newGCScore.value = Int64(score)
        GKScore.reportScores([newGCScore], withCompletionHandler: {(error) -> Void in
            if error != nil {
                #if DEBUG
                    println("Score not submitted")
                #endif
            } else {
                #if DEBUG
                    println("Score submitted")
                #endif
            }
        })
    }
    
    func countdownFinished() {
        #if DEBUG
            println("timer finished")
        #endif
        gameover()
    }
    
    private func runSound() {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_SOUND)
        if state {
            self.runAction(soundAction)
        }
    }
    
    private func runVibration() {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_VIBRATION)
        if state {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
