//
//  KeyboardAccessory.swift
//  DecorationSteward
//
//  Created by ruby on 14-12-14.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation
import UIKit

class KeyboardAccessory {
    let keyboradHeight: CGFloat = 270
    
    func moveUpView(view: UIView, offset: CGFloat) {
        func animation() {
            view.frame.origin.y -= offset
        }
        UIView.animateWithDuration(0.3, animations: animation)
    }
    
    func restoreView(view: UIView) {
        func animation() {
            view.frame.origin.y = 0
        }
        
        UIView.animateWithDuration(0.3, animations: animation)
    }
    
    // 如果键盘遮挡输入框则将view上移
    func moveUpViewIfNeeded(textField: UITextField, view: UIView) -> Void {
        // 取得当前输入框距离底部的距离
        let fieldBottomYPosition = textField.frame.origin.y + textField.frame.size.height
        let fieldBottomSpace = view.frame.height - fieldBottomYPosition
        
        // 判断是否需要上移view防止键盘遮挡, 暂定键盘高度为270
        if fieldBottomSpace < keyboradHeight {
            let offset = keyboradHeight - fieldBottomSpace // 需要向上偏移量
            
            moveUpView(view, offset: offset)
        }
    }
    
    func moveUpViewIfNeeded(textView: UITextView, view: UIView) -> Void {
        // 取得当前输入框距离底部的距离
        let fieldBottomYPosition = textView.frame.origin.y + textView.frame.size.height
        let fieldBottomSpace = view.frame.height - fieldBottomYPosition
        
        // 判断是否需要上移view防止键盘遮挡, 暂定键盘高度为270
        if fieldBottomSpace < keyboradHeight {
            let offset = keyboradHeight - fieldBottomSpace // 需要向上偏移量
            
            moveUpView(view, offset: offset)
        }
    }
    
    // 如果view不在原位置则恢复
    func restoreViewPositionIfNeeded(view: UIView) -> Void {
        if view.frame.origin.y == 0 {
            return
        }
        
        restoreView(view)
    }
}