//
//  SandboxHandler.swift
//  DecorationBus
//
//  Created by ruby on 15/10/17.
//  Copyright © 2015年 ruby. All rights reserved.
//

import Foundation
import UIKit

/*
沙盒目录结构
/Documents: 保存应用程序的重要数据文件和用户数据文件等。iTunes 同步时会备份该目录。
/Library/Caches: 保存应用程序使用时产生的支持文件和缓存文件，还有日志文件最好也放在这个目录。iTunes 同步时不会备份该目录。
/Library/Preferences: 保存应用程序的偏好设置文件（使用 NSUserDefaults 类设置时创建，不应该手动创建）。
/tmp: 保存应用运行时所需要的临时数据，iphone 重启时，会清除该目录下所有文件。
*/
class SandboxHandler: NSObject {
    
    /*获取document目录*/
    func getDocumentDirectory() -> String {
        let docDirs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return docDirs[0]
    }
    
    /*获取Library目录*/
    func getLibraryDirectory() -> String {
        let libDirs = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        
        return libDirs[0]
    }
    
    /*获取Caches目录*/
    func getCachesDirectory() -> String {
        let cachesDirs = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        
        return cachesDirs[0]
    }
    
    /*获取/tmp目录*/
    func getTmpDirectory() -> String {
        return NSTemporaryDirectory()
    }
    
    //创建目录
    func createDirectory(path: String) -> Bool {
        let fileManager = NSFileManager()
        
        if(fileManager.fileExistsAtPath(path)) {
            return true
        }
        
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError {
            print("创建沙盒目录\(path)失败: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}