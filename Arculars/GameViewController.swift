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
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("useGC") == nil) {
            self.authenticateLocalPlayer()
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscore")
        
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
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.presentViewController(ViewController, animated: true, completion: nil)
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "useGC")
            } else {
                // 3 Game center is not enabled on the users device
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "useGC")
                println("Local player could not be authenticated, disabling game center")
                println(error)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func presentGameCenter() {
        if GKLocalPlayer.localPlayer().authenticated {
            var gcViewController = GKGameCenterViewController()
            gcViewController.gameCenterDelegate = self
            gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
                
            // Show leaderboard
            self.presentViewController(gcViewController, animated: true, completion: nil)
        } else {
            authenticateLocalPlayer()
        }
    }
    
    func shareOnTwitter() {
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
    
    func shareOnFacebook() {
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
    
    func shareOnWhatsApp() {
        var highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        var text = "My highscore in Arculars is \(highscore)! Can you beat it? Download in AppStore: http://arculars.rmnblm.io/appstore"
        var escapedString = "whatsapp://send?text=" + text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        var whatsappURL : NSURL? = NSURL(string: escapedString)
        if (UIApplication.sharedApplication().canOpenURL(whatsappURL!)) {
            UIApplication.sharedApplication().openURL(whatsappURL!)
        }
    }
    
    func shareOnOther() {
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
