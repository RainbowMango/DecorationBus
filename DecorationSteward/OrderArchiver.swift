//
//  OrderArchiver.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-22.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import Foundation

class OrderArchiver {
    var userDefault: NSUserDefaults = NSUserDefaults()
    var ordersKey: String = "orders"
    
    // 序列化获取orders
    func getOrdesFromUserDefault() -> Array<OrderItem> {
        
        var encodedOrders: NSData = userDefault.objectForKey(ordersKey) as NSData
        var orders = NSKeyedUnarchiver.unarchiveObjectWithData(encodedOrders) as Array<OrderItem>
        println("getOrdesFromUserDefault() count = \(orders.count)")
        
        return orders
    }
    
    // 序列化存储orders
    func saveOrdersToUserDefault(orders: Array<OrderItem>) -> Void {
        var archivedOrders = NSKeyedArchiver.archivedDataWithRootObject(orders)
        userDefault.setObject(archivedOrders, forKey: ordersKey)
        userDefault.synchronize()
        println("saveOrdersToUserDefault() count = \(orders.count)")
    }
}