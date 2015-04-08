//
//  ConfigHandler.swift
//  Arculars
//
//  Created by Roman Blum on 24/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

let SETTINGS_VIBRATION          = "settings_vibration"
let SETTINGS_SOUND              = "settings_sound"
let SETTINGS_DIFFICULTY         = "settings_difficulty"

class SettingsHandler {
    
    class func toggleVibration() -> Bool {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_VIBRATION)
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: SETTINGS_VIBRATION)
        NSUserDefaults.standardUserDefaults().synchronize()
        return !state
    }
    
    class func getVibrationSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_VIBRATION)
    }
    
    class func toggleSound() -> Bool {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_SOUND)
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: SETTINGS_SOUND)
        NSUserDefaults.standardUserDefaults().synchronize()
        return !state
    }
    
    class func getSoundSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_SOUND)
    }
    
    class func toggleDifficulty() {
        var difficulty = getDifficulty()
        switch difficulty {
        case .Easy:
            NSUserDefaults.standardUserDefaults().setInteger(Difficulty.Normal.rawValue, forKey: SETTINGS_DIFFICULTY)
            break
        case .Normal:
            NSUserDefaults.standardUserDefaults().setInteger(Difficulty.Hard.rawValue, forKey: SETTINGS_DIFFICULTY)
            break
        case .Hard:
            NSUserDefaults.standardUserDefaults().setInteger(Difficulty.Easy.rawValue, forKey: SETTINGS_DIFFICULTY)
            break
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func getDifficulty() -> Difficulty {
        var difficulty = NSUserDefaults.standardUserDefaults().integerForKey(SETTINGS_DIFFICULTY)
        if Difficulty(rawValue: difficulty) == nil {
            return Difficulty.Normal
        }
        return Difficulty(rawValue: difficulty)!
    }
}