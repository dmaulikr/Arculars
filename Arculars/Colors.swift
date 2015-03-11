//
//  Color.swift
//  Arculars
//
//  Created by Roman Blum on 10/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit

struct Colors {
    static var LightBackground : UIColor = UIColor(rgba: "#F8F8F8")
    static var LightBlue : UIColor = UIColor(rgba: "#4A90E2")
    static var LightOrange : UIColor = UIColor(rgba: "#F5A623")
    static var LightRed : UIColor = UIColor(rgba: "#FF5460")
    
    static func getAll() -> [UIColor] {
        let colors = [
            LightBackground,
            LightBlue,
            LightOrange,
            LightRed
        ]
        
        return colors
    }
    
    static func random() -> UIColor {
        var colors = getAll()
        var random = Int(arc4random_uniform(UInt32(colors.count))) + 1;
        return colors[random]
    }
}