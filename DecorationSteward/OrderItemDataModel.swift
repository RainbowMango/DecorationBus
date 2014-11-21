//
//  OrderItemDataModel.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-20.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class OrderItem: NSObject, NSCoding{
    override init() {
    }

    required init(coder aDecoder: NSCoder) {
        self.money = aDecoder.decodeObjectForKey("money") as String
        self.category = aDecoder.decodeObjectForKey("category") as String
        self.shop = aDecoder.decodeObjectForKey("shop") as String
        self.phone = aDecoder.decodeObjectForKey("phone") as String
        self.addr = aDecoder.decodeObjectForKey("addr") as String
        self.comment = aDecoder.decodeObjectForKey("comment") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.money, forKey: "money")
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeObject(self.shop, forKey: "shop")
        aCoder.encodeObject(self.phone, forKey: "phone")
        aCoder.encodeObject(self.addr, forKey: "addr")
        aCoder.encodeObject(self.comment, forKey: "comment")
    }
    
    var money: String = ""
    var category: String = ""
    var shop: String = ""
    var phone: String = ""
    var addr: String = ""
    var comment: String = ""
}