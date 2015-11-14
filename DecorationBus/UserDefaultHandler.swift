//
//  UserDefaultHandler.swift
//  DecorationBus
//
//  Created by ruby on 15/11/7.
//  Copyright © 2015年 ruby. All rights reserved.
//

import Foundation

class UserDefaultHandler {
    var userDefaults: NSUserDefaults
    
    init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    func getStringConf(key: String) -> String? {
        return userDefaults.stringForKey(key)
    }
    
    func setStringConf(key: String, value: String) -> Void {
        userDefaults.setValue(value, forKey: key)
    }
}

