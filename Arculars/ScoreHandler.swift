//
//  ScoreHandler.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

class ScoreHandler {
    
    class func setHighscore(score: Int, gameType: GameType) {
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "game_highscore_endless")
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "game_highscore_timed")
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func getHighscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey("game_highscore_endless")
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey("game_highscore_timed")
        default:
            return -1
        }
    }
    
    class func setLastscore(score: Int, gameType: GameType) {
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "game_lastscore_endless")
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "game_lastscore_timed")
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func getLastscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey("game_lastscore_endless")
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey("game_lastscore_timed")
        default:
            return -1
        }
    }
}