//
//  StatsScene.swift
//  Arculars
//
//  Created by Roman Blum on 23/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class StatsScene: SKScene {
    
    var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var label_playedtime            : SKLabelNode!
    private var label_overallpoints         : SKLabelNode!
    private var label_highscore_endless     : SKLabelNode!
    private var label_highscore_timed       : SKLabelNode!
    private var label_firedballs            : SKLabelNode!
    private var label_hits                  : SKLabelNode!
    private var label_fails                 : SKLabelNode!
    
    private var btnReset                    : SKShapeNode!
    private var btnGameCenter               : SKShapeNode!
    private var btnToMenu                   : SKShapeNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = Colors.Background
        
        // Add Root Node
        self.addChild(rootNode)
        
        initScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initScene() {
        var labelFontSize = self.size.height / 48
        var labelFontName = "Avenir"
        var statsFontSize = self.size.height / 24
        var statsFontName = "Avenir-Black"
        var gap = self.size.width / 50
        var rowheight = self.size.height / 12
        
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: self.size.width / 3, height: rowheight))
        title.position = CGPoint(x: 0, y: (self.size.height / 2) - rowheight)
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "STATS")
        titleLabel.fontSize = self.size.height / 32
        titleLabel.fontName = "Avenir-Black"
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT PLAYED TIME NODE
        var ptn = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        ptn.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 2))
        ptn.lineWidth = 0
        var ptl = SKLabelNode(text: "PLAYED TIME")
        ptl.position = CGPoint(x: gap, y: 0)
        ptl.fontSize = labelFontSize
        ptl.fontName = labelFontName
        ptl.fontColor = Colors.FontColor
        ptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        ptl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        ptn.addChild(ptl)
        label_playedtime = SKLabelNode(text: "00:00:00")
        label_playedtime.position = CGPoint(x: -gap, y: 0)
        label_playedtime.fontSize = statsFontSize
        label_playedtime.fontName = statsFontName
        label_playedtime.fontColor = Colors.FontColor
        label_playedtime.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_playedtime.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        ptn.addChild(label_playedtime)
        rootNode.addChild(ptn)
        
        // INIT OVERALL POINTS NODE
        var opn = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        opn.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 3))
        opn.lineWidth = 0
        var opl = SKLabelNode(text: "OVERALL POINTS")
        opl.position = CGPoint(x: gap, y: 0)
        opl.fontSize = labelFontSize
        opl.fontName = labelFontName
        opl.fontColor = Colors.FontColor
        opl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        opl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        opn.addChild(opl)
        label_overallpoints = SKLabelNode(text: "0")
        label_overallpoints.position = CGPoint(x: -gap, y: 0)
        label_overallpoints.fontSize = statsFontSize
        label_overallpoints.fontName = statsFontName
        label_overallpoints.fontColor = Colors.FontColor
        label_overallpoints.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_overallpoints.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        opn.addChild(label_overallpoints)
        rootNode.addChild(opn)
        
        // INIT HIGHSCORE ENDLESS NODE
        var hen = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        hen.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 4))
        hen.lineWidth = 0
        var hel = SKLabelNode(text: "HIGHSCORE ENDLESS")
        hel.position = CGPoint(x: gap, y: 0)
        hel.fontSize = labelFontSize
        hel.fontName = labelFontName
        hel.fontColor = Colors.FontColor
        hel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        hel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hen.addChild(hel)
        label_highscore_endless = SKLabelNode(text: "0")
        label_highscore_endless.position = CGPoint(x: -gap, y: 0)
        label_highscore_endless.fontSize = statsFontSize
        label_highscore_endless.fontName = statsFontName
        label_highscore_endless.fontColor = Colors.FontColor
        label_highscore_endless.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_highscore_endless.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hen.addChild(label_highscore_endless)
        rootNode.addChild(hen)
        
        // INIT HIGHSCORE TIMED NODE
        var htn = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        htn.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 5))
        htn.lineWidth = 0
        var htl = SKLabelNode(text: "HIGHSCORE TIMED")
        htl.position = CGPoint(x: gap, y: 0)
        htl.fontSize = labelFontSize
        htl.fontName = labelFontName
        htl.fontColor = Colors.FontColor
        htl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        htl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        htn.addChild(htl)
        label_highscore_timed = SKLabelNode(text: "0")
        label_highscore_timed.position = CGPoint(x: -gap, y: 0)
        label_highscore_timed.fontSize = statsFontSize
        label_highscore_timed.fontName = statsFontName
        label_highscore_timed.fontColor = Colors.FontColor
        label_highscore_timed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_highscore_timed.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        htn.addChild(label_highscore_timed)
        rootNode.addChild(htn)
        
        // INIT FIRED BALLS NODE
        var fbn = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        fbn.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 6))
        fbn.lineWidth = 0
        var fbl = SKLabelNode(text: "FIRED BALLS")
        fbl.position = CGPoint(x: gap, y: 0)
        fbl.fontSize = labelFontSize
        fbl.fontName = labelFontName
        fbl.fontColor = Colors.FontColor
        fbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        fbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fbn.addChild(fbl)
        label_firedballs = SKLabelNode(text: "0")
        label_firedballs.position = CGPoint(x: -gap, y: 0)
        label_firedballs.fontSize = statsFontSize
        label_firedballs.fontName = statsFontName
        label_firedballs.fontColor = Colors.FontColor
        label_firedballs.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_firedballs.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fbn.addChild(label_firedballs)
        rootNode.addChild(fbn)
        
        // INIT HITS NODE
        var hin = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        hin.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 7))
        hin.lineWidth = 0
        var hil = SKLabelNode(text: "HITS")
        hil.position = CGPoint(x: gap, y: 0)
        hil.fontSize = labelFontSize
        hil.fontName = labelFontName
        hil.fontColor = Colors.FontColor
        hil.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        hil.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hin.addChild(hil)
        label_hits = SKLabelNode(text: "0")
        label_hits.position = CGPoint(x: -gap, y: 0)
        label_hits.fontSize = statsFontSize
        label_hits.fontName = statsFontName
        label_hits.fontColor = Colors.FontColor
        label_hits.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_hits.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        hin.addChild(label_hits)
        rootNode.addChild(hin)
        
        // INIT FAILS NODE
        var fan = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: rowheight))
        fan.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 8))
        fan.lineWidth = 0
        var fal = SKLabelNode(text: "FAILS")
        fal.position = CGPoint(x: gap, y: 0)
        fal.fontSize = labelFontSize
        fal.fontName = labelFontName
        fal.fontColor = Colors.FontColor
        fal.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        fal.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fan.addChild(fal)
        label_fails = SKLabelNode(text: "0")
        label_fails.position = CGPoint(x: -gap, y: 0)
        label_fails.fontSize = statsFontSize
        label_fails.fontName = statsFontName
        label_fails.fontColor = Colors.FontColor
        label_fails.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        label_fails.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fan.addChild(label_fails)
        rootNode.addChild(fan)
        
        // INIT RESET AND GAMECENTER BUTTONS
        var btns = SKShapeNode(rectOfSize: CGSize(width: self.size.width, height: 2 * rowheight))
        btns.position = CGPoint(x: 0, y: (self.size.height / 2) - (rowheight * 9.5))
        btns.lineWidth = 0
        
        btnReset = SKShapeNode(circleOfRadius: rowheight * 0.75)
        btnReset.position = CGPoint(x: -btns.frame.width / 4, y: 0)
        btnReset.lineWidth = 1
        btnReset.strokeColor = Colors.AppColorOne
        btnReset.fillColor = Colors.AppColorOne
        var rel = SKLabelNode(text: "RESET")
        rel.fontSize = self.size.height / 48
        rel.fontName = "Avenir"
        rel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnReset.addChild(rel)
        btns.addChild(btnReset)
        
        btnGameCenter = SKShapeNode(circleOfRadius: rowheight * 0.75)
        btnGameCenter.position = CGPoint(x: btns.frame.width / 4, y: 0)
        btnGameCenter.lineWidth = 1
        btnGameCenter.strokeColor = Colors.AppColorTwo
        btnGameCenter.fillColor = Colors.AppColorTwo
        var gcl = SKNode()
        var gcl1 = SKLabelNode(text: "GAME")
        gcl1.position = CGPoint(x: 0, y: gcl1.frame.height / 4)
        gcl1.fontSize = self.size.height / 48
        gcl1.fontName = "Avenir"
        gcl1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        gcl1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        gcl.addChild(gcl1)
        var gcl2 = SKLabelNode(text: "CENTER")
        gcl2.position = CGPoint(x: 0, y: -gcl2.frame.height / 4)
        gcl2.fontSize = self.size.height / 48
        gcl2.fontName = "Avenir"
        gcl2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        gcl2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        gcl.addChild(gcl2)
        btnGameCenter.addChild(gcl)
        btns.addChild(btnGameCenter)
        
        rootNode.addChild(btns)
        
        // INIT TO MENU BUTTON
        var tml = SKLabelNode(text: "BACK TO MENU")
        tml.position = CGPoint(x: 0, y: -(self.size.height / 2) + (self.size.height / 24))
        tml.fontName = "Avenir"
        tml.fontColor = Colors.FontColor
        tml.fontSize = self.size.height / 32
        btnToMenu = SKShapeNode(rect: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: tml.frame.height * 4))
        btnToMenu.lineWidth = 0
        btnToMenu.fillColor = UIColor.clearColor()
        btnToMenu.strokeColor = UIColor.clearColor()
        btnToMenu.addChild(tml)
        rootNode.addChild(btnToMenu)
        
    }
    
    override func didMoveToView(view: SKView) {
        self.updateStats()
        self.runAction(SKAction.fadeInWithDuration(0.3))
    }
    
    private func updateStats() {
        label_playedtime.text = stringFromSeconds(StatsHandler.getPlayedTime())
        label_overallpoints.text = "\(StatsHandler.getOverallPoints())"
        label_highscore_endless.text = "\(StatsHandler.getHighscore(GameType.Endless))"
        label_highscore_timed.text = "\(StatsHandler.getHighscore(GameType.Timed))"
        label_firedballs.text = "\(StatsHandler.getFiredBalls())"
        label_hits.text = "\(StatsHandler.getHits())"
        label_fails.text = "\(StatsHandler.getFails())"
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (btnToMenu.containsPoint(location)) {
                self.runAction(SKAction.fadeOutWithDuration(0.3), completion: { ()
                    self.sceneDelegate!.showMenuScene()
                })
            } else if (self.nodeAtPoint(location) == btnReset) {
                var refreshAlert = UIAlertController(title: "Reset Stats", message: "Do you really want to reset your stats?", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                    StatsHandler.reset()
                    self.updateStats()
                }))
                refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                
                self.view?.window?.rootViewController?.presentViewController(refreshAlert, animated: true, completion: nil)
            } else if (self.nodeAtPoint(location) == btnGameCenter) {
                self.sceneDelegate!.presentGameCenter()
            }
        }
    }
    
    func stringFromSeconds(seconds : Int) -> NSString {
        var seconds = seconds % 60
        var minutes = (seconds / 60) % 60
        var hours = (seconds / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
}