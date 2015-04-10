//
//  GCHandler.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 8.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com

import Foundation
import GameKit
import SystemConfiguration

/**
GCHandler Swift
*/
class GCHandler: NSObject, GKGameCenterControllerDelegate {
    
    /// Achievements GKAchievement Cache
    private var achievementsCache = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    private var achievementsDescritpionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    private var achievementsCacheShowAfter = [String:String]()
    
    
    
    /// Delegate UIViewController
    private var delegateUIViewController:UIViewController?
    class var delegate: UIViewController? {
        
        get { return GCHandler.sharedInstance.delegateUIViewController }
        set {
            /* If GCHandler is start instance (for not instance Here) */
            if GCHandler.Static.instance != nil {
                
                var currentDelegate = GCHandler.sharedInstance.delegateUIViewController
                /* Different and not equal */
                
                if newValue != currentDelegate && !(newValue == currentDelegate) {
                    GCHandler.sharedInstance.delegateUIViewController  = newValue
                }
                
            }
        }
    }
    /*_______________________________________ STARTER _______________________________________*/
    /**
    Constructor
    
    */
    override init() {
        super.init()
    }
    /**
    Static GCHandler
    
    */
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: GCHandler? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    :param: completion Return when Game Center login player
    
    :returns: GameCenter instance
    */
    class func sharedInstance(#completion: ((resultPlayerAuthentified:Bool) -> Void)?) -> GCHandler {
        
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = GCHandler()
                GCHandler.loginPlayerToGameCenter(completion: {
                    (result) in
                    if completion != nil {
                        completion!(resultPlayerAuthentified: result)
                    }
                })
            }
            
        } else {
            completion!(resultPlayerAuthentified: GKLocalPlayer.localPlayer().authenticated)
        }
        return Static.instance!
    }
    /**
    Start Singleton GameCenter Instance
    
    */
    class var sharedInstance: GCHandler {
        
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = GCHandler()
                GCHandler.loginPlayerToGameCenter(completion: nil)
            }
        }
        
        return Static.instance!
    }
    /*____________________________ GameCenter Private Function __________________________________________________*/
    /**
    Login player to GameCenter With Handler Authentification
    This function is recall When player connect to Game Center
    
    :param: completion (Bool) if player login to Game Center
    */
    class func loginPlayerToGameCenter(#completion: ((result:Bool) -> Void)?)  {
        /* No Internet */
        if !GCHandler.isConnectedToNetwork() {
            
            
            if completion != nil { completion!(result:false) }
            /* Yes Internet */
        } else {
            GKLocalPlayer.localPlayer().authenticateHandler = {(var gameCenterVC:UIViewController!, var error:NSError!) ->
                Void in
                
                /* If got error / Or player not set value for login */
                if error != nil {
                    // GCHandler.sharedInstance.startTimerAuthentifiedGameCenter()
                    
                    if completion != nil { completion!(result: false) }
                    
                } else {
                    
                    /* Login to game center need Open page */
                    if gameCenterVC != nil {
                        if let delegateController = GCHandler.delegate {
                            delegateController.presentViewController(gameCenterVC, animated: true, completion: nil)
                        } else {
                            println("\nError : Delegate for Easy Game Center not set\n")
                        }
                        
                        /* Login is ok */
                    } else if GCHandler.isPlayerIdentifiedToGameCenter() == true {
                        GCHandler.loadGKAchievement(completion: { (result) ->
                            Void in
                            if completion != nil {
                                completion!(result: GCHandler.isPlayerIdentifiedToGameCenter())
                            }
                        })
                        
                    } else  {
                        if completion != nil { completion!(result: false) }
                    }
                }
            }
        }
    }
    /*____________________________ Game Center Public Show Methodes __________________________________________________*/
    /**
    Show Game Center Player Achievements
    
    :param: completion Viod just if open Game Center Achievements
    */
    class func showGameCenterAchievements(#completion: ((isShow:Bool) -> Void)?) {
        
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            
            if let delegateController = GCHandler.delegate {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = GCHandler.sharedInstance
                gc.viewState = GKGameCenterViewControllerState.Achievements
                
                delegateController.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!(isShow:true) }
                })
            } else {
                println("Error : Delegate not set.")
                if completion != nil { completion!(isShow:false) }
            }
        } else {
            if completion != nil { completion!(isShow:false) }
        }
    }
    /**
    Show Game Center Leaderboard
    
    :param: completion            Viod just if open Game Center Leaderboard
    */
    class func showGameCenterLeaderboards(completion: (() -> Void)?) {
        
        if GCHandler.isPlayerIdentifiedToGameCenter() {
            
            if let delegateController = GCHandler.delegate {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = GCHandler.sharedInstance
                gc.viewState = GKGameCenterViewControllerState.Leaderboards
                
                delegateController.presentViewController(gc, animated: true, completion: { () ->
                    Void in
                    
                    if completion != nil { completion!() }
                    
                })
            }
        }
    }
    /**
    Show Game Center Leaderboard
    
    :param: leaderboardIdentifier Leaderboard Identifier
    :param: completion            Viod just if open Game Center Leaderboard
    */
    class func showGameCenterLeaderboard(#leaderboardIdentifier :String, completion: (() -> Void)?) {
        
        if GCHandler.isPlayerIdentifiedToGameCenter() && leaderboardIdentifier != "" {
            
            if let delegateController = GCHandler.delegate {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate = GCHandler.sharedInstance
                gc.leaderboardIdentifier = leaderboardIdentifier
                gc.viewState = GKGameCenterViewControllerState.Leaderboards
                
                delegateController.presentViewController(gc, animated: true, completion: { () ->
                    Void in
                    
                    if completion != nil { completion!() }
                    
                })
            }
        }
    }
    /**
    Show Game Center Challenges
    
    :param: completion Viod just if open Game Center Challenges
    */
    class func showGameCenterChallenges(#completion: (() -> Void)?) {
        
        if GCHandler.isPlayerIdentifiedToGameCenter() {
            
            if let delegateController = GCHandler.delegate {
                
                var gc = GKGameCenterViewController()
                gc.gameCenterDelegate =  GCHandler.sharedInstance
                gc.viewState = GKGameCenterViewControllerState.Challenges
                
                delegateController.presentViewController(gc, animated: true, completion: {
                    () -> Void in
                    
                    if completion != nil { completion!() }
                })
            }
        }
    }
    /**
    Open Dialog for player see he wasn't authentifate to Game Center and can go to login
    
    :param: titre                     Title
    :param: message                   Message
    :param: buttonOK                  Title of button OK
    :param: buttonOpenGameCenterLogin Title of button open Game Center
    :param: completion                Completion if player open Game Center Authentification
    */
    class func openDialogGameCenterAuthentication(#titre:String, message:String,buttonOK:String,buttonOpenGameCenterLogin:String, completion: ((openGameCenterAuthentification:Bool) -> Void)?) {
        
        var alert = UIAlertController(title: titre, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if let delegateOK = GCHandler.delegate {
            
            alert.popoverPresentationController?.sourceView = delegateOK.view as UIView
            
            delegateOK.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: buttonOK, style: .Default, handler: {
                action in
                
                if completion != nil { completion!(openGameCenterAuthentification: false) }
                
            }))
            
            alert.addAction(UIAlertAction(title: buttonOpenGameCenterLogin, style: .Default, handler: {
                action in
                
                GCHandler.showGameCenterAuthentication(completion: { (resultOpenGameCenter) -> Void in
                    
                    if completion != nil { completion!(openGameCenterAuthentification: resultOpenGameCenter) }
                })
                
            }))
        }
    }
    /**
    Show banner game center
    
    :param: title       title
    :param: description description
    :param: completion  When show message
    */
    class func showCustomBanner(#title:String, description:String,completion: (() -> Void)?) {
        if GCHandler.isPlayerIdentifiedToGameCenter() {
            
            GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: {
                () -> Void in
                
                if completion != nil { completion!() }
            })
        }
        
    }
    /**
    Show page Authentication Game Center
    
    :param: completion Viod just if open Game Center Authentication
    */
    class func showGameCenterAuthentication(#completion: ((result:Bool) -> Void)?) {
        if completion != nil { completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!)) }
    }
    /*____________________________ GameCenter Public Other Method __________________________________________________*/
    /**
    If player is Identified to Game Center
    
    :returns: Bool is identified
    */
    class func isPlayerIdentifiedToGameCenter() -> Bool { return GKLocalPlayer.localPlayer().authenticated }
    
    /**
    Get local player (GKLocalPlayer)
    
    :returns: Bool True is identified
    */
    class func getLocalPlayer() -> GKLocalPlayer { return GKLocalPlayer.localPlayer() }
    /**
    Is have network and player identified to Game Center
    
    :returns: (Bool)
    */
    class func isHaveNetworkAndPlayerIdentified() -> Bool {
        return ( GCHandler.isConnectedToNetwork() && GCHandler.isPlayerIdentifiedToGameCenter() )
    }
    /*____________________________ GameCenter Public LeaderBoard __________________________________________________*/
    
    /**
    Get Leaderboards
    
    :param: completion return [GKLeaderboard] or nil
    
    Example:
    if let resultArrayGKLeaderboardIsOK = resultArrayGKLeaderboard as [GKLeaderboard]? {
    for oneGKLeaderboard in resultArrayGKLeaderboardIsOK  {
    }
    }
    */
    class func getGKLeaderboard(#completion: ((resultArrayGKLeaderboard:[GKLeaderboard]?) -> Void)) {
        
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            
            GKLeaderboard.loadLeaderboardsWithCompletionHandler {
                (var leaderboards:[AnyObject]!, error:NSError!) ->
                Void in
                
                if error != nil { println("Game Center: couldn't loadLeaderboards, error: \(error)") }
                
                if let leaderboardsIsArrayGKLeaderboard = leaderboards as? [GKLeaderboard] {
                    completion(resultArrayGKLeaderboard: leaderboardsIsArrayGKLeaderboard)
                    
                } else {
                    completion(resultArrayGKLeaderboard: nil)
                }
            }
        }
    }
    /**
    Reports a  score to Game Center
    
    :param: The score Int
    :param: Leaderboard identifier
    :param: completion (bool) when the score is report to game center or Fail
    */
    class func reportScoreLeaderboard(#leaderboardIdentifier:String, score: Int,completion: ((isSendToGameCenterOrNor:Bool) -> Void)?) {
        
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            
            if GKLocalPlayer.localPlayer().authenticated {
                
                let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier, player: GCHandler.getLocalPlayer())
                gkScore.value = Int64(score)
                gkScore.shouldSetDefaultLeaderboard = false
                
                GKScore.reportScores([gkScore], withCompletionHandler: ( {
                    (error: NSError!) -> Void in
                    
                    if ((error) != nil) {
                        if completion != nil { completion!(isSendToGameCenterOrNor:false) }
                        
                    } else {
                        if completion != nil { completion!(isSendToGameCenterOrNor:true) }
                        
                    }
                }))
            }
        } else {
            if completion != nil { completion!(isSendToGameCenterOrNor:false) }
        }
    }
    
    /**
    Get GKScoreOfLeaderboard
    
    :param: completion GKScore or nil
    */
    class func  getGKScoreLeaderboard(#leaderboardIdentifier:String, completion: ((resultGKScore:GKScore?) -> Void)) {
        
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            
            let leaderBoardRequest = GKLeaderboard()
            leaderBoardRequest.identifier = leaderboardIdentifier
            
            leaderBoardRequest.loadScoresWithCompletionHandler {
                (resultGKScore, error) ->Void in
                
                if error != nil || resultGKScore == nil {
                    completion(resultGKScore: nil)
                    
                } else  {
                    completion(resultGKScore: leaderBoardRequest.localPlayerScore)
                    
                }
            }
        }
    }
    
    /*____________________________ Achievement __________________________________________________*/
    /**
    Load achievements in cache
    (Is call when you init GCHandler, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    :param: completion (Bool) achievements in cache
    */
    class func loadGKAchievement(#completion: ((result:Bool) -> Void)?){
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            
            GKAchievement.loadAchievementsWithCompletionHandler({
                (var achievements:[AnyObject]!, error:NSError!) -> Void in
                if error != nil {
                    println("Game Center: could not load achievements, error: \(error)")
                    
                } else {
                    
                    if achievements != nil {
                        let easyGameCenter = GCHandler.sharedInstance
                        // easyGameCenter.achievementsCache = [String:GKAchievement]()
                        
                        for achievement in achievements  {
                            if let oneAchievement = achievement as? GKAchievement {
                                easyGameCenter.achievementsCache[oneAchievement.identifier] = oneAchievement
                                
                                GCHandler.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier, completion: { (tupleGKAchievementAndDescription) -> Void in
                                    if let achievementTuple = tupleGKAchievementAndDescription {
                                        
                                        //{
                                        easyGameCenter.achievementsDescritpionCache[oneAchievement.identifier] = achievementTuple.gkAchievementDescription
                                    }
                                    
                                })
                            }
                        }
                        
                        completion!(result: true)
                    } else {
                        completion!(result: false)
                    }
                }
            })
        }
    }
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    :param: achievementIdentifier Identifier Achievement
    
    :returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    */
    class func getTupleGKAchievementAndDescription(#achievementIdentifier:String,completion completionTuple: ((tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)
        ) {
            let gameCenter = GCHandler.sharedInstance
            
            if let achievementGKScore = gameCenter.achievementsCache[achievementIdentifier] {
                if let achievementDes =  gameCenter.achievementsDescritpionCache[achievementIdentifier] {
                    completionTuple(tupleGKAchievementAndDescription: (achievementGKScore,achievementDes))
                } else {
                    GCHandler.getGKAllAchievementDescription(completion: {
                        (arrayGKAD) -> Void in
                        
                        if let arrayGKADIsOK = arrayGKAD as [GKAchievementDescription]? {
                            var find = false
                            
                            for oneAchievement in arrayGKADIsOK {
                                if oneAchievement.identifier == achievementIdentifier {
                                    find = true
                                    completionTuple(tupleGKAchievementAndDescription: (achievementGKScore,oneAchievement))
                                }
                            }
                            
                            if !find { completionTuple(tupleGKAchievementAndDescription: nil) }
                            
                        } else { completionTuple(tupleGKAchievementAndDescription: nil) }
                        
                    })
                }
                
            } else { completionTuple(tupleGKAchievementAndDescription: nil) }
    }
    /**
    Get Achievement
    
    :param: identifierAchievement Identifier achievement
    
    :returns: GKAchievement Or nil if not exist
    */
    class func achievementForIndetifier(#identifierAchievement : NSString) -> GKAchievement? {
        let gameCenter = GCHandler.sharedInstance
        
        if GCHandler.isPlayerIdentifiedToGameCenter()  {
            
            if let achievementFind = gameCenter.achievementsCache[identifierAchievement as String] {
                return achievementFind
            } else {
                
                if  let achievementGet = GKAchievement(identifier: identifierAchievement as String) {
                    gameCenter.achievementsCache[identifierAchievement as String] = achievementGet
                    
                    /* recursive recall this func now that the achievement exist */
                    return GCHandler.achievementForIndetifier(identifierAchievement: identifierAchievement)
                } else { return nil }
            }
        }
        return nil
    }
    /**
    Add progress to an achievement
    
    :param: progress               Progress achievement Double (ex: 10% = 10.00)
    :param: achievementIdentifier  Achievement Identifier
    :param: showBannnerIfCompleted if you want show banner when now or not when is completed
    :param: completionIsSend       Completion if is send to Game Center
    */
    
    class func reportAchievements( #progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool) {
        
        if let achievement = GCHandler.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            //if !achievement.completed {
            achievement.percentComplete = progress
            
            /* show banner only if achievement is fully granted (progress is 100%) */
            if achievement.completed && showBannnerIfCompleted {
                achievement.showsCompletionBanner = true
            }
            if  achievement.completed && !showBannnerIfCompleted {
                let easyGameCenter = GCHandler.sharedInstance
                
                if easyGameCenter.achievementsCacheShowAfter[achievementIdentifier] == nil {
                    easyGameCenter.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
                }
                
            }
            
            let game = GCHandler.sharedInstance
            /* try to report the progress to the Game Center */
            GKAchievement.reportAchievements([achievement], withCompletionHandler:  {(var error:NSError!) -> Void in
                
                var validation = false
                
                if error != nil {
                    println("Couldn't save achievement (\(achievementIdentifier)) progress to \(progress) %")
                    
                } else {
                    validation = true
                }
            })
        }
    }
    
    
    
    /**
    Get GKAchievementDescription
    
    :param: completion return array [GKAchievementDescription] or nil
    
    Example:
    for achievement in arrayGKAchievementDescription  {
    if let oneAchievementDes = achievement as? GKAchievementDescription {
    
    }
    }
    */
    class func getGKAllAchievementDescription(#completion: ((arrayGKAD:[GKAchievementDescription]?) -> Void)){
        if GCHandler.isConnectedToNetwork() && GCHandler.isPlayerIdentifiedToGameCenter() {
            GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler {
                (var achievementsDescription:[AnyObject]!, error:NSError!) -> Void in
                
                if error != nil { println("Game Center: couldn't load achievementInformation, error: \(error)")
                } else {
                    if let achievementsIsArrayGKAchievementDescription = achievementsDescription as? [GKAchievementDescription] {
                        completion(arrayGKAD: achievementsIsArrayGKAchievementDescription)
                        
                    } else { completion(arrayGKAD: nil) }
                }
                
            }
        } else { completion(arrayGKAD: nil) }
        
    }
    /**
    If achievement is Completed
    
    :param: Achievement Identifier
    :return: (Bool) if finished
    */
    class func isAchievementCompleted(#achievementIdentifier: String) -> Bool{
        
        if let achievement = GCHandler.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
            if achievement.completed { return true }
            
        }
        
        return false
    }
    /**
    Get Achievements Completes during the game and banner was not showing
    
    Example :
    if let achievements : [String:GKAchievement] = GCHandler.getAchievementCompleteAndBannerNotShowing() {
    for achievement in achievements  {
    var oneAchievement : GKAchievement = achievement.1
    if oneAchievement.completed {
    oneAchievement.showsCompletionBanner = true
    }
    }
    }
    
    :returns: [String : GKAchievement] or nil
    */
    class func getAchievementCompleteAndBannerNotShowing() -> [String : GKAchievement]? {
        
        let achievements : [String:String] = GCHandler.sharedInstance.achievementsCacheShowAfter
        
        var achievementsTemps = [String:GKAchievement]()
        
        if achievements.count > 0 {
            
            for achievement in achievements  {
                
                
                let achievementExtract = GCHandler.achievementForIndetifier(identifierAchievement: achievement.1)
                
                
                //   if achievementExtract.completed && achievementExtract.showsCompletionBanner == false {
                achievementsTemps[achievement.1] = achievementExtract
                //  }
                
            }
            return achievementsTemps
        }
        return nil
        
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    
    :param: completion if is Show Achievement banner
    (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
    */
    class func showAllBannerAchievementCompleteForBannerNotShowing(#completion: ((achievementShow:GKAchievement?) -> Void)?) {
        
        if GCHandler.isPlayerIdentifiedToGameCenter() {
            if let achievementNotShow: [String:GKAchievement] = GCHandler.getAchievementCompleteAndBannerNotShowing() {
                for achievement in achievementNotShow  {
                    var oneAchievement : GKAchievement = achievement.1
                    
                    GCHandler.getTupleGKAchievementAndDescription(achievementIdentifier: oneAchievement.identifier, completion: {
                        (tupleGKAchievementAndDescription) -> Void in
                        
                        if let tupleOK = tupleGKAchievementAndDescription {
                            //oneAchievement.showsCompletionBanner = true
                            let title = tupleOK.gkAchievementDescription.title
                            let description = tupleOK.gkAchievementDescription.achievedDescription
                            
                            GCHandler.showCustomBanner(title: title, description: description, completion: { () -> Void in
                                if completion != nil { completion!(achievementShow: oneAchievement) }
                            })
                            
                            
                        } else {
                            if completion != nil { completion!(achievementShow: nil) }
                        }
                    })
                }
                GCHandler.sharedInstance.achievementsCacheShowAfter.removeAll(keepCapacity: false)
            } else {
                if completion != nil { completion!(achievementShow: nil) }
            }
            
        } else {
            if completion != nil { completion!(achievementShow: nil) }
        }
    }
    
    /**
    Get progress to an achievement
    
    :param: Achievement Identifier
    
    :returns: Double or nil (if not find)
    */
    class func getProgressForAchievement(#achievementIdentifier:String) -> Double? {
        if GCHandler.isPlayerIdentifiedToGameCenter() {
            if let achievementInArrayInt = GCHandler.sharedInstance.achievementsCache[achievementIdentifier]?.percentComplete {
                return achievementInArrayInt
            }
        }
        return nil
    }
    /**
    Remove One Achievements
    
    :param: Achievement Identifier
    :param: completion  If achievement is reset to Game Center server
    */
    class func resetOneAchievement(#achievementIdentifier :String, completion: ((isResetToGameCenterOrNor:Bool) -> Void)?) {
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            if let achievement = GCHandler.achievementForIndetifier(identifierAchievement: achievementIdentifier) {
                GKAchievement.resetAchievementsWithCompletionHandler({
                    (var error:NSError!) -> Void in
                    
                    var validation = false
                    if error != nil {
                        println("Couldn't Reset achievement (\(achievementIdentifier))")
                        
                    } else {
                        achievement.percentComplete = 0
                        achievement.showsCompletionBanner = false
                        validation = true
                        println("Reset achievement (\(achievementIdentifier))")
                        
                    }
                    if completion != nil { completion!(isResetToGameCenterOrNor: validation) }
                    
                })
            }
        } else {
            if completion != nil { completion!(isResetToGameCenterOrNor: false) }
        }
    }
    
    /**
    Remove All Achievements
    */
    class func resetAllAchievements( completion:  ((achievementReset:GKAchievement) -> Void)?)  {
        
        if GCHandler.isHaveNetworkAndPlayerIdentified() {
            let gameCenter = GCHandler.Static.instance!
            
            for lookupAchievement in gameCenter.achievementsCache {
                
                var achievementID = lookupAchievement.0
                GCHandler.resetOneAchievement(achievementIdentifier: achievementID, completion: {
                    (isReset) -> Void in
                    if !isReset {
                        
                        if completion != nil {
                            completion!(achievementReset:lookupAchievement.1)
                        }
                    }
                })
                
            }
        }
        
    }
    
    
    /*_______________________________ Internet _______________________________________________*/
    /**
    CheckUp Connection the new
    
    :returns: Bool Connection Validation
    */
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    /*_______________________________ Internal Delagate _______________________________________________*/
    /**
    Dismiss Game Center when player open
    :param: GKGameCenterViewController
    
    Override of GKGameCenterControllerDelegate
    */
    internal func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}