//
//  Color.swift
//  Arculars
//
//  Created by Roman Blum on 10/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

struct Colors {
    static let FontColor        = UIColor(rgba: "#F0F0F0")
    static let Background       = UIColor(rgba: "#121F21")
    static let AppColorOne      = UIColor(rgba: "#6D21CD")
    static let AppColorTwo      = UIColor(rgba: "#E022BF")
    static let AppColorThree    = UIColor(rgba: "#39E0BA")
    static let AppColorFour     = UIColor(rgba: "#2DFB7D")
    
    static let WhatsAppGreen    = UIColor(rgba: "#71BA5B")
    static let FacebookBlue     = UIColor(rgba: "#6274A5")
    static let TwitterBlue      = UIColor(rgba: "#6EC7E3")
    static let SharingGray      = UIColor(rgba: "#6B838B")
    
    private static let ballColors = [
        AppColorOne,
        AppColorTwo,
        AppColorThree,
        AppColorFour
    ]
    
    static func getRandomBallColor() -> UIColor {
        var random = Int(arc4random_uniform(UInt32(ballColors.count)));
        var color = ballColors[random]
        return color
    }
}