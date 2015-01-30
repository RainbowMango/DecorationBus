//
//  OrderRecord.swift
//  DecorationBus
//
//  Created by ruby on 15-1-29.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation

/*
订单信息，与数据库模型保持一致
*/
class OrderRecord: NSObject {
    var id_             : String    = String() //20150129205403
    var money_          : Float     = Float()
    var primeCategory_  : String    = String()
    var minorCategory_  : String    = String()
    var shop_           : String    = String()
    var phone_          : String    = String()
    var addr_           : String    = String()
    var comments_       : String    = String()
    
    // 所有数据成员初始化为空
    override init() {
        id_             = ""
        money_          = 0.00
        primeCategory_  = ""
        minorCategory_  = ""
        shop_           = ""
        phone_          = ""
        addr_           = ""
        comments_       = ""
    }
    
    // 描述信息，调试用
    func description() -> String {
        var desc = "id = \(id_), "
        desc    += "money = \(money_) "
        desc    += "primeCategory = \(primeCategory_) "
        desc    += "minorCategory = \(minorCategory_) "
        desc    += "shop = \(shop_) "
        desc    += "phone = \(phone_) "
        desc    += "addr = \(addr_) "
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