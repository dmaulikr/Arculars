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

class ConfigHandler {
    
    class func toggleVibration() -> Bool {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_VIBRATION)
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: SETTINGS_VIBRATION)
        return !state
    }
    
    class func getVibrationSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_VIBRATION)
    }
    
    class func toggleSound() -> Bool {
        var state = NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_SOUND)
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: SETTINGS_SOUND)
        return !state
    }
    
    class func getSoundSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(SETTINGS_SOUND)
    }
}