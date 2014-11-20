//
//  OrderItemDataModel.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-20.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class OrderItem: NSCoder {
    override init() {
        self.money = ""
        self.category = ""
        self.shop = ""
        self.phone = ""
        self.addr = ""
        self.comment = ""
    }

    var money: String
    var category: String
    var shop: String
    var phone: String
    var addr: String
    var comment: String
}