//
//  SceneDelegate.swift
//  Arculars
//
//  Created by Roman Blum on 18/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

protocol SceneDelegate : class {
    
    func startGame(gameType: GameMode)
    
    func showMenu()
    func showGameover(gameType: GameMode)
    
    func showAbout()
    func showHelp()
    func showGamecenter()
    func showStatistics()
    func showSettings()
    
    func shareOnOther()
    func shareOnTwitter()
    func shareOnFacebook()
    func shareOnWhatsApp()
}
