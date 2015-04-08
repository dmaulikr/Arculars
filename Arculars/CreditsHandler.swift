//
//  CreditsHandler.swift
//  Arculars
//
//  Created by Roman Blum on 08/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

let ARCULARS_CREDITS                = "arculars_credits"

class CreditsHandler {
    class func getCredits() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(ARCULARS_CREDITS)
    }
    
    class func depositCredits(credits: Int) -> Bool {
        if (credits > 0) {
            var current = getCredits()
            NSUserDefaults.standardUserDefaults().setInteger(current + credits, forKey: ARCULARS_CREDITS)
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
    
    class func withdrawCredits(credits: Int) -> Bool {
        var current = getCredits()
        if (credits > 0 && current >= credits) {
            NSUserDefaults.standardUserDefaults().setInteger(current - credits, forKey: ARCULARS_CREDITS)
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
}