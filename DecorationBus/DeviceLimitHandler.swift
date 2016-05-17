//
//  DeviceLimitHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/1/19.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation
import AVFoundation
import AssetsLibrary

class DeviceLimitHandler {
    
    // 判断用户隐私设置中是否对本APP禁用相机功能
    func allowCamera() -> Bool {
        //IOS7.0引入，需要import AVFoundation
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == .Denied || authStatus == .Restricted {
                return false
        }
        
        return true
    }
    
    // 判断用户隐私设置中是否对本APP禁用照片功能
    func allowPhotoLibrary() -> Bool {
        // IOS 6.0提供，需要import AssetsLibrary
        let authStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus == .Denied || authStatus == .Restricted {
                return false
        }
        
        return true
    }
}