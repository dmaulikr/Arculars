	//
//  AchievementsHandler.swift
//  Arculars
//
//  Created by Roman Blum on 13/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

class AchievementsHandler {
    
    class func checkHighscoreEndless() {
        var current = StatsHandler.getHighscore(GameMode.Endless)
        if current >= 50 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.endless.50") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.endless.50", showBannnerIfCompleted: true)
        }
        if current >= 200 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.endless.200") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.endless.200", showBannnerIfCompleted: true)
        }
        if current >= 500 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.endless.500") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.endless.500", showBannnerIfCompleted: true)
        }
        if current >= 1000 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.endless.1K") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.endless.1K", showBannnerIfCompleted: true)
        }
        if current >= 5000 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.endless.5K"){
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.endless.5K", showBannnerIfCompleted: true)
        }
    }
    
    class func checkHighscoreTimed() {
        var current = StatsHandler.getHighscore(GameMode.Timed)
        if current >= 50 {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.50", showBannnerIfCompleted: true)
        }
        if current >= 200 {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.200", showBannnerIfCompleted: true)
        }
        if current >= 500 {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.500", showBannnerIfCompleted: true)
        }
        if current >= 1000 {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.1K", showBannnerIfCompleted: true)
        }
        if current >= 5000 {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.5K", showBannnerIfCompleted: true)
        }
    }
    
    class func checkCollectedPowerups() {
        var current = Double(StatsHandler.getCollectedPowerups())
        
        GCHandler.reportAchievements(progress: ((current / 10) * 100), achievementIdentifier: "achievement.collectedpowerups.10", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 50) * 100), achievementIdentifier: "achievement.collectedpowerups.50", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 100) * 100), achievementIdentifier: "achievement.collectedpowerups.100", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 500) * 100), achievementIdentifier: "achievement.collectedpowerups.500", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 1000) * 100), achievementIdentifier: "achievement.collectedpowerups.1000", showBannnerIfCompleted: true)
    }
    
    class func checkPlayedGames() {
        var current = Double(StatsHandler.getPlayedGames())
        GCHandler.reportAchievements(progress: ((current / 10) * 100), achievementIdentifier: "achievement.playedgames.10", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 50) * 100), achievementIdentifier: "achievement.playedgames.50", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 100) * 100), achievementIdentifier: "achievement.playedgames.100", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 500) * 100), achievementIdentifier: "achievement.playedgames.500", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 1000) * 100), achievementIdentifier: "achievement.playedgames.1000", showBannnerIfCompleted: true)
    }
    
    class func checkTotalScore() {
        var current = Double(StatsHandler.getTotalPoints())
        GCHandler.reportAchievements(progress: ((current / 500) * 100), achievementIdentifier: "achievement.totalscore.500", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 1000) * 100), achievementIdentifier: "achievement.totalscore.1K", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 5000) * 100), achievementIdentifier: "achievement.totalscore.5K", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 20000) * 100), achievementIdentifier: "achievement.totalscore.20K", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 100000) * 100), achievementIdentifier: "achievement.totalscore.100K", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 250000) * 100), achievementIdentifier: "achievement.totalscore.250K", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 1000000) * 100), achievementIdentifier: "achievement.totalscore.1M", showBannnerIfCompleted: true)
    }
    
    class func checkNoCollisions() {
        var current = Double(StatsHandler.getNoCollisions())
        GCHandler.reportAchievements(progress: ((current / 1) * 100), achievementIdentifier: "achievement.nocollisions.1", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 10) * 100), achievementIdentifier: "achievement.nocollisions.10", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 50) * 100), achievementIdentifier: "achievement.nocollisions.50", showBannnerIfCompleted: true)
        GCHandler.reportAchievements(progress: ((current / 100) * 100), achievementIdentifier: "achievement.nocollisions.100", showBannnerIfCompleted: true)
    }
    
}