//
//  PowerupHandler.swift
//  Arculars
//
//  Created by Roman Blum on 06/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

enum PowerupType : Int, Printable {
    case None = 0
    case DoublePoints = 1
    case TriplePoints = 2
    case FullTime = 3 // Only in Timed Mode
    case FullLifes = 4 // Only in Endless Mode
    case Unicolor = 5
    case ExtraPoints10 = 6
    case ExtraPoints30 = 7
    case ExtraPoints50 = 8
    case ExtraPoints100 = 9
    
    var description : String {
        switch self {
        case .None:    return ""
        case .DoublePoints:  return "Double Points"
        case .TriplePoints:    return "Triple Points"
        case .FullTime:    return "Restore Time"
        case .FullLifes:    return "Restore Lifes"
        case .Unicolor:    return ""
        case .ExtraPoints10:    return ""
        case .ExtraPoints30:    return ""
        case .ExtraPoints50:    return ""
        case .ExtraPoints100:    return ""
        }
    }
}

class PowerupHandler {
    
    private var gameMode : GameMode!
    private var difficulty: Difficulty!
    private var random : UInt32 = 0
    private var interval : UInt32 = 0
    private var nextPowerup : Int!
    
    var currentPowerup : Powerup!
    
    private let PowerupsEndless : [PowerupType : UInt32] = [
        PowerupType.DoublePoints    : 3,
        PowerupType.TriplePoints    : 2,
        PowerupType.FullLifes       : 1,
        PowerupType.Unicolor        : 3,
        PowerupType.ExtraPoints10   : 4,
        PowerupType.ExtraPoints30   : 3,
        PowerupType.ExtraPoints50   : 2,
        PowerupType.ExtraPoints100  : 1
    ]
    
    private let PowerupsTimed : [PowerupType : UInt32] = [
        PowerupType.DoublePoints    : 3,
        PowerupType.TriplePoints    : 2,
        PowerupType.FullTime        : 1,
        PowerupType.Unicolor        : 3,
        PowerupType.ExtraPoints10   : 4,
        PowerupType.ExtraPoints30   : 3,
        PowerupType.ExtraPoints50   : 2,
        PowerupType.ExtraPoints100  : 1
    ]
    
    init(gameMode: GameMode, difficulty: Difficulty) {
        self.gameMode = gameMode
        
        switch difficulty {
        case .Easy:
            random = 30
            interval = 20
            break
        case .Normal:
            random = 30
            interval = 30
            break
        case .Hard:
            random = 30
            interval = 40
            break
        }
        
        updateScoreForNextPowerup(0)
    }
    
    private func updateScoreForNextPowerup(offset: Int) {
        self.nextPowerup = offset + Int(arc4random_uniform(random) + interval)
    }
    
    func checkForNewPowerup(score: Int) -> Bool {
        if currentPowerup != nil {
            updateScoreForNextPowerup(score)
            return false
        }
        
        if score > nextPowerup {
            updateScoreForNextPowerup(score)
            return true
        }
        return false
    }
    
    func randomPowerupType() -> PowerupType {
        var powerups : [PowerupType : UInt32]!
        if gameMode == GameMode.Endless { powerups = PowerupsEndless }
        else if gameMode == GameMode.Timed { powerups = PowerupsTimed }
        else { return PowerupType.None }
        
        var maxOccurence : UInt32 = 0
        for occurence in powerups.values {
            maxOccurence = maxOccurence + occurence
        }
        
        var current : UInt32 = 1
        var result : UInt32 = arc4random_uniform(maxOccurence) + 1
        for (powerupType, occurence) in powerups {
            if result >= current && result < (current + occurence) {
                return powerupType
            }
            current = current + occurence
        }
        return PowerupType.None
    }
}