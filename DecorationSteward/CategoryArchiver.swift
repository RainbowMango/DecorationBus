//
//  CategoryArchiver.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-22.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class CategoryArchiver {
    var userDefault: NSUserDefaults = NSUserDefaults()
    var userDefaultKey: String = "categoryDic"
    
    // 序列化获取category dictionary
    func getCategoryFromUserDefault() -> Dictionary<String, Array<String>> {
        
        println(userDefault)
        var encodedOrders: NSData? = userDefault.objectForKey(userDefaultKey) as? NSData
        if nil == encodedOrders {
            return Dictionary<String, Array<String>>()
        }
        
        var category = NSKeyedUnarchiver.unarchiveObjectWithData(encodedOrders!) as Dictionary<String, Array<String>>
        println("getCategoryFromUserDefault() count = \(category.count)")
        
        return category
    }
    
    // 序列化存储category dictionary
    func saveCategoryToUserDefault(category: Dictionary<String, Array<String>>) -> Void {
        var archivedOrders = NSKeyedArchiver.archivedDataWithRootObject(category)
        userDefault.setObject(archivedOrders, forKey: userDefaultKey)
        userDefault.synchronize()
        println("saveCategoryToUserDefault() count = \(category.count)")
    }
}
