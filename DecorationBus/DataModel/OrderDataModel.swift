//
//  OrderDataModel.swift
//  DecorationBus
//
//  Created by ruby on 15-1-21.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class OrderDataModel {
    func getAllOrders() -> [NSManagedObject] {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
}