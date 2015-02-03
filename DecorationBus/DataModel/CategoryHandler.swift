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
    var defaultIcon : String = "Unknow"
    
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
    
    /*读取主类别列表*/
    func getPrimeCategory() -> Array<String> {
        var result = Array<String>()
        var plistPath = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        var plistArry = NSArray(contentsOfFile: plistPath!)
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            var prime = entry["PrimeDesc"] as String
            result.append(prime)
        }
        
        return result
    }
    
    /*读取子类别列表*/
    func getPrimeCategory(primeCategory: String) -> Array<String> {
        var result = Array<String>()
        var plistPath = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        var plistArry = NSArray(contentsOfFile: plistPath!)
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            var prime = entry["PrimeDesc"] as String
            if primeCategory == prime {
                return entry["MinorDesc"] as Array<String>
            }
            
        }
        
        return result
    }
    
    /*
    读取主类别图标,读取不到则返回默认图标
    */
    func getIcon(primeCategory: String) -> String {
        var plistPath = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        var plistArry = NSArray(contentsOfFile: plistPath!)
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            if primeCategory == entry["PrimeDesc"] as String {
                return entry["PrimeIcon"] as String
            }
        }
        
        return defaultIcon
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
    
    /*删除主类别*/
    func removePrimeCategory(category: String) -> Bool {
        var plistPath = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        var plistArry = NSMutableArray(contentsOfFile: plistPath!)
        assert(plistArry != nil, "获取类别列表失败")
        
        for (index, entry) in enumerate(plistArry!) {
            if category == entry["PrimeDesc"] as String {
                plistArry!.removeObjectAtIndex(index)
                break
            }
        }
        
        var sandboxPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array<NSString>
        assert(sandboxPaths.count > 0, "获取沙盒目录失败")
        var sandboxPath = sandboxPaths[0]
        var fileName = sandboxPath.stringByAppendingPathComponent("\(resourceFile).plist")
        
        var rc = plistArry!.writeToFile(fileName, atomically: true)
        assert(rc, "写文件失败")
        return rc
    }
    
    /*
    新增子类别
    */
    func addMinorCategory(primeCategory: String, minorCategory: String) -> Bool {
        return true
    }
    
    /*获取document目录*/
    func getDocumentDirectory() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array<String>
        assert(directories.count > 0, "获取document目录失败")
        return directories[0]
    }
    
    // MARK: -- 沙盒文件处理
    
    /*拷贝resource文件到沙箱，如沙箱内已存在则忽略*/
    func copyFileToSandbox() -> Bool {
        let srcFile = getBundleFile()
        let dstFile = getSandboxFile()
        
        if(NSFileManager().fileExistsAtPath(dstFile)) {
            return true
        }
        
        var error: NSError?
        var rc = NSFileManager().copyItemAtPath(srcFile, toPath: dstFile, error: &error)
        assert(rc, "拷贝列表文件失败")
        
        return true
    }
    
    /*获取bundle目录中plist文件*/
    func getBundleFile() -> String {
        let file = NSBundle.mainBundle().pathForResource(resourceFile, ofType: resourceType)
        assert(file != nil, "bundle文件读取失败")
        
        return file!
    }
    
    /*获取document目录中plist文件*/
    func getSandboxFile() -> String {
        var docPath = getDocumentDirectory()
        docPath.stringByAppendingPathComponent("\(resourceFile).plist")
        
        return docPath
    }
}