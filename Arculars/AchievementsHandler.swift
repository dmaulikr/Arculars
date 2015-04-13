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
        if current >= 50 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.timed.50") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.50", showBannnerIfCompleted: true)
        }
        if current >= 200 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.timed.200") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.200", showBannnerIfCompleted: true)
        }
        if current >= 500 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.timed.500") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.500", showBannnerIfCompleted: true)
        }
        if current >= 1000 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.timed.1K") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.1K", showBannnerIfCompleted: true)
        }
        if current >= 5000 && !GCHandler.isAchievementCompleted(achievementIdentifier: "achievement.highscore.timed.5K") {
            GCHandler.reportAchievements(progress: 100.0, achievementIdentifier: "achievement.highscore.timed.5K", showBannnerIfCompleted: true)
        }
    }
    
    class func checkCollectedPowerups() {
        
    }
    
    class func checkPlayedGames() {
        
    }
    
    class func checkTotalScore() {
        
    }
    
    class func checkNoCollisions() {
        
    }
    
}