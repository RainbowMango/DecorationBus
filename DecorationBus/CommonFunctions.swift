//
//  CommonFunctions.swift
//  DecorationBus
//
//  Created by ruby on 16/4/30.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation
import UIKit

/**
 禁用导航栏按钮
 
 - parameter button: 按钮的引用
 */
func disableBarButton(button: UIBarButtonItem) -> Void {
    dispatch_async(dispatch_get_main_queue()) { 
        button.enabled = false
    }
}

/**
 激活导航栏按钮
 
 - parameter button: <#button description#>
 */
func enableBarButton(button: UIBarButtonItem) -> Void {
    dispatch_async(dispatch_get_main_queue()) {
        button.enabled = true
    }
}

/**
 停止过渡提示
 
 - parameter view:     过渡提示所在的view
 - parameter animated: 是否使用动画
 */
func stopProgressHUD(view: UIView, animated: Bool) -> Void {
    dispatch_async(dispatch_get_main_queue(), {
        MBProgressHUD.hideHUDForView(view, animated: animated)

    })
}