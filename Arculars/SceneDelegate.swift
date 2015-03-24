//
//  SceneDelegate.swift
//  Arculars
//
//  Created by Roman Blum on 18/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

protocol SceneDelegate {
    
    func startGame()
    
    func showMenuScene()
    func showStatsScene()
    func showSettingsScene()
    func showGameoverScene()
    
    func presentGameCenter()
    
    func shareOnOther()
    func shareOnTwitter()
    func shareOnFacebook()
    func shareOnWhatsApp()
}
