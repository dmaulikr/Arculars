//
//  RateHandler.swift
//  Arculars
//
//  Created by Roman Blum on 13/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

let RATE_INTERVAL   = 50 // after played games
let RATE_DONTSHOWAGAIN = "rate_dontshowagain"

class RateHandler {
    
    class func checkIfRate(playedgames: Int) -> Bool {
        var dontshowagain = NSUserDefaults.standardUserDefaults().boolForKey(RATE_DONTSHOWAGAIN)
        if (playedgames % RATE_INTERVAL) == 0 && (!dontshowagain) {
            return true
        }
        return false
    }
    
    class func dontShowAgain() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: RATE_DONTSHOWAGAIN)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}