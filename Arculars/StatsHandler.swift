//
//  StatsHandler.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit

let GAME_HIGHSCORE_ENDLESS              = "game_highscore_endless"
let GAME_HIGHSCORE_TIMED                = "game_highscore_timed"
let GAME_LASTSCORE_ENDLESS              = "game_lastscore_endless"
let GAME_LASTSCORE_TIMED                = "game_lastscore_timed"

let STATS_PLAYEDTIME                    = "stats_playedtime"
let STATS_FIREDBALLS                    = "stats_firedballs"
let STATS_OVERALLPOINTS                 = "stats_overallpoints"

let STATS_HITS                          = "stats_hits"
let STATS_FAILS                         = "stats_fails"


class StatsHandler {
    
    class func getHighscore(gameMode: GameMode) -> Int {
        switch gameMode {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_HIGHSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_HIGHSCORE_TIMED)
        }
    }
    
    class func getLastscore(gameMode: GameMode) -> Int {
        switch gameMode {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_LASTSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_LASTSCORE_TIMED)
        }
    }
    
    class func getPlayedTime() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_PLAYEDTIME)
    }
    
    class func getFiredBalls() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_FIREDBALLS)
    }
    
    class func getOverallPoints() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_OVERALLPOINTS)
    }
    
    class func getHits() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS)
    }
    
    class func getFails() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS)
    }
    
    class func updateHighscore(score: Int, gameMode: GameMode) {
        var highscore = StatsHandler.getHighscore(gameMode)
        if score <= highscore {
            return
        }
        
        switch gameMode {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_HIGHSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_HIGHSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        }
    }
    
    class func updateLastscore(score: Int, gameMode: GameMode) {
        switch gameMode {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_LASTSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_LASTSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        }
    }
    
    class func updatePlayedTimeBy(delta: Int) {
        var time = getPlayedTime()
        NSUserDefaults.standardUserDefaults().setInteger(time + delta, forKey: STATS_PLAYEDTIME)
    }
    
    class func updateFiredBallsBy(delta: Int) {
        var moves = getFiredBalls()
        NSUserDefaults.standardUserDefaults().setInteger(moves + delta, forKey: STATS_FIREDBALLS)
    }
    
    class func updateOverallPointsBy(delta: Int) {
        if (delta < 0) { return }
        
        var points = getOverallPoints()
        NSUserDefaults.standardUserDefaults().setInteger(points + delta, forKey: STATS_OVERALLPOINTS)
    }
    
    class func updateHitsBy(delta: Int) {
        var current = getHits()
        NSUserDefaults.standardUserDefaults().setInteger(current + delta, forKey: STATS_HITS)
    }
    
    class func incrementFails() {
        var current = getFails()
        NSUserDefaults.standardUserDefaults().setInteger(current + 1, forKey: STATS_FAILS)
    }
    
    class func reset() {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_TIMED)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_LASTSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_TIMED)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_PLAYEDTIME)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FIREDBALLS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_OVERALLPOINTS)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_HITS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FAILS)
    }
}