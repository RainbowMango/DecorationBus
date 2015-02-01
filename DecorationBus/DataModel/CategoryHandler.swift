//
//  CategoryHandler.swift
//  DecorationBus
//
//  Created by ruby on 15-2-1.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation

class CategoryHandler: NSObject {
    var resourceFile: String = "Category"
    var resourceType: String = "plist"
    
    /*读取类别名列表*/
    func getList() -> Dictionary<String, Array<String>> {
        var result = Dictionary<String, Array<String>>()
        var plistPath = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        var plistArry = NSArray(contentsOfFile: plistPath!)
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            var prime = entry["PrimeDesc"] as String
            var minorArray = entry["MinorDesc"] as Array<String>
            result[prime] = minorArray
        }
        
        return result
    }
    
    /*
    读取主类别图标,读取不到则返回空值
    */
    func getIcon(primeCategory: String) -> String {
        return String()
    }
    
    /*
    读取主类别图标列表
    */
    func getIconList() -> Dictionary<String, String> {
        return Dictionary<String, String>()
    }
    
    /*
    新增主类别
    */
    func addPrimeCategory(category: String) -> Bool {
        return true
    }
    
    /*
    新增子类别
    */
    func addMinorCategory(primeCategory: String, minorCategory: String) -> Bool {
        return true
    }
}