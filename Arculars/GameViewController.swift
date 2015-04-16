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
import GoogleMobileAds

class GameViewController: UIViewController, ADBannerViewDelegate, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, SceneDelegate {
    
    // Apple iAd
    var iAdView : ADBannerView?
    
    // Google AdMob
    let adUnitID = "ca-app-pub-6315531723758852/6739964922"
    var adMobView : GADBannerView?
    
    var products = [SKProduct]()
    var currentProduct = SKProduct()
    let productRemoveAdsID = "io.rmnblm.arculars.removeads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Advertisements
        if !PurchaseHandler.hasRemovedAds() {
            loadiAd()
            loadAdMob()
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
        var scene = MenuScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showGameScene(gameMode: GameMode) {
        // Create and configure the game scene.
        var scene = GameScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showStatsScene() {
        // Create and configure the stats scene.
        var scene = StatsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showSettingsScene() {
        // Create and configure the settings scene.
        var scene = SettingsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showGameoverScene(gameMode: GameMode) {
        // Create and configure the gameover scene.
        var scene = GameoverScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showAboutScene() {
        var scene = AboutScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.originalContentView as! SKView).presentScene(scene)
    }
    
    func showHelpScene() {
        var scene = HelpScene(size: self.view.bounds.size)
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
                    var alert = UIAlertController(title: "Purchase successful", message: "Thank you for your support.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                default:
                    break
                }
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                showMenuScene()
                break
            case .Failed:
                var alert = UIAlertController(title: "Purchase failed", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
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
        
        iAdView?.removeFromSuperview()
        adMobView?.removeFromSuperview()
    }
    
    // MARK: - IAD IMPLEMENTATION
    private func loadiAd() {
        iAdView = ADBannerView(adType: ADAdType.Banner)
        var x = view.frame.width / 2
        var y = view.frame.height - (iAdView!.frame.height / 2)
        iAdView!.center = CGPoint(x: x, y: y)
        iAdView!.delegate = self
        iAdView!.hidden = true
        view.addSubview(iAdView!)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        iAdView?.hidden = false
        adMobView?.hidden = true
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        iAdView?.hidden = true
        adMobView?.hidden = false
    }
    
    // MARK: - ADMOB IMPLEMENTATION
    private func loadAdMob() {
        var x = (view.frame.width - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).width) / 2
        var y = view.frame.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height
        adMobView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait, origin: CGPoint(x: x, y: y))
        adMobView?.adUnitID = adUnitID
        adMobView?.delegate = self
        adMobView?.hidden = true
        adMobView?.rootViewController = self
        self.view.addSubview(adMobView!)
        
        var request : GADRequest = GADRequest()
        adMobView?.loadRequest(request)
    }
    
    func adViewDidReceiveAd(view: GADBannerView!) {
        if (iAdView?.hidden == true) {
            adMobView?.hidden = false
        }
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        adMobView?.hidden = true
    }
    
    // MARK: - HELPER FUNCTIONS
    private func getShareImage(score: Int, gameMode: GameMode) -> UIImage {
        switch gameMode {
        case GameMode.Endless: return ShareImageHelper.createImage(score, image: "shareimage-endless")
        case GameMode.Timed: return ShareImageHelper.createImage(score, image: "shareimage-timed")
        default: return UIImage()
        }
    }
    
}
