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
    
    // MARK: - VARIABLE DECLARATIONS
    weak var sceneDelegate : SceneDelegate?
    
    private var rootNode = SKNode()
    
    private var label_playedtime            : SKLabelNode!
    private var label_playedgames           : SKLabelNode!
    private var label_overallpoints         : SKLabelNode!
    private var label_highscore_endless     : SKLabelNode!
    private var label_highscore_timed       : SKLabelNode!
    private var label_firedballs            : SKLabelNode!
    private var label_hits                  : SKLabelNode!
    
    private var btnReset                    : SKShapeNode!
    private var btnToMenu                   : SKShapeNode!
    
    // MARK: - SCENE SPECIFIC FUNCTIONS
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Setup Scene
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = Colors.Background
        
        // Add Root Node
        addChild(rootNode)
        
        initScene()
        
        alpha = 0.0
    }
    
    override func didMoveToView(view: SKView) {
        runAction(SKAction.fadeInWithDuration(0.1))
        getStats()
    }
    
    deinit {
        #if DEBUG
            println("StatsScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        var rowheight = size.height / 12
        
        // INIT TITLE
        var title = SKShapeNode(rectOfSize: CGSize(width: size.width / 3, height: rowheight))
        title.position = CGPoint(x: 0, y: (size.height / 2) - rowheight)
        title.lineWidth = 0
        title.strokeColor = UIColor.clearColor()
        title.fillColor = UIColor.clearColor()
        var titleLabel = SKLabelNode(text: "STATS")
        titleLabel.fontSize = size.height / 32
        titleLabel.fontName = Fonts.FontNameBold
        titleLabel.fontColor = Colors.FontColor
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.addChild(titleLabel)
        rootNode.addChild(title)
        
        // INIT PLAYED TIME NODE
        var ptn = createRow("PLAYED TIME")
        ptn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 2))
        label_playedtime = (ptn.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(ptn)
        
        // INIT PLAYED GAMES NODE
        var pgn = createRow("PLAYED GAMES")
        pgn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 3))
        label_playedgames = (pgn.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(pgn)
        
        // INIT OVERALL POINTS NODE
        var opn = createRow("OVERALL POINTS")
        opn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 4))
        label_overallpoints = (opn.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(opn)
        
        // INIT HIGHSCORE ENDLESS NODE
        var hen = createRow("HIGH SCORE ENDLESS")
        hen.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 5))
        label_highscore_endless = (hen.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(hen)
        
        // INIT HIGHSCORE TIMED NODE
        var htn = createRow("HIGH SCORE TIMED")
        htn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 6))
        label_highscore_timed = (htn.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(htn)
        
        // INIT FIRED BALLS NODE
        var fbn = createRow("FIRED BALLS")
        fbn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 7))
        label_firedballs = (fbn.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(fbn)
        
        // INIT HITS NODE
        var hin = createRow("HITS")
        hin.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 8))
        label_hits = (hin.childNodeWithName("stats_label") as SKLabelNode)
        rootNode.addChild(hin)
        
        // INIT RESET AND GAMECENTER BUTTONS
        var btns = SKShapeNode(rectOfSize: CGSize(width: size.width, height: 2 * rowheight))
        btns.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 9.5))
        btns.lineWidth = 0
        
        btnReset = SKShapeNode(circleOfRadius: rowheight * 0.75)
        btnReset.position = CGPoint(x: 0, y: 0)
        btnReset.lineWidth = 1
        btnReset.strokeColor = Colors.AppColorOne
        btnReset.fillColor = Colors.AppColorOne
        var rel = SKLabelNode(text: "RESET")
        rel.userInteractionEnabled = false
        rel.fontSize = size.height / 48
        rel.fontName = Fonts.FontNameNormal
        rel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        rel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        btnReset.addChild(rel)
        btns.addChild(btnReset)
        rootNode.addChild(btns)
        
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
    
    // MARK: - STATS FUNCTIONS
    private func getStats() {
        label_playedtime.text = stringFromSeconds(StatsHandler.getPlayedTime())
        label_playedgames.text = "\(StatsHandler.getPlayedGames())"
        label_overallpoints.text = "\(StatsHandler.getOverallPoints())"
        label_highscore_endless.text = "\(StatsHandler.getHighscore(GameMode.Endless))"
        label_highscore_timed.text = "\(StatsHandler.getHighscore(GameMode.Timed))"
        label_firedballs.text = "\(StatsHandler.getFiredBalls())"
        label_hits.text = "\(StatsHandler.getHits())"
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnToMenu == object as? SKShapeNode) {
                    sceneDelegate!.showMenu()
                } else if (btnReset == object as? SKShapeNode) {
                    var refreshAlert = UIAlertController(title: "Reset Stats", message: "Do you really want to reset your stats? This will not reset your Game Center scores.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                        StatsHandler.reset()
                        self.getStats()
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                    
                    view?.window?.rootViewController?.presentViewController(refreshAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    private func createRow(labelText: NSString) -> SKShapeNode {
        var labelFontSize = size.height / 48
        var statsFontSize = size.height / 24
        var statsFontName = Fonts.FontNameBold
        var gap = size.width / 50
        var rowheight = size.height / 12
        
        var row = SKShapeNode(rectOfSize: CGSize(width: size.width, height: rowheight))
        row.lineWidth = 0
        var label = SKLabelNode(text: labelText)
        label.position = CGPoint(x: gap, y: 0)
        label.fontSize = labelFontSize
        label.fontName = Fonts.FontNameNormal
        label.fontColor = Colors.FontColor
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        row.addChild(label)
        var stats_label = SKLabelNode(text: "0")
        stats_label.name = "stats_label"
        stats_label.position = CGPoint(x: -gap, y: 0)
        stats_label.fontSize = statsFontSize
        stats_label.fontName = statsFontName
        stats_label.fontColor = Colors.FontColor
        stats_label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        stats_label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        row.addChild(stats_label)
        return row
    }
    
    private func stringFromSeconds(seconds : Int) -> NSString {
        var s = seconds % 60
        var m = (seconds / 60) % 60
        var h = (seconds / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",h ,m ,s)
    }
    
}