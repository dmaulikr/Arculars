//
//  Color.swift
//  Arculars
//
//  Created by Roman Blum on 10/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

class Colors {
    
    static let ScoreColor       = UIColor(rgba: "#283233")
    static let FontColor        = UIColor(rgba: "#F0F0F0")
    static let DisabledColor    = UIColor.grayColor()
    static let BackgroundColor  = UIColor(rgba: "#121F21")
    static let AppColorOne      = UIColor(rgba: "#6D21CD")
    static let AppColorTwo      = UIColor(rgba: "#E022BF")
    static let AppColorThree    = UIColor(rgba: "#39E0BA")
    static let AppColorFour     = UIColor(rgba: "#2DFB7D")
    static let PowerupColor     = UIColor(rgba: "#FCDA0A")
    
    var ScoreColor : UIColor!
    var BackgroundColor : UIColor!
    var FontColor : UIColor!
    var DisabledColor : UIColor!
    var AppColorOne : UIColor!
    var AppColorTwo : UIColor!
    var AppColorThree : UIColor!
    var AppColorFour : UIColor!
    var PowerupColor : UIColor!
    
    init() {
        
    }
    
    func randomAppColor() -> UIColor {
        var appColors = [AppColorOne, AppColorTwo, AppColorThree, AppColorFour]
        var random = Int(arc4random_uniform(UInt32(appColors.count)));
        var color = appColors[random]
        return color
    }
}