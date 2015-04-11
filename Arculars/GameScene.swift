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

class GameScene: SKScene, SKPhysicsContactDelegate, TimerBarDelegate, HealthBarDelegate, PowerupDelegate {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private let circlePosition : CGPoint!
    private let ballPosition : CGPoint!
    private let scorePosition : CGPoint!
    
    var gameMode : GameMode!
    
    private var powerupHandler : PowerupHandler!
    
    // Node and all it's descendants while playing
    private var rootNode = SKNode()
    private var circles = [Circle]()
    private var availableColors = [UIColor]()
    private var activeBalls = [Ball]()
    private var hitSounds = [SKAction]()
    private var nextBall : Ball!
    private var ballRadius : CGFloat!
    private var score : Score!
    private var powerupDescription : SKLabelNode!
    private var isGameOver = false
    private var multiplicator = 1
    private var powerupMultiplicator = 1
    
    private var healthBar : HealthBar!
    private var timerBar : TimerBar!
    private var isTimerBarExpired = false
    
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
        // Init positions
        var offset : CGFloat = size.height / 12
        circlePosition = CGPoint(x: 0, y: (size.height / 4) - offset)
        ballPosition = CGPoint(x: 0, y: -(size.height / 2) + (2 * offset))
        scorePosition = CGPoint(x: 0, y: (size.height / 2) - offset)
        
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.BackgroundColor
        
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
        btnStop = SKShapeNode(rectOfSize: CGSize(width: stopLabel.frame.width * 1.5, height: stopLabel.frame.height * 2))
        btnStop.addChild(stopLabel)
        btnStop.position = CGPoint(x: 0, y: -(size.height / 2) + (btnStop.frame.height / 2))
        btnStop.lineWidth = 0
        rootNode.addChild(btnStop)
        
        score = Score(position: scorePosition)
        score.fontSize = size.height / 20
        rootNode.addChild(score)
        
        
        powerupDescription = SKLabelNode()
        powerupDescription.fontColor = Colors.PowerupColor
        powerupDescription.fontName = Fonts.FontNameLight
        powerupDescription.fontSize = size.height / 64
        powerupDescription.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        powerupDescription.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        powerupDescription.position = CGPoint(x: scorePosition.x, y: scorePosition.y - score.frame.height)
        addChild(powerupDescription)
        
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
        var c = Circle(position: circlePosition, radius: radius, thickness: thickness, clockwise: clockwise, pointsPerHit: points)
        circles.append(c)
        rootNode.addChild(c)
    }
    
    private func reset() {
        isTimerBarExpired = false
        
        score?.reset()
        
        healthBar?.removeFromParent()
        timerBar?.removeFromParent()
        
        if gameMode == GameMode.Timed {
            initTimerBar()
            timerBar?.start()
        } else if gameMode == GameMode.Endless {
            initHealthBar()
        }
        
        stats_hits = 0
        stats_moves = 0
        stats_starttime = NSDate()
        
        resetCircleColors()
        resetCircleSpeed()
        resetAvailableColors()
        
        powerupHandler = PowerupHandler(gameMode: gameMode, difficulty: SettingsHandler.getDifficulty())
        
        isGameOver = false
    }
    
    private func resetAvailableColors() {
        availableColors.removeAll()
        for circle in circles {
            availableColors.append(circle.nodeColor)
        }
        
        nextBall?.removeFromParent()
        addBall()
    }
    
    private func resetCircleSpeed() {
        switch SettingsHandler.getDifficulty() {
        case .Easy:
            circles[0].setSpeed(4.0, max: 4.4)
            circles[1].setSpeed(3.2, max: 3.6)
            circles[2].setSpeed(2.4, max: 2.8)
            circles[3].setSpeed(2.0, max: 2.4)
            multiplicator = 1
            break
        case .Normal:
            circles[0].setSpeed(3.0, max: 3.4)
            circles[1].setSpeed(2.4, max: 2.8)
            circles[2].setSpeed(1.8, max: 2.2)
            circles[3].setSpeed(1.6, max: 2.0)
            multiplicator = 2
            break
        case .Hard:
            circles[0].setSpeed(2.4, max: 2.8)
            circles[1].setSpeed(1.8, max: 2.2)
            circles[2].setSpeed(1.4, max: 1.8)
            circles[3].setSpeed(1.2, max: 1.6)
            multiplicator = 4
            break
        }
        
    }
    
    private func resetCircleColors() {
        circles[0].setColor(Colors.AppColorOne)
        circles[1].setColor(Colors.AppColorTwo)
        circles[2].setColor(Colors.AppColorThree)
        circles[3].setColor(Colors.AppColorFour)
    }
    
    private func initTimerBar() {
        var barHeight = size.height / 48
        timerBar = TimerBar(size: CGSize(width: size.width, height: barHeight), color: Colors.AppColorThree, max: 15)
        timerBar.position = CGPoint(x: -size.width / 2, y: (size.height / 2) - (barHeight / 2))
        timerBar.delegate = self
        rootNode.addChild(timerBar)
    }
    
    private func initHealthBar() {
        var barHeight = size.height / 48
        healthBar = HealthBar(size: CGSize(width: size.width, height: barHeight), color: Colors.AppColorThree, max: 3)
        healthBar.position = CGPoint(x: -size.width / 2, y: (size.height / 2) - (barHeight / 2))
        healthBar.delegate = self
        rootNode.addChild(healthBar)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(rootNode)
            if (btnStop.containsPoint(location)) {
                gameover()
            } else {
                if !isGameOver && !isTimerBarExpired {
                    stats_moves++
                    shootBall()
                    addBall()
                }
            }
        }
    }
    
    // MARK: - GAME FUNCTIONS
    private func addBall() {
        nextBall = Ball(color: getRandomBallColor(), position: ballPosition, radius: ballRadius)
        rootNode.addChild(nextBall.fadeIn())
    }
    
    private func shootBall() {
        activeBalls.insert(nextBall, atIndex: 0)
        nextBall.shoot((circlePosition.y - ballPosition.y) * 2)
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
                ball = contact.bodyA.node as! Ball
                circle = contact.bodyB.node?.parent as! Circle // parent because the arc's parent
            } else {
                ball = contact.bodyB.node as! Ball
                circle = contact.bodyA.node?.parent as! Circle // parent because the arc's parent
            }
            ballDidCollideWithCircle(ball, circle: circle)
            
            break
        case PhysicsCategory.border.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            
            ballDidCollideWithBorder(ball)
            break
        case PhysicsCategory.powerup.rawValue | PhysicsCategory.ball.rawValue:
            var ball : Ball
            
            if contact.bodyA.categoryBitMask == PhysicsCategory.ball.rawValue {
                ball = contact.bodyA.node as! Ball
            } else{
                ball = contact.bodyB.node as! Ball
            }
            
            ballDidCollideWithPowerup(ball)
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
        
        stats_hits++
        if (ball.nodeColor == circle.nodeColor) {
            runSound()
            var points = circle.pointsPerHit * multiplicator * powerupMultiplicator
            score.increaseByWithColor(points, color: ball.nodeColor)
            
            if gameMode == GameMode.Timed {
                timerBar?.addTime(Double(circle.pointsPerHit))
            }
        } else {
            runVibration()
            if gameMode == GameMode.Timed {
                timerBar?.addTime(Double(-circle.pointsPerHit))
            } else if gameMode == GameMode.Endless {
                healthBar?.decrement()
            }
        }
        
        checkForPowerup()
    }
    
    private func checkForPowerup() {
        if (powerupHandler.checkForNewPowerup(score.getScore()) && powerupHandler.currentPowerup == nil) {
            var type = powerupHandler.randomPowerupType()
            var powerup = Powerup(radius: ballRadius * 2, type: type)
            powerup.position = circlePosition
            powerup.delegate = self
            powerupHandler.currentPowerup = powerup
            rootNode.addChild(powerup)
            powerup.fadeIn()
        }
    }
    
    private func ballDidCollideWithBorder(ball: Ball) {
        activeBalls.removeLast()
        ball.removeFromParent()
    }
    
    private func ballDidCollideWithPowerup(ball: Ball) {
        activeBalls.removeLast()
        ball.removeFromParent()
        handlePowerup()
    }
    
    // MARK: - GAMEOVER FUNCTIONS
    private func gameover() {
        isGameOver = true
        runVibration()
        
        nextBall?.removeFromParent()
        for ball in activeBalls {
            ball.removeFromParent()
        }
        
        timerBar?.stop()
        
        StatsHandler.updatePlayedTimeBy(Int(NSDate().timeIntervalSinceDate(stats_starttime)))
        StatsHandler.updateFiredBallsBy(stats_moves)
        StatsHandler.incrementPlayedGames()
        StatsHandler.updateHitsBy(stats_hits)
        
        var endScore = score.getScore()
        StatsHandler.updateLastscore(endScore, gameMode: gameMode)
        StatsHandler.updateHighscore(endScore, gameMode: gameMode)
        StatsHandler.updateOverallPointsBy(endScore)
        CreditsHandler.depositCredits(endScore)
        
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
            case GameMode.Timed.rawValue:
                GCHandler.reportScoreLeaderboard(leaderboardIdentifier: "arculars_timed", score: newScore, completion: nil)
                break
            default:
                return
            }
        }
    }
    
    // MARK: - TIMERBAR DELEGATE    
    func timerBarZero() {
        gameover()
    }
    
    // MARK: - HEALTHBAR DELEGATE
    func healthBarZero() {
        gameover()
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
    
    // MARK: - HANDLING POWERUPS
    private func handlePowerup() {
        var type = powerupHandler.currentPowerup.powerupType!
        powerupDescription.text = type.description.uppercaseString
        
        switch type {
        case .None:
            break
        case .DoublePoints:
            powerupMultiplicator = 2
            powerupHandler.currentPowerup.startWith(30)
            break
        case .TriplePoints:
            powerupMultiplicator = 3
            powerupHandler.currentPowerup.startWith(15)
            break
        case .FullLifes:
            healthBar?.reset()
            powerupExpired()
            break
        case .FullTime:
            timerBar?.reset()
            powerupExpired()
            break
        case .Unicolor:
            for circle in circles {
                circle.setColor(Colors.PowerupColor)
            }
            nextBall?.setColor(Colors.PowerupColor)
            availableColors.removeAll()
            availableColors.append(Colors.PowerupColor)
            powerupHandler.currentPowerup.startWith(5)
            break
        case .ExtraPoints10:
            score.increaseByWithColor(10, color: Colors.PowerupColor)
            checkForPowerup()
            powerupExpired()
            break
        case .ExtraPoints30:
            score.increaseByWithColor(30, color: Colors.PowerupColor)
            checkForPowerup()
            powerupExpired()
            break
        case .ExtraPoints50:
            score.increaseByWithColor(50, color: Colors.PowerupColor)
            checkForPowerup()
            powerupExpired()
            break
        case .ExtraPoints100:
            score.increaseByWithColor(100, color: Colors.PowerupColor)
            checkForPowerup()
            powerupExpired()
            break
        default:
            break
        }
    }
    
    func powerupExpired() {
        powerupMultiplicator = 1
        powerupHandler.currentPowerup.stop()
        powerupHandler.currentPowerup.fadeOut()
        powerupHandler.currentPowerup = nil

        powerupDescription.text = ""
        
        resetCircleColors()
        resetAvailableColors()
    }
    
    // MARK: - HELPER FUNCTIONS
    private func getRandomBallColor() -> UIColor {
        var random = Int(arc4random_uniform(UInt32(availableColors.count)));
        var color = availableColors[random]
        return color
    }
}
