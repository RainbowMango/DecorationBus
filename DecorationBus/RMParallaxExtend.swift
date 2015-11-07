//
//  RMParallaxExtend.swift
//  DecorationBus
//
//  Created by ruby on 15/11/7.
//  Copyright © 2015年 ruby. All rights reserved.
//

import Foundation

/*
扩展原因：
1. 源库RMParallax 没有隐藏状态栏
2. 扩展后可以使调用代码清爽
*/
class RMParallaxExtend: RMParallax {
    var itemArray = [RMParallaxItem]()
    
    /*自定义接口，将引导图片初始化*/
    init() {
        itemArray.append(RMParallaxItem(image: UIImage(named: "intr001")!, text: "装修路上处处陷阱..."))
        itemArray.append(RMParallaxItem(image: UIImage(named: "intr002")!, text: "低价往往不是让利促销..."))
        itemArray.append(RMParallaxItem(image: UIImage(named: "intr003")!, text: "设计师的时间总是伴随着利益..."))
        itemArray.append(RMParallaxItem(image: UIImage(named: "intr004")!, text: "装修增项让人防不胜防..."))
        itemArray.append(RMParallaxItem(image: UIImage(named: "intr005")!, text: "我们, 只是想让装修更简单一点点..."))
        
        super.init(items: itemArray, motion: false)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }

    //依然保留原始接口
    required init(items: [RMParallaxItem], motion: Bool) {
        super.init(items: items, motion: motion)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init with items, motion.")
    }
    
    // 只在此view controller中隐藏状态栏，依赖于Info.plist中“View controller-based status bar appearance” 需设置为YES，即状态栏控制权交给view controller
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
