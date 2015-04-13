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
    
    private var currentScene : SKScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Add observer to know when the app enters background
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didEnterBackground:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        
        // Add observer to know when the app gets active
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didBecomActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        #if DEBUG
            /*
            skView.showsDrawCount = true
            skView.showsFPS = true
            skView.showsPhysics = true
            */
        #endif
        
        // Init Easy Game Center Singleton
        let eaysGameCenter = GCHandler.sharedInstance {
            (resultPlayerAuthentified) -> Void in
            if resultPlayerAuthentified {
                // When player is authentified to Game Center
            } else {
                // Player not authentified to Game Center
                // No connexion internet or not authentified to Game Center
            }
        }
        GCHandler.delegate = self
        
        // Present the initial scene.
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasPerformedFirstLaunch") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: SETTINGS_VIBRATION)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: SETTINGS_SOUND)
            NSUserDefaults.standardUserDefaults().setInteger(Difficulty.Normal.rawValue, forKey: SETTINGS_DIFFICULTY)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasPerformedFirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
            showHelp()
        } else {
            showMenu()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func didEnterBackground(notification : NSNotification) {
        #if DEBUG
            println("Arculars did enter background")
        #endif
    }
    
    func didBecomActive(notification : NSNotification) {
        #if DEBUG
            println("Arculars did become active")
        #endif
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
        let objectsToShare = [textToShare]
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        // For iPad only
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: -(view.frame.width / 2) + ((view.frame.width / 5) * 4), y: -(view.frame.height / 4)), size: CGSize(width: view.frame.width, height: view.frame.height))
        //
        
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func showMenu() {
        // Create and configure the menu scene.
        var scene = MenuScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func startGame(gameMode: GameMode) {
        // Create and configure the game scene.
        var scene = GameScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.view as! SKView).presentScene(scene)
    }
    
    func showStatistics() {
        // Create and configure the stats scene.
        var scene = StatsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showSettings() {
        // Create and configure the settings scene.
        var scene = SettingsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showGameover(gameMode: GameMode) {
        // Create and configure the gameover scene.
        var scene = GameoverScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.view as! SKView).presentScene(scene)
    }
    
    func showAbout() {
        var scene = AboutScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showHelp() {
        var scene = HelpScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showGamecenter() {
        if !GCHandler.isPlayerIdentifiedToGameCenter() {
            GCHandler.showGameCenterAuthentication(completion: {(result) -> Void in
                GCHandler.showGameCenterAchievements(completion: {(result) -> Void in
                    self.showMenu()
                })
            })
        } else {
            GCHandler.showGameCenterAchievements(completion: {(result) -> Void in
                self.showMenu()
            })
        }
    }
}
