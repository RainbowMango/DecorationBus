//
//  ImageHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/2/2.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

class ImageHandler {
    
    /*
    * 裁剪图片到指定大小，默认裁剪原点坐标为（x = 0，y = 0）
    */
    func scaleSize(origImage: UIImage, newSize: CGSize, startPoint: CGPoint = CGPoint(x: 0, y: 0)) -> UIImage {
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize);
        
        // Tell the old image to draw in this new context, with the desired new size
        origImage.drawInRect(CGRectMake(startPoint.x, startPoint.y, newSize.width, newSize.height))
        
        // Get the new image from the context
        let dstImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
        // Return the new image.
        return dstImage
    }
    
    /*
    * 等比缩放图片到指定尺寸
    */
    func aspectSacleSize(srcImage: UIImage, targetSize: CGSize) -> UIImage {
        let srcSize = srcImage.size
        
        //如果尺寸一致，则不需要处理
        if(CGSizeEqualToSize(srcSize, targetSize)) {
            return srcImage
        }
        
        //取得缩放系数
        let widthFactor  = targetSize.width / srcSize.width
        let heightFactor = targetSize.height / srcSize.height
        let scaleFactor  = (widthFactor > heightFactor) ? widthFactor : heightFactor // 取最大的缩放系数
        let scaleWidth   = srcSize.width * scaleFactor
        let scaleHeight  = srcSize.height * scaleFactor
        
        //取得截取图像原始坐标
        var thumbnailPoint = CGPointMake(0.0, 0.0)
        if(widthFactor > heightFactor) {
            thumbnailPoint.y = (targetSize.height - scaleHeight) * 0.5
        }
        else {
            thumbnailPoint.x = (targetSize.width - scaleWidth) * 0.5
        }
        
        //开始绘制图像
        UIGraphicsBeginImageContext(targetSize);
        let thumbnailRect = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaleWidth, scaleHeight)
        srcImage.drawInRect(thumbnailRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     将UIImage转换成NSData
     
     - parameter image:              将转换的图片
     - parameter compressionQuality: 压缩比例，压缩比只针对PNG图片有效
     
     - returns: NSData(输出的二进制数据)，String(mine类型)
     */
    func getImageBinary(image: UIImage, compressionQuality: CGFloat) -> (data: NSData?, mine: String?) {
        var data : NSData?
        var mineType: String?
        
        if let tmpData = UIImagePNGRepresentation(image) {
            data = tmpData
            mineType = "png"
        }
        else if let tmpData = UIImageJPEGRepresentation(image, compressionQuality) {
            data = tmpData
            mineType = "jpeg"
        }
        
        if nil == data {
            print("转换图片失败")
        }
        
        return (data, mineType)
    }
}