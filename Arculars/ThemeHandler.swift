//
//  ThemeHandler.swift
//  Arculars
//
//  Created by Roman Blum on 19/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

class ThemeHandler {
    
    var darkColors : Colors
    var lightColors : Colors
    
    static let Instance = ThemeHandler()
    private init() {
        darkColors = Colors()
        darkColors.ScoreColor = Colors.ScoreColor
        darkColors.BackgroundColor = Colors.BackgroundColor
        darkColors.FontColor = Colors.FontColor
        darkColors.DisabledColor = Colors.DisabledColor
        darkColors.AppColorOne = Colors.AppColorOne
        darkColors.AppColorTwo = Colors.AppColorTwo
        darkColors.AppColorThree = Colors.AppColorThree
        darkColors.AppColorFour = Colors.AppColorFour
        darkColors.PowerupColor = Colors.PowerupColor
        
        lightColors = Colors()
        lightColors.ScoreColor = Colors.ScoreColor
        lightColors.BackgroundColor = Colors.FontColor
        lightColors.FontColor = Colors.BackgroundColor
        lightColors.DisabledColor = Colors.DisabledColor
        lightColors.AppColorOne = Colors.AppColorOne
        lightColors.AppColorTwo = Colors.AppColorTwo
        lightColors.AppColorThree = Colors.AppColorThree
        lightColors.AppColorFour = Colors.AppColorFour
        lightColors.PowerupColor = Colors.PowerupColor
    }
    
    func getCurrentColors() -> Colors {
        switch SettingsHandler.getTheme() {
        case .Dark:
            return darkColors
        case .Light:
            return lightColors
        }
    }
}