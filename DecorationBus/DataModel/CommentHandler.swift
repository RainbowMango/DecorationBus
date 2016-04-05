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
    var imageArray : Array<String>
    
    init() {
        textContent = String()
        target      = CommentTargetType.TypeUnknown
        imageArray  = Array<String>()
    }
}

class CommentHandler: SandboxHandler {
    
    /**
     保存评论图片到临时目录并返回图片的路径
     注：
     1. 这里使用了AlbumHandler中的方法，后期需要将公共函数抽取出来
     2. 真机中存储路径如下，后期需要优化路径拼接函数，防止出现目录中出现两个斜线
     /private/var/mobile/Containers/Data/Application/F8E4B43B-88AB-4260-86E1-2DD97BECB3BB/tmp//comment_20160405175111847.png
     
     - parameter image: UIImage类型的图片
     
     - returns: 图片在沙盒中的URL（String结构存储）
     */
    func saveImageToSandbox(image: UIImage) -> String {
        let docDir = getTmpDirectory()
        let fileName = "comment_\(AlbumHandler().makeUniqueID()).png"
        let fileWithPath = docDir + "/" + fileName
        
        guard UIImageJPEGRepresentation(image, 0.01)!.writeToFile(fileWithPath, atomically: true) else {
            return String()
        }
        
        return fileWithPath
    }
}