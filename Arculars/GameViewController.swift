//
//  GameViewController.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, SceneDelegate, GKGameCenterControllerDelegate {
    
    var menuScene : MenuScene!
    var gameScene : GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initGameCenter()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        #if DEBUG
            
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.showsPhysics = true

        #endif
        
        // Create and configure the menu scene.
        menuScene = MenuScene(size: skView.bounds.size)
        menuScene.scaleMode = .AspectFill
        menuScene.sceneDelegate = self
        
        // Create and configure the game scene.
        gameScene = GameScene(size: skView.bounds.size)
        gameScene.scaleMode = .AspectFill
        gameScene.sceneDelegate = self
        
        // Present the initial scene.
        showMenuScene()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func initGameCenter() {
        // Check if user is already authenticated in game center
        if GKLocalPlayer.localPlayer().authenticated == false {
            
            // Show the Login Prompt for Game Center
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    // self.scene!.gamePaused = true
                    self.presentViewController(viewController, animated: true, completion: nil)
                    
                    // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.addObserver(self, selector:"gameCenterStateChanged", name: "GKPlayerAuthenticationDidChangeNotificationName", object: nil)
                }
            }
        }
    }
    
    // Continue the Game, if GameCenter Authentication state
    // has been changed (login dialog is closed)
    func gameCenterStateChanged() {
        // self.scene!.gamePaused = false
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        // scene!.gameOver = false
    }

    func showGameCenter() {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = "io.rmnblm.arculars.endless"
        
        // Show leaderboard
        self.presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    func showMenuScene() {
        (self.view as SKView).presentScene(menuScene)
    }
    
    func showGameScene() {
        (self.view as SKView).presentScene(gameScene)
    }
}
