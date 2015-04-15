//
//  PurchaseHandler.swift
//  Arculars
//
//  Created by Roman Blum on 15/04/15.
//  Copyright (c) 2015 RMNBLM. All rights reserved.
//

import Foundation

class PurchaseHandler {
    
    static let HASREMOVEDADS = "hasRemovedAds"
    
    class func hasRemovedAds() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(HASREMOVEDADS)
    }
    
    class func removeAds() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: HASREMOVEDADS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func reset() {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: HASREMOVEDADS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}