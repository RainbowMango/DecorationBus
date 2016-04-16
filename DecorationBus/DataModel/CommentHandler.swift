//
//  CommentHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/4/5.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

public enum CommentTargetType : Int {
    case TypeUnknown = 0
    case TypeCompany = 1
    case TypeArtist  = 2
    case TypeManager = 3
    case TypeWorker  = 4
}

class Comment {
    let MINIMUM_LENGTH_OF_TEXT_CONTENT = 15
    let MAXIMUM_LENGTH_OF_TEXT_CONTENT = 512
    
    var userID     : String
    var targetType : CommentTargetType
    var targetID   : UInt
    var textContent: String
    var imageArray : Array<ImageCollectionViewCellData>
    var itemScore  : Dictionary<String, Int>
    
    init() {
        userID      = String()
        textContent = String()
        targetType  = CommentTargetType.TypeUnknown
        targetID    = 0
        imageArray  = Array<ImageCollectionViewCellData>()
        itemScore   = Dictionary<String, Int>()
    }
    
    func validate() -> (valid: Bool, info: String) {
        var validResult = validateTextContent()
        if(!validResult.valid) {
            return validResult
        }
        
        validResult = validateScore()
        if(!validResult.valid) {
            return validResult
        }
        
        return (true, String())
    }
    
    private func validateTextContent() -> (valid: Bool, info: String) {
        if(self.textContent.characters.count < MINIMUM_LENGTH_OF_TEXT_CONTENT) {
            return (false, "写够15字才是好同志~")
        }
        
        if(self.textContent.characters.count > MAXIMUM_LENGTH_OF_TEXT_CONTENT) {
            let exceedCount = self.textContent.characters.count - MAXIMUM_LENGTH_OF_TEXT_CONTENT
            return (false, "亲，写的太多了，请删除\(exceedCount)个字")
        }
        
        return (true, String())
    }
    
    private func validateScore() -> (valid: Bool, info: String) {
        for (item, score) in itemScore {
            if(score == 0) {
                return (false, "您好像忘了给<\(item)>评分~")
            }
        }
        
        return (true, String())
    }
}

extension Comment {
    
    /**
     生成HTTP请求参数数据
     
     - returns: NSData
     */
    func makeParmDataForUserID() -> NSData {
        let user = String(userID)
        return user.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    /**
     生成评论对象类型，用于数据上传
     
     - returns: NSData
     */
    func makeParmDataForTargetType() -> NSData{
        let type = String(targetType.rawValue)
        return type.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    /**
     生成评论对象ID，用于数据上传
     
     - returns: NSData
     */
    func makeParmDataForTargetID() -> NSData {
        let id = String(targetID)
        return id.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    /**
     将单项评分字典转成JSON，用于数据上传
     
     - returns: NSData
     */
    func itemScoreParm() -> NSData {
        do {
            return try NSJSONSerialization.dataWithJSONObject(self.itemScore, options: .PrettyPrinted)
        }
        catch let error as NSError {
            showSimpleAlert(self, title: "您太幸运了", message: error.localizedDescription)
        }
        
        return NSData()
    }
    
    /**
     解析服务端返回的JSON数据
     
     - parameter jsonData: 服务端返回的数据
     
     - returns: status: 0-成功 1-失败  info: 错误信息
     */
    func parseResponsJSON(jsonData: NSData) -> (status: Int, info: String) {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let status  = jsonStr.objectForKey("status") as! Int
            let info    = jsonStr.objectForKey("info") as! String
            
            return (status, info)
        }catch let error as NSError {
            print("解析服务器数据失败\(error.localizedDescription)")
            return (1, String())
        }
    }
    
    /**
     判断服务器是否已经接收评论
     
     - parameter jsonData: 服务端返回的数据
     
     - returns: Bool
     */
    func commentAccept(jsonData: NSData) -> Bool {
        let result = parseResponsJSON(jsonData)
        if result.status != 0 {
            print("服务器返回错误\(result.info)")
            return false
        }
        return true
    }
}

class CommentHandler: SandboxHandler {
    
    //缩略图的尺寸
    private let thumbDefaultSize = CGSizeMake(60.0, 60.0)
    
    /**
     保存评论图片到临时目录,每张图片会保存原图和缩略图，最后返回原图和缩略图的沙盒路径
     注：
     1. 这里使用了AlbumHandler中的方法，后期需要将公共函数抽取出来
     2. 真机中存储路径如下，后期需要优化路径拼接函数，防止出现目录中出现两个斜线
     /private/var/mobile/Containers/Data/Application/F8E4B43B-88AB-4260-86E1-2DD97BECB3BB/tmp//comment_20160405175111847.png
     
     - parameter image: UIImage类型的图片
     
     - returns: 图片在沙盒中的URL（返回复合值包含原图和缩略图）
     */
    func saveImageToSandbox(image: UIImage) -> (thumbnails: String, originimages: String) {
        let sandboxDir  = getTmpDirectory()
        let imageID     = AlbumHandler().makeUniqueID()
        let thumbImage  = sandboxDir + "comment_\(imageID)_thumb.png"
        let originImage = sandboxDir + "comment_\(imageID)_origin.png"
        
        guard UIImageJPEGRepresentation(image, 0.01)!.writeToFile(originImage, atomically: true) else {
            return (String(), String())
        }
        
        let scaledImage = ImageHandler().aspectSacleSize(image, targetSize: thumbDefaultSize)
        guard UIImageJPEGRepresentation(scaledImage, 0.01)!.writeToFile(thumbImage, atomically: true) else {
            return (String(), originImage)
        }
        
        return (thumbImage, originImage)
    }
    
    /**
     删除沙盒中缓存的图片
     
     - parameter imagePath: 沙盒中图片位置
     */
    func removeImageFromSandbox(imagePath: String) -> Void {
        removeFile(imagePath)
    }
}