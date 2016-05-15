//
//  HCImagePickerHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/3/30.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation
import DKImagePickerController

class HCImagePickerHandler {
    
    // 定义照片源字符串，方便创建actionSheet和处理代理
    let actionSheetTitleCancel = "取消"
    let actionSheetTitleCamera = "拍照"
    let actionSheetTitlePhotoLibrary = "照片库"
    
    /**
     从相册中导入图片，重用picker controller
     
     - parameter parent:          调用父类
     - parameter maxCount:        最多选取的图片数
     - parameter defaultAssets:   默认选取的图片数，也即已经选取的图片数
     - parameter didSelectAssets: 调用结束回调函数
     */
    func importPhotoFromAlbum(parent: UIViewController,
                              picker: DKImagePickerController?,
                              maxCount: Int,
                              defaultAssets: Array<DKAsset>?,
                              didSelectAssets: ((assets: [DKAsset]) -> Void)?) {
        
        let pickerVC = picker ?? DKImagePickerController()
        
        //默认属性
        pickerVC.allowMultipleTypes    = false
        pickerVC.showsEmptyAlbums      = false
        pickerVC.showsCancelButton     = true
        pickerVC.assetType             = .AllPhotos
        pickerVC.sourceType            = .Photo
        
        //自定义属性
        pickerVC.maxSelectableCount    = maxCount
        pickerVC.defaultSelectedAssets = defaultAssets
        pickerVC.didSelectAssets       = pickerVC.didSelectAssets ?? didSelectAssets
        
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    /**
     从相册中导入图片
     
     - parameter parent:          调用父类
     - parameter maxCount:        最多选取的图片数
     - parameter defaultAssets:   默认选取的图片数，也即已经选取的图片数
     - parameter didSelectAssets: 调用结束回调函数
     */
    func importPhotoFromAlbum(parent: UIViewController,
                              maxCount: Int,
                              defaultAssets: Array<DKAsset>?,
                              didSelectAssets: ((assets: [DKAsset]) -> Void)?) {
        let pickerVC = DKImagePickerController()
        
        //默认属性
        pickerVC.allowMultipleTypes    = false
        pickerVC.showsEmptyAlbums      = false
        pickerVC.showsCancelButton     = true
        pickerVC.assetType             = .AllPhotos
        pickerVC.sourceType            = .Photo
        
        //自定义属性
        pickerVC.maxSelectableCount    = maxCount
        pickerVC.defaultSelectedAssets = defaultAssets
        pickerVC.didSelectAssets       = didSelectAssets
        
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    /**
     从相机中导入图片，使用已有的picker controller
     注：使用相机将会自动屏蔽assetType、maxSelectableCount、allowMultipleTypes、defaultSelectedAssets
     
     - parameter parent: 调用父类
     - parameter picker: 重用的picker controller
     */
    func importPhotoFromCamera(parent: UIViewController,
                               picker: DKImagePickerController?,
                               didSelectAssets: ((assets: [DKAsset]) -> Void)?) {
        
        let pickerVC = picker ?? DKImagePickerController()
        
        pickerVC.sourceType            = .Camera
        pickerVC.didSelectAssets = didSelectAssets
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    /**
     从相机中导入图片
     
     - parameter parent:          调用父类
     - parameter didSelectAssets: 调用结束回调函数
     */
    func importPhotoFromCamera(parent: UIViewController,
                               didSelectAssets: ((assets: [DKAsset]) -> Void)?) {
        let pickerVC = DKImagePickerController()
        
        pickerVC.sourceType            = .Camera
        pickerVC.didSelectAssets = didSelectAssets
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
}