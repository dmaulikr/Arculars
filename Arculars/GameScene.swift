//
//  GameScene.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate, GameTimerDelegate, BallCountdownDelegate {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private let circlePosition : CGPoint!
    private let ballPosition : CGPoint!
    private let scorePosition : CGPoint!
    
    var gameMode : GameMode!
    
    // Node and all it's descendants while playing
    private var rootNode = SKNode()
    private var circles = [Circle]()
    private var activeBalls = [Ball]()
    private var hitSounds = [SKAction]()
    private var nextBall : Ball!
    private var ballRadius : CGFloat!
    private var score : Score!
    private var isGameOver = false
    private var multiplicator = 1
    
    private var timer : GameTimer!
    
    private var countdown : BallCountdown!
    private var countdownExpired = false
    
    private var btnStop : SKShapeNode!
    
    // Variables for Stats
    private var stats_starttime : NSDate!
    private var stats_hits = 0
    private var stats_moves = 0
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Init positions
        var offset : CGFloat = size.height / 12
        scorePosition = CGPoint(x: 0, y: (size.height / 2) - offset)
        circlePosition = CGPoint(x: 0, y: (size.height / 4) - offset)
        ballPosition = CGPoint(x: 0, y: -(size.height / 2) + (2 * offset))
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.Background
        
        // Add Root Node
        addChild(rootNode)
        
        // Setup Scene Physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, 0)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-(size.width / 2), -(size.height / 2), size.width, size.height))
        physicsBody?.categoryBitMask = PhysicsCategory.border.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.ball.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.dynamic = true
        
        initScene()
    }

    override func didMoveToView(view: SKView) {
        for circle in circles {
            circle.fadeIn()
        }
        reset()
    }
    
    deinit {
        #if DEBUG
            println("GameScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        ballRadius = size.height / 64
        
        var stopLabel = SKLabelNode(text: "STOP")
        stopLabel.fontSize = size.height / 28
        stopLabel.fontName = Fonts.FontNameBold
        stopLabel.fontColor = UIColor.grayColor()
        stopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        stopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnStop = SKShapeNode(rectOfSize: CGSize(width: size.width, height: size.height / 12))
        btnStop.addChild(stopLabel)
        btnStop.position = CGPoint(x: 0, y: -(size.height / 2) + (btnStop.frame.height / 2))
        btnStop.lineWidth = 0
        rootNode.addChild(btnStop)
        
        score = Score(position: scorePosition)
        rootNode.addChild(score)
        
        hitSounds.append(SKAction.playSoundFileNamed("hit1.wav", waitForCompletion: false))
        hitSounds.append(SKAction.playSoundFileNamed("hit2.wav", waitForCompletion: false))
        
        addCircle(Colors.AppColorOne, clockwise: false, points: 4)
        addCircle(Colors.AppColorTwo, clockwise: true, points: 3)
        addCircle(Colors.AppColorThree, clockwise: false, points: 2)
        addCircle(Colors.AppColorFour, clockwise: true, points: 1)
    }
    
    private func addCircle(color: UIColor, clockwise: Bool, points: Int) {
        var radius : CGFloat!
        var thickness : CGFloat!
        
        if circles.count == 0 {
            radius = size.height / 16
            thickness = size.height / 32
        }
        else {
            var lastradius = circles.last!.radius
            var lastthickness = circles.last!.thickness
            
            radius = lastradius + lastthickness
            thickness = lastthickness
        }
        var c = Circle(color: color, position: circlePosition, radius: radius, thickness: thickness, clockwise: clockwise, pointsPerHit: points)
        circles.append(c)
        rootNode.addChild(c)
    }
    
    private func reset() {
        countdownExpired = false
        
        score?.reset()
        timer?.removeFromParent()
        countdown?.removeFromParent()
        
        if gameMode == GameMode.Limited {
            multiplicator = 1
            initTimer()
            timer?.start()
        } else if gameMode == GameMode.Endless {
            multiplicator = SettingsHandler.getDifficulty().rawValue
            initCountdown()
            countdown?.start()
        }
        
        stats_hits = 0
        stats_moves = 0
        stats_starttime = NSDate()
        
        addBall()
        setCircleSpeed()
        
        isGameOver = false
    }
    
    private func setCircleSpeed() {
        var speed1 : NSTimeInterval!
        var speed2 : NSTimeInterval!
        var speed3 : NSTimeInterval!
        var speed4 : NSTimeInterval!
        
        switch SettingsHandler.getDifficulty() {
        case .Easy:
            circles[0].setSpeed(3.52)
            circles[1].setSpeed(3.86)
            circles[2].setSpeed(2.2)
            circles[3].setSpeed(1.65)
            break
        case .Normal:
            circles[0].setSpeed(3.2)
            circles[1].setSpeed(2.6)
            circles[2].setSpeed(2.0)
            circles[3].setSpeed(1.5)
            break
        case .Hard:
            circles[0].setSpeed(2.88)
            circles[1].setSpeed(2.34)
            circles[2].setSpeed(1.8)
            circles[3].setSpeed(1.35)
            break
        }
        
    }
    
    private func initTimer() {
        timer = GameTimer(position: CGPoint(x: frame.midX, y: scorePosition.y - score.frame.height), seconds: 60)
        timer.delegate = self
        rootNode.addChild(timer)
    }
    
    private func initCountdown() {
        var countdownTime : Int
        switch SettingsHandler.getDifficulty() {
        case .Easy:
            countdownTime = 12
            break
        case .Normal:
            countdownTime = 8
            break
        case .Hard:
            countdownTime = 4
            break
        }
        countdown = BallCountdown(rect: CGRect(x: frame.midX, y: scorePosition.y - (score.frame.height * 1.5), width: frame.width / 6, height: frame.height / 128), seconds: countdownTime)
        countdown.delegate = self
        rootNode.addChild(countdown)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            if (btnStop.containsPoint(location)) {
                gameover()
            } else {
                if !isGameOver && !countdownExpired {
                    stats_moves++
                    shootBall()
                    addBall()
                }
            }
        }
    }
    
    // MARK: - GAME FUNCTIONS
    private func addBall() {
        nextBall = Ball(color: Colors.getRandomBallColor(), position: ballPosition, radius: ballRadius)
        rootNode.addChild(nextBall.fadeIn())
    }
    
    private func shootBall() {
        activeBalls.insert(nextBall, atIndex: 0)
        nextBall.shoot(frame.height)
    }
    
    // MARK: - COLLISION DETECTION
    func didBeginContact(contact: SKPhysicsContact) {
        if isGameOver { return }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
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
        activeBalls.removeLast()
        // set the physicscategory to none to prevent additional contacts
        ball.physicsBody!.categoryBitMask = PhysicsCategory.none.rawValue
        ball.removeFromParent()
        
        if (ball.nodeColor == circle.nodeColor) {
            var points = circle.pointsPerHit * multiplicator
            runSound()
            stats_hits++
            score.increaseByWithColor(points, color: ball.nodeColor)
            
            countdownExpired = false
            countdown?.reset()
        } else {
            if gameMode == GameMode.Limited {
                var points = circle.pointsPerHit * multiplicator
                score.increaseByWithColor(-points, color: UIColor.redColor())
            } else {
                gameover()
            }
        }
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        activeBalls.removeLast()
        ball.runAction(SKAction.removeFromParent())
    }
    
    // MARK: - GAMEOVER FUNCTIONS
    private func gameover() {
        isGameOver = true
        runVibration()
        
        nextBall?.removeFromParent()
        for ball in activeBalls {
            ball.removeFromParent()
        }
        
        timer?.stop()
        countdown?.stop()
        
        StatsHandler.updatePlayedTimeBy(Int(NSDate().timeIntervalSinceDate(stats_starttime)))
        StatsHandler.updateFiredBallsBy(stats_moves)
        StatsHandler.incrementFails()
        StatsHandler.updateHitsBy(stats_hits)
        
        var endScore = score.getScore()
        StatsHandler.updateLastscore(endScore, gameMode: gameMode)
        StatsHandler.updateHighscore(endScore, gameMode: gameMode)
        StatsHandler.updateOverallPointsBy(endScore)
        
        reportLeaderboardScore(endScore)
        
        sceneDelegate!.showGameover(gameMode)
    }
    
    // MARK: - GAMECENTER INTEGRATION
    private func reportLeaderboardScore(newScore: Int) {
        if (newScore > 0) {
            switch gameMode.rawValue {
            case GameMode.Endless.rawValue:
                GCHandler.reportScoreLeaderboard(leaderboardIdentifier: "arculars_endless", score: newScore, completion: nil)
                break
            case GameMode.Limited.rawValue:
                GCHandler.reportScoreLeaderboard(leaderboardIdentifier: "arculars_limited", score: newScore, completion: nil)
                break
            default:
                return
            }
        }
    }
    
    // MARK: - GAMETIMER DELEGATE
    func gameTimerFinished() {
        gameover()
    }
    
    // MARK: - BALLCOUNTDOWN DELEGATE
    func ballExpired() {
        countdownExpired = true
        if activeBalls.count == 0 {
            gameover()
        }
    }
    
    // MARK: - USER FEEDBACK FUNCTIONS
    private func runSound() {
        var state = SettingsHandler.getSoundSetting()
        if state {
            var sound = hitSounds[Int(arc4random_uniform(UInt32(hitSounds.count)))]
            runAction(sound)
        }
    }
    
    private func runVibration() {
        var state = SettingsHandler.getVibrationSetting()
        if state {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
