//
//  ColorScheme.swift
//  DecorationBus
//
//  Created by ruby on 14-12-1.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    var navigationBarBackgroundColor = UIColor(red: 255/255, green: 287/255, blue: 103/255, alpha: 1.0)
    var buttonBackgroundColor = UIColor(red: 204/255, green: 181/255, blue: 135/255, alpha: 1.0)
    var buttonTextColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    var textFieldBackgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
    var pickerViewBackgroundColor = UIColor(red: 204/255, green: 181/255, blue: 135/255, alpha: 1.0)
    
    //View背景色
    //var viewBackgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
    var viewBackgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    
    //用户评分主题
    func getScoreChartTheme() -> MDRadialProgressTheme {
        let newTheme = MDRadialProgressTheme()
        newTheme.completedColor = UIColor(red: 90/255.0, green: 212/255.0, blue: 39/255.0, alpha: 1.0)
        newTheme.incompletedColor = UIColor(red: 164/255.0, green: 231/255.0, blue: 134/255.0, alpha: 1.0)
        newTheme.centerColor = UIColor.clearColor()
        newTheme.centerColor = UIColor(red: 224/255.0, green: 248/255.0, blue: 216/255.0, alpha: 1.0)
        newTheme.sliceDividerHidden = true
        newTheme.labelColor = UIColor.blackColor()
        newTheme.labelShadowColor = UIColor.whiteColor()
        
        return newTheme
    }
}