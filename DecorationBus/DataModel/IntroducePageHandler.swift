//
//  IntroducePageHandler.swift
//  DecorationBus
//
//  Created by ruby on 15/6/18.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation
import UIKit

class IntroducePageHandler: NSObject {
    var resourceFile: String = "IntroducePage"
    var resourceType: String = "plist"
    
    // 设置引导页已展现标记
    func setIntroShown() -> Void {
        let curVersion = getCurrentVersion()
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取类别列表失败")
        
        let newItem = NSMutableDictionary()
        newItem.setObject(curVersion, forKey: "version")
        newItem.setObject(true, forKey: "shown")
        
        plistArry!.addObject(newItem)
        
        let rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
    }
    
    // 检查引导页是否已在当前版本展现
    func isIntroShown() -> Bool {
        copyFileToSandbox()
        
        let curVersion = getCurrentVersion()
        
        let plistArry = NSArray(contentsOfFile: getSandboxFile())
        assert(plistArry != nil, "获取类别列表失败")
        
        for entry in plistArry! {
            if curVersion == entry["version"] as! String {
                return entry["shown"] as! Bool
            }
        }
        
        return false
    }
    
    func getCurrentVersion() -> String {
        return IosAppVersion as String
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
        var rc: Bool
        do {
            try NSFileManager().copyItemAtPath(srcFile, toPath: dstFile)
            rc = true
        } catch let error1 as NSError {
            error = error1
            print(error?.userInfo)
            rc = false
        }
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
        let docPath = getDocumentDirectory()
        let file = NSURL(string: resourceFile + "." + resourceType, relativeToURL: docPath)
        
        return (file?.path!)!
    }
    
    /*获取document目录*/
    func getDocumentDirectory() -> NSURL {
        let directories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) 
        assert(directories.count > 0, "获取document目录失败")
        
        return NSURL(fileURLWithPath: directories[0], isDirectory: true)
    }
}
