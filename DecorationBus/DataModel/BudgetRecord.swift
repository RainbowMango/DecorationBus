//
//  BudgetRecord.swift
//  DecorationBus
//
//  Created by ruby on 15-1-31.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation

/*
订单信息，与数据库模型保持一致
*/
class BudgetRecord: NSObject {
    var id_             : String    = String()
    var money_          : Float     = Float()
    var primeCategory_  : String    = String()
    var minorCategory_  : String    = String()
    var comments_       : String    = String()
    
    // 所有数据成员初始化为空
    override init() {
        id_             = ""
        money_          = 0.00
        primeCategory_  = ""
        minorCategory_  = ""
        comments_       = ""
    }
    
    // 描述信息，调试用
    func recordDescription() -> String {
        var desc = "id = \(id_), "
        desc    += "money = \(money_) "
        desc    += "primeCategory = \(primeCategory_) "
        desc    += "minorCategory = \(minorCategory_) "
        desc    += "comments = \(comments_) "
        
        return desc
    }
    
    /*
    根据当前时间(精确到毫秒)生成唯一标示
    */
    func makeUniqueID() {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        var date          = NSDate()
        
        id_ = dateFormatter.stringFromDate(date)
    }
}
