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
import iAd
import StoreKit

class GameViewController: UIViewController, ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, SceneDelegate {
    
    var bannerView : ADBannerView?
    
    var products = [SKProduct]()
    var currentProduct = SKProduct()
    var productRemoveAdsID = "io.rmnblm.arculars.removeads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup iAD
        if !PurchaseHandler.hasRemovedAds() {
            self.canDisplayBannerAds = true
            self.bannerView?.delegate = self
            self.bannerView?.hidden = true
        }
        
        // Setup StoreKit
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        getProductInfo()
        
        // Init Easy Game Center Singleton
        let gamecenter = GCHandler.sharedInstance {
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
            SettingsHandler.reset()
            StatsHandler.reset()
            RateHandler.reset()
            PurchaseHandler.reset()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasPerformedFirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
            showHelpScene()
        } else {
            showMenuScene()
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
    
    // MARK: - SCENEDELEGATE IMPLEMENTATION
    func shareScore(destination: String, score: Int, gameType: GameMode) {
        if destination == "facebook" {
            shareScoreOnFacebook(score, gameType: gameType)
            return
        } else if destination == "twitter" {
            shareScoreOnTwitter(score, gameType: gameType)
            return
        }
        
        let textToShare = Strings.SharingText
        let imageToShare = getShareImage(score, gameMode: gameType)
        let objectsToShare = [textToShare, imageToShare]
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: [WhatsAppActivity(parent: self), InstagramActivity(parent: self)])
        
        // For iPad only
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: 0, y: -(view.frame.height / 4)), size: CGSize(width: view.frame.width, height: view.frame.height))
        //
        
        activityViewController.excludedActivityTypes = [
            UIActivityTypeAirDrop,
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func shareScoreOnTwitter(score: Int, gameType: GameMode) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(Strings.SharingText)
            twitterSheet.addURL(NSURL(fileURLWithPath: Strings.ArcularsAppStore))
            twitterSheet.addImage(getShareImage(score, gameMode: gameType))
            twitterSheet.completionHandler = {
                result -> Void in
                
                var getResult = result as SLComposeViewControllerResult
                switch(getResult) {
                case SLComposeViewControllerResult.Cancelled:
                    #if DEBUG
                        println("Sharing on Twitter cancelled.")
                    #endif
                    break
                case SLComposeViewControllerResult.Done:
                    #if DEBUG
                        println("Sharing on Twitter successful.")
                    #endif
                    GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.socialize.twitter", showBannnerIfCompleted: true)
                    break
                default:
                    #if DEBUG
                        println("Error while sharing on Twitter.")
                    #endif
                    break
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareScoreOnFacebook(score: Int, gameType: GameMode) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(Strings.SharingText)
            facebookSheet.addURL(NSURL(fileURLWithPath: Strings.ArcularsAppStore))
            facebookSheet.addImage(getShareImage(score, gameMode: gameType))
            facebookSheet.completionHandler = {
                result -> Void in
                
                var getResult = result as SLComposeViewControllerResult
                switch(getResult) {
                case SLComposeViewControllerResult.Cancelled:
                    #if DEBUG
                        println("Sharing on Facebook cancelled.")
                    #endif
                    break
                case SLComposeViewControllerResult.Done:
                    #if DEBUG
                        println("Sharing on Facebook successful.")
                    #endif
                    GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.socialize.facebook", showBannnerIfCompleted: true)
                    break
                default:
                    #if DEBUG
                        println("Error while sharing on Facebook.")
                    #endif
                    break
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func showMenuScene() {
        // Create and configure the menu scene.
        var scene = MenuScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showGameScene(gameMode: GameMode) {
        // Create and configure the game scene.
        var scene = GameScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showStatsScene() {
        // Create and configure the stats scene.
        var scene = StatsScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showSettingsScene() {
        // Create and configure the settings scene.
        var scene = SettingsScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showGameoverScene(gameMode: GameMode) {
        // Create and configure the gameover scene.
        var scene = GameoverScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showAboutScene() {
        var scene = AboutScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showHelpScene() {
        var scene = HelpScene(size: self.originalContentView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func presentGameCenter() {
        if !GCHandler.isPlayerIdentifiedToGameCenter() {
            GCHandler.showGameCenterAuthentication(completion: {(result) -> Void in
                GCHandler.showGameCenterAchievements(completion: {(result) -> Void in
                    self.showMenuScene()
                })
            })
        } else {
            GCHandler.showGameCenterAchievements(completion: {(result) -> Void in
                self.showMenuScene()
            })
        }
    }
    
    func presentRateOnAppStore() {
        var refreshAlert = UIAlertController(title: "Rate Arculars", message: "If you enjoy using Arculars, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Rate Arculars", style: .Default, handler: { (action: UIAlertAction!) in
            RateHandler.dontShowAgain()
            let url = NSURL(string: "\(Strings.ArcularsAppStore)")
            UIApplication.sharedApplication().openURL(url!)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Remind me later", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "No, thanks", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            RateHandler.dontShowAgain()
        }))
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func purchaseRemoveAds() {
        for p in products {
            if (p.productIdentifier == productRemoveAdsID) {
                currentProduct = p
                let payment = SKPayment(product: p)
                SKPaymentQueue.defaultQueue().addTransactionObserver(self)
                SKPaymentQueue.defaultQueue().addPayment(payment)
            }
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    // MARK: - STOREKIT IMPLEMENTATION
    func getProductInfo()
    {
        if SKPaymentQueue.canMakePayments() {
            var productID : NSSet = NSSet(objects: productRemoveAdsID, productRemoveAdsID)
            var request : SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            #if DEBUG
                println("Please enable In-App Purchases")
            #endif
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var responseProducts = response.products
        for product in responseProducts {
            products.append(product as! SKProduct)
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case productRemoveAdsID:
                removeAds()
                var alert = UIAlertController(title: "Restore successful", message: "Your previous purchases have been restored successfully.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                break
            default:
                break
            }
            
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
            case .Purchased:
                
                let prodID = currentProduct.productIdentifier as String
                
                switch prodID {
                case productRemoveAdsID:
                    removeAds()
                    break
                default:
                    break
                }
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                showMenuScene()
                break
            case .Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                showMenuScene()
                break
            default:
                break
            }
        }
        
    }
    
    func removeAds() {
        PurchaseHandler.removeAds()
        canDisplayBannerAds = false
        bannerView?.removeFromSuperview()
    }
    
    // MARK: - IAD IMPLEMENTATION
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
    // MARK: - HELPER FUNCTIONS
    private func getShareImage(score: Int, gameMode: GameMode) -> UIImage {
        switch gameMode {
        case GameMode.Endless: return ShareImageHelper.createImage(score, image: "shareimage-endless")
        case GameMode.Endless: return ShareImageHelper.createImage(score, image: "shareimage-timed")
        default: return UIImage()
        }
    }
}
