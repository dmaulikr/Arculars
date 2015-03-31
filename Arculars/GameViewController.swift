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

class GameViewController: UIViewController, SceneDelegate {
    
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
        GCHelper.authenticateLocalUser()
        
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
    
    func presentGameCenter() {
        GCHelper.showGameCenter(self, viewState: GKGameCenterViewControllerState.Leaderboards)
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
        var scene = MenuScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        (self.view as SKView).presentScene(scene)
    }
    
    func startGame(gameMode: GameMode) {
        // Create and configure the game scene.
        var scene = GameScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        
        (self.view as SKView).presentScene(scene)
    }
    
    func showStatsScene() {
        // Create and configure the stats scene.
        var scene = StatsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        (self.view as SKView).presentScene(scene)
    }
    
    func showSettingsScene() {
        // Create and configure the settings scene.
        var scene = SettingsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        (self.view as SKView).presentScene(scene)
    }
    
    func showGameoverScene(gameMode: GameMode) {
        // Create and configure the gameover scene.
        var scene = GameoverScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        
        (self.view as SKView).presentScene(scene)
    }
    
    func showAboutScene() {
        var scene = AboutScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        (self.view as SKView).presentScene(scene)
    }
    
    func showHelpScene() {
        var scene = HelpScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        
        (self.view as SKView).presentScene(scene)
    }
}
