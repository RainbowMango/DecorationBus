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
        
        UIImageJPEGRepresentation(image, 0.01)!.writeToFile(imageURL, atomically: true)
        
        if !albumExist(albumName) {
            createAlbum(albumName)
        }
        addImageURLToPlist(albumName, imageURL: imageURL)
        
        return true
    }
    
    /*
    删除图片
    */
    func removeImageFromSandbox(albumName: String, imageURL: String) -> Bool {
        removeImageFromPlist(albumName, imageURL: imageURL)
        
        let defFileManager = NSFileManager.defaultManager()
        assert(defFileManager.fileExistsAtPath(imageURL), "文件不存在：\(imageURL)")
        
        do {
            try defFileManager.removeItemAtPath(imageURL)
        } catch _ {
            print("文件删除失败：\(imageURL)")
            return false
        }
        
        return true
    }
    
    /*将图片URL添加到plist文件，前提是相册已经存在*/
    func addImageURLToPlist(albumName: String, imageURL: String) -> Bool {
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取相册列表失败")
        
        for (index, entry) in (plistArry!).enumerate() {
            if albumName == entry["AlbumName"] as! String {
                (entry["ImageList"] as! NSMutableArray).addObject(imageURL)
                break
            }
        }
        
        let rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
    }
    
    /*
    将图片URL从plist文件中删除
    */
    func removeImageFromPlist(albumName: String, imageURL: String) -> Bool {
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取相册列表失败")
        
        for (index, entry) in (plistArry!).enumerate() {
            if albumName == entry["AlbumName"] as! String {
                (entry["ImageList"] as! NSMutableArray).removeObject(imageURL)
                break
            }
        }
        
        let rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
        return rc
        
    }
    
    /*取得相册中照片数量*/
    func getImageNumber(albumName: String) -> Int {
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取相册列表失败")
        
        for (index, entry) in (plistArry!).enumerate() {
            if albumName == entry["AlbumName"] as! String {
                return (entry["ImageList"] as! NSMutableArray).count
            }
        }
        
        return 0
    }
    
    /*取得相册中图片URL列表*/
    func getURLList(albumName: String) -> Array<String> {
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取相册列表失败")
        
        for (index, entry) in (plistArry!).enumerate() {
            if albumName == entry["AlbumName"] as! String {
                let originURLs = entry["ImageList"] as! Array<String>
                
                /*
                开发环境中每次编译都会生成唯一的ApplicationID,导致图片URL链接失效，为了方便开发添加过滤条件
                /Users/ruby/Library/Developer/CoreSimulator/Devices/1176A972-4E01-445B-B567-5F2E73BC5DEE/data/Containers/Data/Application/FC090F7E-B48F-4DB3-85DC-F3DEFC423864/Documents/album_素颜_20150412105921597.png
                */
                var finalURLs = Array<String>()
                for item in originURLs {
                    if(NSFileManager().fileExistsAtPath(item)) {
                        finalURLs.append(item)
                    }
                }
                
                return finalURLs
            }
        }
        
        return Array<String>()
    }
    
    /*创建相册*/
    func createAlbum(albumName: String) ->Void {
        let plistFile = getSandboxFile()
        let plistArry = NSMutableArray(contentsOfFile: plistFile)
        assert(plistArry != nil, "获取相册列表失败")
        
        let newItem = NSMutableDictionary()
        newItem.setObject(albumName, forKey: "AlbumName")
        newItem.setObject(Array<String>(), forKey: "ImageList")
        
        plistArry!.addObject(newItem)
        
        let rc = plistArry!.writeToFile(plistFile, atomically: true)
        assert(rc, "写文件失败")
    }
    
    /*判断相册是否建立*/
    func albumExist(albumName: String) -> Bool {
        let plistArry = NSArray(contentsOfFile: getSandboxFile())
        assert(plistArry != nil, "获取相册列表失败")
        
        for entry in plistArry! {
            if albumName == entry["AlbumName"] as! String {
                return true
            }
        }
        
        return false
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
        let file = docPath.stringByAppendingPathComponent("\(resourceFile).plist")
        
        return file
    }
    
    
    /*
    根据当前时间(精确到毫秒)生成唯一标示
    */
    func makeUniqueID() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let date          = NSDate()
        
        return dateFormatter.stringFromDate(date)
    }
    
    /*获取document目录*/
    func getDocumentDirectory() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) 
        assert(directories.count > 0, "获取document目录失败")
        return directories[0]
    }
}