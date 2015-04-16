//
//  AboutScene.swift
//  Arculars
//
//  Created by Roman Blum on 30/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class AboutScene: SKScene {
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var btnWeb : SKShapeNode!
    private var btnMail : SKShapeNode!
    private var btnClose : SKShapeNode!
    
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
        
        alpha = 0.0
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.1))
        startRandomBallTimer()
    }
    
    override func willMoveFromView(view: SKView) {
        stopRandomBallTimer()
    }
    
    deinit {
        #if DEBUG
            println("AboutScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        // INIT TITLE
        rootNode.addChild(Nodes.getSceneTitle(frame.size, content: "ABOUT"))
        
        // LABELS
        var versionInfo = SKLabelNode(text: "Arculars v\(version())")
        versionInfo.fontSize = size.height / 32
        versionInfo.fontColor = Colors.FontColor
        versionInfo.fontName = Fonts.FontNameNormal
        versionInfo.position = CGPoint(x: 0, y: size.height / 4)
        versionInfo.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        versionInfo.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(versionInfo)
        
        var madeWithLove = SKLabelNode(text: "Made with love in Glarus, Switzerland.")
        madeWithLove.fontSize = size.height / 42
        madeWithLove.fontColor = Colors.FontColor
        madeWithLove.fontName = Fonts.FontNameLight
        madeWithLove.position = CGPoint(x: 0, y: versionInfo.position.y - (versionInfo.frame.height * 1.5))
        madeWithLove.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        madeWithLove.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(madeWithLove)
        
        // INIT MAIL BUTTON
        btnMail = SKShapeNode(circleOfRadius: size.height / 16)
        btnMail.position = CGPoint(x: size.width / 6, y: 0)
        btnMail.lineWidth = 1
        btnMail.strokeColor = Colors.AppColorOne
        btnMail.fillColor = Colors.AppColorOne
        var email = SKLabelNode(text: "EMAIL")
        email.userInteractionEnabled = false
        email.fontSize = size.height / 48
        email.fontName = Fonts.FontNameNormal
        email.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        email.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnMail.addChild(email)
        rootNode.addChild(btnMail)
        
        // INIT WEB BUTTON
        btnWeb = SKShapeNode(circleOfRadius: size.height / 16)
        btnWeb.position = CGPoint(x: -size.width / 6, y: 0)
        btnWeb.lineWidth = 1
        btnWeb.strokeColor = Colors.AppColorTwo
        btnWeb.fillColor = Colors.AppColorTwo
        var web = SKLabelNode(text: "WEB")
        web.userInteractionEnabled = false
        web.fontSize = size.height / 48
        web.fontName = Fonts.FontNameNormal
        web.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        web.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnWeb.addChild(web)
        rootNode.addChild(btnWeb)
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getBottomButton(frame.size, content: "CLOSE")
        rootNode.addChild(btnClose)
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnClose == object as? SKShapeNode) {
                    sceneDelegate!.showMenuScene()
                } else if (btnMail == object as? SKShapeNode) {
                    let url = NSURL(string: "mailto:\(Strings.ArcularsEmail)")
                    UIApplication.sharedApplication().openURL(url!)
                } else if (btnWeb == object as? SKShapeNode) {
                    let url = NSURL(string: "\(Strings.ArcularsWebsite)")
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func version() -> String {
        let dictionary = NSBundle.mainBundle().infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    // MARK: - CREATE RANDOM BALLS
    private func startRandomBallTimer() {
        var wait = SKAction.waitForDuration(1.0)
        var run = SKAction.runBlock({
            self.randomBallTimerTick()
        })
        runAction(SKAction.repeatActionForever(SKAction.sequence([wait, run])), withKey: "actionTimer")
    }
    
    private func stopRandomBallTimer() {
        removeActionForKey("actionTimer")
    }
    
    private func randomBallTimerTick() {
        createRandomBall(randomPoint())
    }
    
    private func randomPoint() -> CGPoint {
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(-Int(self.size.width / 2), hi: Int(self.size.width / 2))
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(-Int(self.size.height / 2), hi: Int(self.size.height / 2))
        return CGPoint(x: randomX, y: randomY)
    }
    
    private func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    private func createRandomBall(position: CGPoint) {
        var ball = SKShapeNode(circleOfRadius: frame.height / 64)
        ball.fillColor = Colors.randomAppColor()
        ball.lineWidth = 1
        ball.strokeColor = ball.fillColor
        ball.antialiased = true
        ball.position = position
        ball.zPosition = -10
        rootNode.addChild(ball)
        ball.runAction(SKAction.scaleTo(0.0, duration: NSTimeInterval((arc4random_uniform(5) + 1))), completion: {()
            ball.removeFromParent()
        })
    }
}