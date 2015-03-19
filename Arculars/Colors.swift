//
//  Color.swift
//  Arculars
//
//  Created by Roman Blum on 10/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

struct Colors {
    static let FontColor : UIColor = UIColor(rgba: "#9B9B9B")
    static let Background : UIColor = UIColor(rgba: "#F3F3F3")
    
    static let LightBlue : UIColor = UIColor(rgba: "#CFE5FF")
    static let Blue : UIColor = UIColor(rgba: "#4A90E2")
    static let LightOrange : UIColor = UIColor(rgba: "#FFE9C5")
    static let Orange : UIColor = UIColor(rgba: "#F5A623")
    static let LightRed : UIColor = UIColor(rgba: "#FFD9DC")
    static let Red : UIColor = UIColor(rgba: "#FF5460")
    
    static let FacebookBlue : UIColor = UIColor(rgba: "#6274A5")
    static let TwitterBlue : UIColor = UIColor(rgba: "#6EC7E3")
    
    static func randomBallColor() -> UIColor {
        let colors = [
            Blue,
            Orange,
            Red
        ]
        var random = Int(arc4random_uniform(UInt32(colors.count)));
        return colors[random]
    }
}