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
import StoreKit

class GameViewController: UIViewController, ChartboostDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, SceneDelegate {
    
    var products = [SKProduct]()
    var currentProduct = SKProduct()
    let productRemoveAdsID = "io.rmnblm.arculars.removeads"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present the initial scene.
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasPerformedFirstLaunch") {
            SettingsHandler.reset()
            StatsHandler.reset()
            RateHandler.reset()
            PurchaseHandler.reset()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasPerformedFirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
            showHelpScene(1)
        } else {
            // Setup Advertisements
            if !PurchaseHandler.hasRemovedAds() {
                showInterstitial()
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
        activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: (view.frame.size.width / 4), y: -(view.frame.height / 4)), size: CGSize(width: view.frame.width, height: view.frame.height))
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
        var scene = MenuScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showGameScene(gameMode: GameMode) {
        var scene = GameScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.view as! SKView).presentScene(scene)
    }
    
    func showStatsScene() {
        var scene = StatsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showSettingsScene() {
        var scene = SettingsScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showGameoverScene(gameMode: GameMode) {
        var scene = GameoverScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        scene.gameMode = gameMode
        (self.view as! SKView).presentScene(scene)
    }
    
    func showAboutScene() {
        var scene = AboutScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
    }
    
    func showHelpScene(page: Int) {
        var scene = HelpScene(size: self.view.bounds.size, page: page)
        scene.scaleMode = .AspectFill
        scene.sceneDelegate = self
        (self.view as! SKView).presentScene(scene)
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
        
        // Remove Banner
    }
    
    
    // MARK: - CHARTBOOST IMPLEMENTATION
    func showInterstitial() {
        Chartboost.showInterstitial(CBLocationHomeScreen)
    }
    
    // MARK: - REVMOB IMPLEMENTATION
    
    
    // MARK: - HELPER FUNCTIONS
    private func getShareImage(score: Int, gameMode: GameMode) -> UIImage {
        switch gameMode {
        case GameMode.Endless: return ShareImageHelper.createImage(score, image: "shareimage-endless")
        case GameMode.Timed: return ShareImageHelper.createImage(score, image: "shareimage-timed")
        default: return UIImage()
        }
    }
    
}
