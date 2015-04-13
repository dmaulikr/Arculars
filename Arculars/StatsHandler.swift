//
//  StatsHandler.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

let GAME_HIGHSCORE_ENDLESS              = "game_highscore_endless"
let GAME_HIGHSCORE_TIMED                = "game_highscore_timed"

let GAME_LASTSCORE_ENDLESS              = "game_lastscore_endless"
let GAME_LASTSCORE_TIMED                = "game_lastscore_timed"

let STATS_PLAYEDTIME                    = "stats_playedtime"
let STATS_PLAYEDGAMES                   = "stats_playedgames"
let STATS_FIREDBALLS                    = "stats_firedballs"
let STATS_TOTALPOINTS                   = "stats_totalpoints"
let STATS_CORRECT_COLLISIONS            = "stats_correct_collisions"

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
    
    class func getPlayedGames() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_PLAYEDGAMES)
    }
    
    class func getPlayedTime() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_PLAYEDTIME)
    }
    
    class func getFiredBalls() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_FIREDBALLS)
    }
    
    class func getTotalPoints() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_TOTALPOINTS)
    }
    
    class func getCorrectCollisions() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(STATS_CORRECT_COLLISIONS)
    }
    
    class func getPrecision() -> Float {
        var firedballs = getFiredBalls()
        var cc = getCorrectCollisions()
        if (firedballs == 0) || (cc == 0) {
            return 0.0
        }
        var precision = (Float(cc) / Float(firedballs)) * 100
        return Float(precision)
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
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func updateFiredBallsBy(delta: Int) {
        var moves = getFiredBalls()
        NSUserDefaults.standardUserDefaults().setInteger(moves + delta, forKey: STATS_FIREDBALLS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func updateTotalPointsBy(delta: Int) {
        if (delta < 0) { return }
        
        var points = getTotalPoints()
        NSUserDefaults.standardUserDefaults().setInteger(points + delta, forKey: STATS_TOTALPOINTS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func updateCorrectCollisionsBy(delta: Int) {
        var current = getCorrectCollisions()
        NSUserDefaults.standardUserDefaults().setInteger(current + delta, forKey: STATS_CORRECT_COLLISIONS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func incrementPlayedGames() {
        var current = getPlayedGames()
        NSUserDefaults.standardUserDefaults().setInteger(current + 1, forKey: STATS_PLAYEDGAMES)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func reset() {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_TIMED)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_LASTSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_TIMED)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_PLAYEDGAMES)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_PLAYEDTIME)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FIREDBALLS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_TOTALPOINTS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_CORRECT_COLLISIONS)
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}