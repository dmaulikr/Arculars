//
//  PhysicsCategory.swift
//  Arculars
//
//  Created by Roman Blum on 13/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

enum PhysicsCategory : UInt32 {
    case none       = 1
    case border     = 2
    case ball       = 4
    case arc        = 8
    case powerup    = 16
}