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
import Social

class GameViewController: UIViewController, SceneDelegate, GKGameCenterControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        #if DEBUG
            /*
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.showsPhysics = true
            */
        #endif
        
        // Try to authenticate Game Center
        tryAuthenticateLocalPlayer()
        
        // Present the initial scene.
        showMenuScene()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tryAuthenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                // self.scene!.gamePaused = true
                self.presentViewController(viewController, animated: true, completion: nil)
                
                // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.addObserver(self, selector:"gameCenterStateChanged", name: "GKPlayerAuthenticationDidChangeNotificationName", object: nil)
            }
        }
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if viewController != nil {
                // self.scene!.gamePaused = true
                self.presentViewController(viewController, animated: true, completion: nil)
                
                // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                let notificationCenter = NSNotificationCenter.defaultCenter()
                notificationCenter.addObserver(self, selector:"gameCenterStateChanged", name: "GKPlayerAuthenticationDidChangeNotificationName", object: nil)
            } else if (localPlayer.authenticated) {
                self.gameCenterStateChanged()
            }
            else {
                var alert = UIAlertController(title: "Authentication Failed", message: "Please login to Game Center and come back.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Continue the Game, if GameCenter Authentication state
    // has been changed (login dialog is closed)
    func gameCenterStateChanged() {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        
        // Show leaderboard
        self.presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func presentGameCenter() {
        if GKLocalPlayer.localPlayer().authenticated {
            gameCenterStateChanged()
        } else {
            authenticateLocalPlayer()
        }
    }
    
    func shareOnTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Check out my score in Arculars! #ARCULARS")
            twitterSheet.addURL(NSURL(fileURLWithPath: "http://arculars.rmnblm.io"))
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOnFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Check out my score in Arculars! #ARCULARS")
            facebookSheet.addURL(NSURL(fileURLWithPath: "http://arculars.rmnblm.io"))
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOnWhatsApp() {
        var text = "Check out Arculars, an addictive App for iOS! Can you beat my highscore? Download on http://arculars.rmnblm.io"
        var escapedString = "whatsapp://send?text=" + text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var whatsappURL : NSURL? = NSURL(string: escapedString)
        if (UIApplication.sharedApplication().canOpenURL(whatsappURL!)) {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
    }
    
    func shareOnOther() {
        let textToShare = "Check out Arculars, an addictive App for iOS! Can you beat my highscore? Download on http://arculars.rmnblm.io"
        let myWebsite = "http://arculars.rmnblm.io"
        let objectsToShare = [textToShare, myWebsite]
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func showMenuScene() {
        // Create and configure the menu scene.
        var menuScene = MenuScene(size: self.view.bounds.size)
        menuScene.scaleMode = .AspectFill
        menuScene.sceneDelegate = self
        
        (self.view as SKView).presentScene(menuScene)
    }
    
    func startGame(gameMode: GameMode) {
        // Create and configure the game scene.
        var gameScene = GameScene(size: self.view.bounds.size)
        gameScene.scaleMode = .AspectFill
        gameScene.sceneDelegate = self
        gameScene.gameMode = gameMode
        
        (self.view as SKView).presentScene(gameScene)
    }
    
    func showStatsScene() {
        // Create and configure the stats scene.
        var statsScene = StatsScene(size: self.view.bounds.size)
        statsScene.scaleMode = .AspectFill
        statsScene.sceneDelegate = self
        
        (self.view as SKView).presentScene(statsScene)
    }
    
    func showSettingsScene() {
        // Create and configure the settings scene.
        var settingsScene = SettingsScene(size: self.view.bounds.size)
        settingsScene.scaleMode = .AspectFill
        settingsScene.sceneDelegate = self
        
        (self.view as SKView).presentScene(settingsScene)
    }
    
    func showGameoverScene(gameMode: GameMode) {
        // Create and configure the gameover scene.
        var gameoverScene = GameoverScene(size: self.view.bounds.size)
        gameoverScene.scaleMode = .AspectFill
        gameoverScene.sceneDelegate = self
        gameoverScene.gameMode = gameMode
        
        (self.view as SKView).presentScene(gameoverScene)
    }
}
