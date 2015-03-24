//
//  ScoreHandler.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

let HIGHSCORE_ENDLESS = "game_highscore_endless"
let HIGHSCORE_TIMED = "game_highscore_timed"
let LASTSCORE_ENDLESS = "game_lastscore_endless"
let LASTSCORE_TIMED = "game_lastscore_timed"

class ScoreHandler {
    
    
    class func setHighscore(score: Int, gameType: GameType) {
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: HIGHSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: HIGHSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func getHighscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(HIGHSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(HIGHSCORE_TIMED)
        default:
            return -1
        }
    }
    
    class func setLastscore(score: Int, gameType: GameType) {
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: LASTSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: LASTSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func getLastscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(LASTSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(LASTSCORE_TIMED)
        default:
            return -1
        }
    }
}