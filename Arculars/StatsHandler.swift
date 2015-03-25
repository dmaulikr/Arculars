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

let STATS_FAILS_APPCOLORONE             = "stats_fails_appcolorone"
let STATS_FAILS_APPCOLORTWO             = "stats_fails_appcolortwo"
let STATS_FAILS_APPCOLORTHREE           = "stats_fails_appcolorthree"
let STATS_FAILS_APPCOLORFOUR            = "stats_fails_appcolorfour"

let STATS_HITS_APPCOLORONE              = "stats_hits_appcolorone"
let STATS_HITS_APPCOLORTWO              = "stats_hits_appcolortwo"
let STATS_HITS_APPCOLORTHREE            = "stats_hits_appcolorthree"
let STATS_HITS_APPCOLORFOUR             = "stats_hits_appcolorfour"

class StatsHandler {
    
    class func getHighscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_HIGHSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_HIGHSCORE_TIMED)
        default:
            return -1
        }
    }
    
    class func getLastscore(gameType: GameType) -> Int {
        switch gameType {
        case .Endless:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_LASTSCORE_ENDLESS)
        case .Timed:
            return NSUserDefaults.standardUserDefaults().integerForKey(GAME_LASTSCORE_TIMED)
        default:
            return -1
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
        var one = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORONE)
        var two = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORTWO)
        var three = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORTHREE)
        var four = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORFOUR)
        
        return one + two + three + four
    }
    
    class func getFails() -> Int {
        var one = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORONE)
        var two = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORTWO)
        var three = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORTHREE)
        var four = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORFOUR)
        
        return one + two + three + four
    }
    
    class func updateHighscore(score: Int, gameType: GameType) {
        var highscore = StatsHandler.getHighscore(Globals.currentGameType)
        if score <= highscore {
            return
        }
        
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_HIGHSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_HIGHSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func updateLastscore(score: Int, gameType: GameType) {
        switch gameType {
        case .Endless:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_LASTSCORE_ENDLESS)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        case .Timed:
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: GAME_LASTSCORE_TIMED)
            NSUserDefaults.standardUserDefaults().synchronize()
            break
        default:
            return
        }
    }
    
    class func updatePlayedTimeBy(delta: Int) {
        var time = NSUserDefaults.standardUserDefaults().integerForKey(STATS_PLAYEDTIME)
        NSUserDefaults.standardUserDefaults().setInteger(time + delta, forKey: STATS_PLAYEDTIME)
    }
    
    class func updateFiredBallsBy(delta: Int) {
        var moves = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FIREDBALLS)
        NSUserDefaults.standardUserDefaults().setInteger(moves + delta, forKey: STATS_FIREDBALLS)
    }
    
    class func updateOverallPointsBy(delta: Int) {
        var points = NSUserDefaults.standardUserDefaults().integerForKey(STATS_OVERALLPOINTS)
        NSUserDefaults.standardUserDefaults().setInteger(points + delta, forKey: STATS_OVERALLPOINTS)
    }
    
    class func updateHitsBy(colors: [UIColor]) {
        for color in colors {
            switch color {
            case Colors.AppColorOne:
                var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORONE)
                NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_HITS_APPCOLORONE)
                break
            case Colors.AppColorTwo:
                var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORTWO)
                NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_HITS_APPCOLORTWO)
                break
            case Colors.AppColorThree:
                var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORTHREE)
                NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_HITS_APPCOLORTHREE)
                break
            case Colors.AppColorFour:
                var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_HITS_APPCOLORFOUR)
                NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_HITS_APPCOLORFOUR)
                break
            default:
                return
            }
        }
    }
    
    class func updateFailBy(color: UIColor) {
        switch color {
        case Colors.AppColorOne:
            var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORONE)
            NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_FAILS_APPCOLORONE)
            break
        case Colors.AppColorTwo:
            var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORTWO)
            NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_FAILS_APPCOLORTWO)
            break
        case Colors.AppColorThree:
            var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORTHREE)
            NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_FAILS_APPCOLORTHREE)
            break
        case Colors.AppColorFour:
            var count = NSUserDefaults.standardUserDefaults().integerForKey(STATS_FAILS_APPCOLORFOUR)
            NSUserDefaults.standardUserDefaults().setInteger(++count, forKey: STATS_FAILS_APPCOLORFOUR)
            break
        default:
            return
        }
    }
    
    class func reset() {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_HIGHSCORE_TIMED)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_LASTSCORE_ENDLESS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: GAME_LASTSCORE_TIMED)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_PLAYEDTIME)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FIREDBALLS)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_OVERALLPOINTS)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_HITS_APPCOLORONE)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_HITS_APPCOLORTWO)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_HITS_APPCOLORTHREE)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_HITS_APPCOLORFOUR)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FAILS_APPCOLORONE)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FAILS_APPCOLORTWO)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FAILS_APPCOLORTHREE)
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: STATS_FAILS_APPCOLORFOUR)
    }
}