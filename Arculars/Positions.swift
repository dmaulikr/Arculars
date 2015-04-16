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
    class func getBottomPosition(size: CGSize) -> CGPoint {
        if PurchaseHandler.hasRemovedAds() {
            return CGPoint(x: 0, y: -(size.height / 2) + (size.height / 12))
        }
        return CGPoint(x: 0, y: -(size.height / 2) + (size.height / 8))
    }
}