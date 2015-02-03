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
        var plistArry = NSArray(contentsOfFile: getSandboxFile())
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
        var plistArry = NSArray(contentsOfFile: getSandboxFile())
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            var prime = entry["PrimeDesc"] as String
            result.append(prime)
        }
        
        return result
    }
    
    /*读取子类别列表*/
    func getMinorCategory(primeCategory: String) -> Array<String> {
        var result = Array<String>()
        var plistArry = NSArray(contentsOfFile: getSandboxFile())
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
        var plistArry = NSArray(contentsOfFile: getSandboxFile())
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
        var plistFile = getSandboxFile()
        var plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取类别列表失败")
        
        var newItem = NSMutableDictionary()
        newItem.setObject(category, forKey: "PrimeDesc")
        newItem.setObject("Unknow", forKey: "PrimeIcon")
        newItem.setObject(Array<String>(), forKey: "MinorDesc")
        
        plistArry!.addObject(newItem)
        
        var rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
    }
    
    /*删除主类别*/
    func removePrimeCategory(category: String) -> Bool {
        var plistFile = getSandboxFile()
        var plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取类别列表失败")
        
        for (index, entry) in enumerate(plistArry!) {
            if category == entry["PrimeDesc"] as String {
                plistArry!.removeObjectAtIndex(index)
                break
            }
        }
        
        var rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
    }
    
    /*
    新增子类别
    */
    func addMinorCategory(primeCategory: String, minorCategory: String) -> Bool {
        var plistFile = getSandboxFile()
        var plistArry = NSMutableArray(contentsOfFile: plistFile)
        var modifyItem: NSMutableDictionary!
        assert(plistArry != nil, "获取类别列表失败")
        
        for (index, entry) in enumerate(plistArry!) {
            if primeCategory == entry["PrimeDesc"] as String {
                modifyItem = plistArry![index] as NSMutableDictionary
                plistArry!.removeObjectAtIndex(index)
                break
            }
        }
        
        var minorList = modifyItem["MinorDesc"] as Array<String>
        minorList.append(minorCategory)
        
        modifyItem.setObject(minorList, forKey: "MinorDesc")
        plistArry!.addObject(modifyItem)
        
        var rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
    }
    
    /*
    删除子类别
    */
    func removeMinorCategory(primeCategory: String, minorCategory: String) -> Bool {
        var plistFile = getSandboxFile()
        var plistArry = NSMutableArray(contentsOfFile: plistFile)
        var modifyItem: NSMutableDictionary!
        assert(plistArry != nil, "获取类别列表失败")
        
        for (index, entry) in enumerate(plistArry!) {
            if primeCategory == entry["PrimeDesc"] as String {
                modifyItem = plistArry![index] as NSMutableDictionary
                plistArry!.removeObjectAtIndex(index)
                break
            }
        }
        
        var minorList = modifyItem["MinorDesc"] as Array<String>
        for (index, entry) in enumerate(minorList) {
            if entry == minorCategory {
                minorList.removeAtIndex(index)
                break
            }
        }
        
        modifyItem.setObject(minorList, forKey: "MinorDesc")
        plistArry!.addObject(modifyItem)
        
        var rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
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
        var file = docPath.stringByAppendingPathComponent("\(resourceFile).plist")
        
        return file
    }
    
    /*获取document目录*/
    func getDocumentDirectory() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array<String>
        assert(directories.count > 0, "获取document目录失败")
        return directories[0]
    }
}