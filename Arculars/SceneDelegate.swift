//
//  SceneDelegate.swift
//  Arculars
//
//  Created by Roman Blum on 18/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

protocol SceneDelegate : class {
    
    func showGameScene(gameType: GameMode)
    func showMenuScene()
    func showGameoverScene(gameType: GameMode)
    func showAboutScene()
    func showHelpScene()
    func showStatsScene()
    func showSettingsScene()
    
    func presentGameCenter()
    func presentRateOnAppStore()
    
    func shareScore(destination: String, score: Int, gameType: GameMode)
}
