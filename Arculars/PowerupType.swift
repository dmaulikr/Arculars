//
//  PowerupType.swift
//  Arculars
//
//  Created by Roman Blum on 12/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

enum PowerupType : Int, Printable {
    case None = 0
    case DoublePoints = 1
    case TriplePoints = 2
    case FullTime = 3 // Only in Timed Mode
    case FullLifes = 4 // Only in Endless Mode
    case Unicolor = 5
    case ExtraPoints10 = 6
    case ExtraPoints30 = 7
    case ExtraPoints50 = 8
    case ExtraPoints100 = 9
    
    var description : String {
        switch self {
        case .None:    return ""
        case .DoublePoints:  return "Double Points"
        case .TriplePoints:    return "Triple Points"
        case .FullTime:    return "Restore Time"
        case .FullLifes:    return "Restore Lifes"
        case .Unicolor:    return ""
        case .ExtraPoints10:    return ""
        case .ExtraPoints30:    return ""
        case .ExtraPoints50:    return ""
        case .ExtraPoints100:    return ""
        }
    }
}