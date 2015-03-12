//
//  Circle.swift
//  Arculars
//
//  Created by Roman Blum on 09/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import UIKit
import SpriteKit

class Circle {
    let color : SKColor
    let radius : CGFloat
    let thickness : CGFloat
    let clockwise : Bool
    
    init(color: SKColor, radius: CGFloat, thickness: CGFloat, clockwise: Bool) {
        self.color = color;
        self.radius = radius;
        self.thickness = thickness;
        self.clockwise = clockwise;
    }
}