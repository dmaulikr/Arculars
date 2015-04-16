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
    private var label_totalpoints           : SKLabelNode!
    private var label_highscore_endless     : SKLabelNode!
    private var label_highscore_timed       : SKLabelNode!
    private var label_firedballs            : SKLabelNode!
    private var label_precision             : SKLabelNode!
    
    private var btnReset                    : SKShapeNode!
    private var btnClose                    : SKShapeNode!
    
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
        getStats()
    }
    
    deinit {
        #if DEBUG
            println("StatsScene deinit is called")
        #endif
    }
    
    // MARK: - INITIALIZATION FUNCTIONS
    private func initScene() {
        var rowheight = size.height / 14
        
        // INIT TITLE
        rootNode.addChild(Nodes.getSceneTitle(frame.size, content: "STATS"))
        
        // INIT PLAYED TIME NODE
        var ptn = createRow("PLAYED TIME")
        ptn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 2))
        label_playedtime = (ptn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(ptn)
        
        // INIT PLAYED GAMES NODE
        var pgn = createRow("PLAYED GAMES")
        pgn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 3))
        label_playedgames = (pgn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(pgn)
        
        // INIT OVERALL POINTS NODE
        var opn = createRow("TOTAL POINTS")
        opn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 4))
        label_totalpoints = (opn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(opn)
        
        // INIT HIGHSCORE ENDLESS NODE
        var hen = createRow("HIGH SCORE ENDLESS")
        hen.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 5))
        label_highscore_endless = (hen.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(hen)
        
        // INIT HIGHSCORE TIMED NODE
        var htn = createRow("HIGH SCORE TIMED")
        htn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 6))
        label_highscore_timed = (htn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(htn)
        
        // INIT FIRED BALLS NODE
        var fbn = createRow("FIRED BALLS")
        fbn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 7))
        label_firedballs = (fbn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(fbn)
        
        // INIT HITS NODE
        var prn = createRow("PRECISION")
        prn.position = CGPoint(x: 0, y: (size.height / 2) - (rowheight * 8))
        label_precision = (prn.childNodeWithName("stats_label") as! SKLabelNode)
        rootNode.addChild(prn)
        
        // INIT RESET BUTTON
        btnReset = Nodes.getCircleButton(CGPoint(x: 0, y: -(frame.height / 4)), radius: frame.height / 16, color: Colors.AppColorTwo, content1: "RESET")
        rootNode.addChild(btnReset)
        
        // INIT CLOSE BUTTON
        btnClose = Nodes.getTextButton(frame.size, content: "CLOSE")
        rootNode.addChild(btnClose)
    }
    
    // MARK: - STATS FUNCTIONS
    private func getStats() {
        label_playedtime.text = stringFromSeconds(StatsHandler.getPlayedTime())
        label_playedgames.text = "\(StatsHandler.getPlayedGames())"
        label_totalpoints.text = "\(StatsHandler.getTotalPoints())"
        label_highscore_endless.text = "\(StatsHandler.getHighscore(GameMode.Endless))"
        label_highscore_timed.text = "\(StatsHandler.getHighscore(GameMode.Timed))"
        label_firedballs.text = "\(StatsHandler.getFiredBalls())"
        label_precision.text = String(format: "%.1f", StatsHandler.getPrecision()) + "%"
    }
    
    // MARK: - TOUCH FUNCTIONS
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            for object in nodesAtPoint(location) {
                if (btnClose == object as? SKShapeNode) {
                    sceneDelegate!.showMenuScene()
                } else if (btnReset == object as? SKShapeNode) {
                    var resetAlert = UIAlertController(title: "Reset Stats", message: "Do you really want to reset your stats? This will also reset your Game Center achievements.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    resetAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                        StatsHandler.reset()
                        GCHandler.resetAllAchievements(nil)
                        self.getStats()
                    }))
                    resetAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
                    
                    view?.window?.rootViewController?.presentViewController(resetAlert, animated: true, completion: nil)
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
        var label = SKLabelNode(text: labelText as String)
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
    
    private func stringFromSeconds(seconds : Int) -> String {
        var s = seconds % 60
        var m = (seconds / 60) % 60
        var h = (seconds / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",h ,m ,s) as String
    }
    
}