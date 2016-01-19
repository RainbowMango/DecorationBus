//
//  DeviceLimitHandler.swift
//  DecorationBus
//
//  Created by ruby on 16/1/19.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation
import AVFoundation

class DeviceLimitHandler {
    
    // 判断用户隐私设置中是否对本APP禁用相机功能
    func allowCamera() -> Bool {
        //IOS7.0引入，需要import AVFoundation
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.Denied ||
            authStatus == AVAuthorizationStatus.Restricted {
                return false
        }
        
        return true
    }
}