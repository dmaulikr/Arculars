//
//  Difficulty.swift
//  Arculars
//
//  Created by Roman Blum on 28/03/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

enum Difficulty : Int, Printable {
    
    case Easy       = 1
    case Normal     = 2
    case Hard       = 3
    
    var description : String {
        switch self {
            case .Easy:    return "Easy"
            case .Normal:  return "Normal"
            case .Hard:    return "Hard"
        }
    }
}