//
//  OrderItemDataModel.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-20.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class OrderItem: NSObject, NSCoding{
    
    // 展现形式
    var showList: Array<String> = Array<String>()
    
    override init() {
    }

    required init(coder aDecoder: NSCoder) {
        self.money = aDecoder.decodeFloatForKey("money") as Float
        self.category = aDecoder.decodeObjectForKey("category") as String
        self.shop = aDecoder.decodeObjectForKey("shop") as String
        self.phone = aDecoder.decodeObjectForKey("phone") as String
        self.addr = aDecoder.decodeObjectForKey("addr") as String
        self.comment = aDecoder.decodeObjectForKey("comment") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(self.money, forKey: "money")
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeObject(self.shop, forKey: "shop")
        aCoder.encodeObject(self.phone, forKey: "phone")
        aCoder.encodeObject(self.addr, forKey: "addr")
        aCoder.encodeObject(self.comment, forKey: "comment")
    }
    
    func getShowList() -> Array<String> {
        self.showList.append("金额： \(self.money)")
        self.showList.append("类别： \(self.category)")
        self.showList.append("商家： \(self.shop)")
        self.showList.append("电话： \(self.phone)")
        self.showList.append("地址： \(self.addr)")
        self.showList.append("备注： \(self.comment)")
        
        return self.showList
    }
    
    var money: Float = 0.00
    var category: String = ""
    var shop: String = ""
    var phone: String = ""
    var addr: String = ""
    var comment: String = ""
}