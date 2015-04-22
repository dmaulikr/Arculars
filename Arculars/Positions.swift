//
//  Positions.swift
//  Arculars
//
//  Created by Roman Blum on 16/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Positions {
    
    class func randomPoint(frame: CGSize) -> CGPoint {
        // x coordinate between MinX (left) and MaxX (right):
        let randomX = randomInRange(-Int(frame.width / 2), hi: Int(frame.width / 2))
        // y coordinate between MinY (top) and MidY (middle):
        let randomY = randomInRange(-Int(frame.height / 2), hi: Int(frame.height / 2))
        return CGPoint(x: randomX, y: randomY)
    }
    
    class func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    class func getBottomPosition(size: CGSize) -> CGPoint {
        if PurchaseHandler.hasRemovedAds() {
            return CGPoint(x: 0, y: -(size.height / 2) + (size.height / 12))
        }
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        {
            return CGPoint(x: 0, y: -(size.height / 2) + 90 + (size.height / 20))
        }
        return CGPoint(x: 0, y: -(size.height / 2) + 50 + (size.height / 20))
    }
}