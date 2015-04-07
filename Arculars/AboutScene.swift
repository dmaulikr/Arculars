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
        
        // LABES
        var versionInfo = SKLabelNode(text: "Arculars v\(version())")
        versionInfo.fontSize = size.height / 32
        versionInfo.fontColor = Colors.FontColor
        versionInfo.fontName = Fonts.FontNameNormal
        versionInfo.position = CGPoint(x: 0, y: size.height / 4)
        versionInfo.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        versionInfo.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rootNode.addChild(versionInfo)
        
        var madeWithLove = SKLabelNode(text: "Made with love in Switzerland. ❤️")
        madeWithLove.fontSize = size.height / 48
        madeWithLove.fontColor = Colors.FontColor
        madeWithLove.fontName = Fonts.FontNameLight
        madeWithLove.position = CGPoint(x: 0, y: -size.height / 4)
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
        var tml = SKLabelNode(text: "BACK TO MENU")
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
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
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
        let version = dictionary["CFBundleShortVersionString"] as String
        let build = dictionary["CFBundleVersion"] as String
        return "\(version) build \(build)"
    }
}