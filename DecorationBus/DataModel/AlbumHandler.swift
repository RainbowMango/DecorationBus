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
    
    /*
    保存图片到沙盒
    */
    func saveImageToSandbox(albumName: String, image: UIImage) ->Bool {
        var docPath = getDocumentDirectory()
        var imageName = "album_\(albumName)_\(makeUniqueID()).png"
        var imageURL = docPath.stringByAppendingPathComponent(imageName)
        
        UIImagePNGRepresentation(image).writeToFile(imageURL, atomically: true)
        println(imageURL)
        return true
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