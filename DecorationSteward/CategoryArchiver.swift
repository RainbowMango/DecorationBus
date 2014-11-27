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
        var encodedCategorys: NSData? = userDefault.objectForKey(userDefaultKey) as? NSData
        if nil == encodedCategorys {
            return Dictionary<String, Array<String>>()
        }
        
        var category = NSKeyedUnarchiver.unarchiveObjectWithData(encodedCategorys!) as Dictionary<String, Array<String>>
        println("getCategoryFromUserDefault() count = \(category.count)")
        
        return category
    }
    
    // 序列化存储category dictionary
    func saveCategoryToUserDefault(category: Dictionary<String, Array<String>>) -> Void {
        var archivedCategorys = NSKeyedArchiver.archivedDataWithRootObject(category)
        userDefault.setObject(archivedCategorys, forKey: userDefaultKey)
        userDefault.synchronize()
        println("saveCategoryToUserDefault() count = \(category.count)")
    }
    
    // 初始化类别表, 用于用户首次使用软件和用户选择初始化软件
    func initCategoryInUserDefault() -> Void {
        saveCategoryToUserDefault(CategoryDataModel().categoryDic)
    }
    
    // 根据大类获取响应子类
    func getMinorCategoryByPrime(prime: String) -> Array<String> {
        var categoryDic = getCategoryFromUserDefault()
        return categoryDic[prime]!
    }
    
    // 新增子类
    func addMinorCategory(prime: String, minor: String) -> Void {
        var categoryDic = getCategoryFromUserDefault()
        var minorCategoryArray = categoryDic[prime]!
        
        // 过滤重复数据
        if contains(minorCategoryArray, minor) {
            return
        }
        minorCategoryArray.append(minor)
        categoryDic.updateValue(minorCategoryArray, forKey: prime)
        saveCategoryToUserDefault(categoryDic)
    }
    
    // 删除子类
    func deleteMinorCategory(prime: String, minor: String) -> Void {
        var categoryDic = getCategoryFromUserDefault()
        var minorCategoryArray = categoryDic[prime]!
        
        for (index, value) in enumerate(minorCategoryArray) {
            if value == minor {
                minorCategoryArray.removeAtIndex(index)
                break
            }
        }
        categoryDic.updateValue(minorCategoryArray, forKey: prime)
        saveCategoryToUserDefault(categoryDic)
    }
    
    // 新增大类
    func addPrimeCategory(prime: String) -> Void {
        var categoryDic = getCategoryFromUserDefault()
        categoryDic[prime] = Array<String>()
        saveCategoryToUserDefault(categoryDic)
    }
}
