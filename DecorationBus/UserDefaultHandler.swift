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
        userDefaults.synchronize()
    }
    
    /*
    * 除数值类型不能存储外，其他类型都可以存储
    * 可存储类型：NSDate, NSArray, NSDictionary
    */
    func setObjectForKey(value: AnyObject?, key: String) -> Void {
        userDefaults.setObject(value, forKey: key)
        userDefaults.synchronize()
    }
    
    /*
    * 获取字典类型数据
    */
    func getDictionaryForKey(key: String) -> [String : AnyObject]? {
        return userDefaults.dictionaryForKey(key)
    }
}

