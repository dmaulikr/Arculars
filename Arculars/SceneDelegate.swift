//
//  SceneDelegate.swift
//  Arculars
//
//  Created by Roman Blum on 18/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

protocol SceneDelegate {
    
    func startEndlessGame()
    func startTimedGame()
    
    func showMenuScene()
    func showStatsScene()
    func showGameoverScene()
    
    func presentGameCenter()
    
    func shareOnOther()
    func shareOnTwitter()
    func shareOnFacebook()
    func shareOnWhatsApp()
}
