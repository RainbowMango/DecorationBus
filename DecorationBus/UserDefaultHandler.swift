//
//  UserDefaultHandler.swift
//  DecorationBus
//
//  Created by ruby on 15/11/7.
//  Copyright © 2015年 ruby. All rights reserved.
//

import Foundation

/*
* userDefault可存储类型：NSNumber（Integer、Float、Double）, NSString, NSDate, NSArray, NSDictionary, BOOL, NSURL
*/
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
    * 可存储类型：Int
    */
    func setIntForKey(value: Int, key: String) -> Void {
        userDefaults.setInteger(value, forKey: key)
        userDefaults.synchronize();
    }
    
    /*
    * 可存储类型：Float
    */
    func setFloatForKey(value: Float, key: String) -> Void {
        userDefaults.setFloat(value, forKey: key)
        userDefaults.synchronize()
    }
    
    /*
    * 可存储类型：Double
    */
    func setDoubleForKey(value: Double, key: String) -> Void {
        userDefaults.setDouble(value, forKey: key)
        userDefaults.synchronize()
    }
    
    /*
    * 可存储类型：Bool
    */
    func setBoolForKey(value: Bool, key: String) -> Void {
        userDefaults.setBool(value, forKey: key)
        userDefaults.synchronize()
    }
    
    /*
    * 除数值类型不能存储外，其他类型都可以存储
    * 可存储类型：NSString, NSDate, NSArray, NSDictionary
    */
    func setObjectForKey(value: AnyObject?, key: String) -> Void {
        userDefaults.setObject(value, forKey: key)
        userDefaults.synchronize()
    }
    
    /*
    * 获取整型数据
    */
    func getIntForKey(key: String) -> Int {
        return userDefaults.integerForKey(key)
    }
    
    /*
    * 获取浮点型数据
    */
    func getFloatForKey(key: String) -> Float {
        return userDefaults.floatForKey(key)
    }
    
    /*
    * 获取双精度浮点型数据
    */
    func getDoubleForKey(key: String) -> Double {
        return userDefaults.doubleForKey(key)
    }
    
    /*
    * 获取布尔型数据
    */
    func getBoolForKey(key: String) -> Bool {
        return userDefaults.boolForKey(key)
    }
    
    /*
    * 获取字典类型数据
    */
    func getDictionaryForKey(key: String) -> [String : AnyObject]? {
        return userDefaults.dictionaryForKey(key)
    }
    
    /*
    * 删除数据，使用于所有类型
    */
    func removeObjectForKey(key: String) -> Void {
        userDefaults.removeObjectForKey(key)
        userDefaults.synchronize()
    }
}

