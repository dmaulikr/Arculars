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
    
    var menuScene : MenuScene!
    var settingsScene : SettingsScene!
    var gameScene : GameScene!
    var gameoverScene : GameoverScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initGameCenter()
        
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
        
        // Create and configure the menu scene.
        menuScene = MenuScene(size: skView.bounds.size)
        menuScene.scaleMode = .AspectFill
        menuScene.sceneDelegate = self
        
        // Create and configure the settings scene.
        settingsScene = SettingsScene(size: skView.bounds.size)
        settingsScene.scaleMode = .AspectFill
        settingsScene.sceneDelegate = self
        
        // Create and configure the game scene.
        gameScene = GameScene(size: skView.bounds.size)
        gameScene.scaleMode = .AspectFill
        gameScene.sceneDelegate = self
        
        // Create and configure the gameover scene.
        gameoverScene = GameoverScene(size: skView.bounds.size)
        gameoverScene.scaleMode = .AspectFill
        gameoverScene.sceneDelegate = self
        
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

    func presentGameCenter() {
        var gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = "io.rmnblm.arculars.endless"
        
        // Show leaderboard
        self.presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    func presentTwitterSharing() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Share on Twitter")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func presentFacebookSharing() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func presentWhatsAppSharing() {
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        var text = "My highscore in Arculars is \(highscore)! Can you beat it? Download in AppStore: http://arculars.rmnblm.io/appstore"
        var escapedString = "whatsapp://send?text=" + text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var whatsappURL : NSURL? = NSURL(string: escapedString)
        if (UIApplication.sharedApplication().canOpenURL(whatsappURL!)) {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
    }
    
    func presentOtherSharing() {
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        let textToShare = "Arculars is awesome! My highscore is \(highscore)! Can you beat it?"
        if let myWebsite = NSURL(string: "http://arculars.rmnblm.io/appstore") {
            let objectsToShare = [textToShare, myWebsite]
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    func showMenuScene() {
        (self.view as SKView).presentScene(menuScene)
    }
    
    func showSettingsScene() {
        (self.view as SKView).presentScene(settingsScene)
    }
    
    func showGameScene() {
        (self.view as SKView).presentScene(gameScene)
    }
    
    func showGameoverScene() {
        (self.view as SKView).presentScene(gameoverScene)
    }
}
