//
//  AlbumHandler.swift
//  DecorationBus
//
//  Created by ruby on 15-3-24.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation
import UIKit

class AlbumHandler: NSObject {
    var resourceFile: String = "EverAlbum"
    var resourceType: String = "plist"
    
    /*
    保存图片到沙盒,同时加入到plist文件
    */
    func saveImageToSandbox(albumName: String, image: UIImage) ->Bool {
        var docPath = getDocumentDirectory()
        var imageName = "album_\(albumName)_\(makeUniqueID()).png"
        var imageURL = docPath.stringByAppendingPathComponent(imageName)
        
        UIImagePNGRepresentation(image).writeToFile(imageURL, atomically: true)
        println(imageURL)
        return true
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
    
    
    /*
    根据当前时间(精确到毫秒)生成唯一标示
    */
    func makeUniqueID() -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        var date          = NSDate()
        
        return dateFormatter.stringFromDate(date)
    }
    
    /*获取document目录*/
    func getDocumentDirectory() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as Array<String>
        assert(directories.count > 0, "获取document目录失败")
        return directories[0]
    }
}