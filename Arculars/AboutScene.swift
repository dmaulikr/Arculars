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
    
    private var randomBallTimer = NSTimer()
    
    private var btnWeb : SKShapeNode!
    private var btnMail : SKShapeNode!
    private var btnToMenu : SKShapeNode!
    
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
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: size.height / 12))
        title.position = CGPoint(x: 0, y: (size.height / 2) - (size.height / 12))
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "ABOUT")
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        
        // LABELS
        var versionInfo = SKLabelNode(text: "Arculars v\(version())")
        versionInfo.fontSize = size.height / 32
        versionInfo.fontColor = Colors.FontColor
        versionInfo.fontName = Fonts.FontNameNormal
        versionInfo.position = CGPoint(x: 0, y: size.height / 4)
        versionInfo.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        versionInfo.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(versionInfo)
        
        var madeWithLove = SKLabelNode(text: "Made with love in Switzerland. :)")
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
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "CLOSE")
        tml.position = CGPoint(x: 0, y: -(size.height / 2) + (size.height / 12))
        tml.fontName = Fonts.FontNameNormal
        tml.fontColor = Colors.DisabledColor
        tml.fontSize = size.height / 32
        tml.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tml.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        btnToMenu = SKShapeNode(rect: CGRect(x: -(size.width / 2), y: -(size.height / 2), width: size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
        
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnToMenu == object as? SKShapeNode) {
                    sceneDelegate!.showMenu()
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
    func version() -> String {
        let dictionary = NSBundle.mainBundle().infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    // MARK: - CREATE RANDOM BALLS
    func startRandomBallTimer() {
        randomBallTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("randomBallTimerTick:"), userInfo: nil, repeats: true)
    }
    
    func stopRandomBallTimer() {
        randomBallTimer.invalidate()
    }
    
    @objc func randomBallTimerTick(timer: NSTimer) {
        createRandomBall(randomPoint())
    }
    
    func randomPoint() -> CGPoint {
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(-Int(self.size.width / 2), hi: Int(self.size.width / 2))
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(-Int(self.size.height / 2), hi: Int(self.size.height / 2))
        return CGPoint(x: randomX, y: randomY)
    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    func createRandomBall(position: CGPoint) {
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