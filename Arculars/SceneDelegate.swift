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
    func presentGameCenter()
    func showStatsScene()
    func showSettingsScene()
    
    func shareOnOther()
    func shareOnTwitter()
    func shareOnFacebook()
    func shareOnWhatsApp()
}
