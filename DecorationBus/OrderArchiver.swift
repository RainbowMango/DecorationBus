//
//  OrderArchiver.swift
//  DecorationBus
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
        let encodedOrders: NSData? = userDefault.objectForKey(ordersKey) as? NSData
        if nil == encodedOrders {
            return Array<OrderItem>()
        }
        
        let orders = NSKeyedUnarchiver.unarchiveObjectWithData(encodedOrders!) as! Array<OrderItem>
        print("getOrdesFromUserDefault() count = \(orders.count)")
        
        return orders
    }
    
    // 序列化存储orders
    func saveOrdersToUserDefault(orders: Array<OrderItem>) -> Void {
        let archivedOrders = NSKeyedArchiver.archivedDataWithRootObject(orders)
        userDefault.setObject(archivedOrders, forKey: ordersKey)
        userDefault.synchronize()
        print("saveOrdersToUserDefault() count = \(orders.count)")
    }
    
    // 清除所有订单
    func removeAllOrders() -> Void {
        var currentItems = getOrdesFromUserDefault()
        currentItems.removeAll(keepCapacity: true)
        saveOrdersToUserDefault(currentItems)
    }
    
    // 获取订单总额
    func getOrderSum() -> Float {
        let orders = getOrdesFromUserDefault()
        var total: Float = 0.00
        
        for order in orders {
            total += order.money
        }
        
        return total
    }
}