//
//  CommentHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/4/5.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

public enum CommentTargetType : Int {
    case TypeCompany
    case TypeArtist
    case TypeManager
    case TypeWorker
    case TypeUnknown
}

class Comment {
    var textContent: String
    var target: CommentTargetType
    var imageArray : Array<ImageCollectionViewCellData>
    
    init() {
        textContent = String()
        target      = CommentTargetType.TypeUnknown
        imageArray  = Array<ImageCollectionViewCellData>()
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