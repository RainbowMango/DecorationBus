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
    
    func showImagePicker(parent: UIViewController,
                         picker: DKImagePickerController?,
                         source: DKImagePickerControllerSourceType,
                         maxCount: Int,
                         defaultAssets: Array<DKAsset>?) -> Void {
        
        let pickerVC = picker ?? DKImagePickerController()
        
        pickerVC.allowMultipleTypes    = false
        pickerVC.showsEmptyAlbums      = false
        pickerVC.showsCancelButton     = true
        pickerVC.assetType             = .AllPhotos
        pickerVC.sourceType            = source
        pickerVC.maxSelectableCount    = maxCount
        pickerVC.defaultSelectedAssets = defaultAssets
        
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    /**
     从相机中导入图片
     注：使用相机将会自动屏蔽assetType、maxSelectableCount、allowMultipleTypes、defaultSelectedAssets
     
     - parameter parent: parent view controller
     - parameter picker: 可选的picker controller
     */
    func importPhotoFromCamera(parent: UIViewController,
                               picker: DKImagePickerController?) {
        let pickerVC = picker ?? DKImagePickerController()
        
        pickerVC.showsEmptyAlbums      = false
        pickerVC.sourceType            = .Camera
        parent.presentViewController(pickerVC, animated: true, completion: nil)
    }
}