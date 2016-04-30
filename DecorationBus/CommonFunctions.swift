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
