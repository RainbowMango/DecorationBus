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
    
    /**
     生成alert controller提示用户从相机或图库中导入图片。
     
     - parameter parent:          父controller,用于启动新的controller
     - parameter maxCount:        最大允许导入图片，仅适用于从图库导入的场景
     - parameter defaultAssets:   默认选取的图片，仅适用于从图库导入的场景
     - parameter didSelectAssets: 调用结束回调函数
     
     - returns: UIAlertController
     */
    func makeAlertController(parent: UIViewController,
                             maxCount: Int,
                             defaultAssets: Array<DKAsset>?,
                             didSelectAssets: ((assets: [DKAsset]) -> Void)?) -> UIAlertController {
        
        let alertVC = UIAlertController(title: "添加图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraSheet = UIAlertAction(title: actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                if(!DeviceLimitHandler().allowCamera()) {
                    DeviceLimitHandler().showAlertForCameraRestriction(parent)
                    return
                }
                self.importPhotoFromCamera(parent, didSelectAssets: didSelectAssets)
            }
            alertVC.addAction(cameraSheet)
        }
        
        // 检测是否支持图库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let photoLibrarySheet = UIAlertAction(title: actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                if(!DeviceLimitHandler().allowPhotoLibrary()) {
                    DeviceLimitHandler().showAlertForPhotoRestriction(parent)
                    return
                }
                
                self.importPhotoFromAlbum(parent, maxCount: maxCount, defaultAssets: defaultAssets, didSelectAssets: didSelectAssets)
            }
            alertVC.addAction(photoLibrarySheet)
        }
        
        //添加取消action
        let cancelSheet = UIAlertAction(title: actionSheetTitleCancel, style: .Cancel, handler: nil)
        alertVC.addAction(cancelSheet)
        
        return alertVC
    }
}