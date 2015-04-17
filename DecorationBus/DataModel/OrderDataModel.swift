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
    class func getOrdersByPrimeCategory(primeCategory: String) -> [NSManagedObject] {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@", primeCategory)
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
    
    class func getOrders(primeCategory: String, minorCategory: String) -> [NSManagedObject] {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@ AND minorCategory = %@", primeCategory, minorCategory)
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
    
    /*
    从数据库对象中读取记录
    */
    class func getRecordByManagedObject(manageObj: NSManagedObject) -> OrderRecord {
        var record = OrderRecord()
        record.id_              = manageObj.valueForKey("id")               as! String
        record.money_           = manageObj.valueForKey("money")            as! Float
        record.primeCategory_   = manageObj.valueForKey("primeCategory")    as! String
        record.minorCategory_   = manageObj.valueForKey("minorCategory")    as! String
        record.shop_            = manageObj.valueForKey("shop")             as! String
        record.phone_           = manageObj.valueForKey("phone")            as! String
        record.addr_            = manageObj.valueForKey("address")          as! String
        record.comments_        = manageObj.valueForKey("comments")         as! String
        
        return record
    }
    
    class func getRecordsByCategory(primeCategory: String, minorCategory: String) -> [OrderRecord] {
        var records = Array<OrderRecord>()
        
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@ AND minorCategory = %@", primeCategory, minorCategory)
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return records
        }
        
        for result in fetchResult! {
            records.append(getRecordByManagedObject(result))
        }
        
        return records
    }
    
    /*
    获取所有数据列表
    */
    class func getAll() -> Array<OrderRecord> {
        var records = Array<OrderRecord>()
        
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return records
        }
        
        for result in fetchResult! {
            records.append(getRecordByManagedObject(result))
        }
        
        return records
    }
    
    // 删除所有数据，成功true, 失败false
    class func deleteAll() -> Bool {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Order")
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return false
        }
        for result in fetchResult! {
            managedObjectContext?.deleteObject(result)
        }
        managedObjectContext?.save(&error)
        return true
    }
    
    /*
    保存一条记录
    */
    class func saveRecord(record: OrderRecord) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate  as? AppDelegate
        let managedObjectContext = appDelegate?.managedObjectContext
        let entity = NSEntityDescription.entityForName("Order", inManagedObjectContext: managedObjectContext!)
        let manageObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        manageObj.setValue(record.id_, forKey: "id")
        manageObj.setValue(record.money_, forKey: "money")
        manageObj.setValue(record.primeCategory_, forKey: "primeCategory")
        manageObj.setValue(record.minorCategory_, forKey: "minorCategory")
        manageObj.setValue(record.shop_, forKey: "shop")
        manageObj.setValue(record.phone_, forKey: "phone")
        manageObj.setValue(record.addr_, forKey: "address")
        manageObj.setValue(record.comments_, forKey: "comments")
        var error: NSError?
        if false == managedObjectContext!.save(&error) {
            println("写入失败: \(error), \(error!.userInfo)")
            return false
        }
        
        return true
    }
    
    /*
    删除单条记录
    */
    class func removeRecord(uniqueID: String) -> Bool {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueID)
        var error: NSError?
        var fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return false
        }
        
        for result in fetchResult! {
            managedObjectContext?.deleteObject(result)
        }
        let rc = managedObjectContext?.save(&error)
        if !(rc != nil) {
            println("删除数据失败: \(error), \(error!.userInfo)")
            return false
        }
        
        return true
    }
    
    /*
    更新单条记录
    */
    class func updateRecord(record: OrderRecord) -> Bool {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        var managedObjectContext = appDelegate!.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Order")
        fetchRequest.predicate = NSPredicate(format: "id = %@", record.id_)
        var error: NSError?
        var fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return false
        }
        
        assert(fetchResult!.count == 1, "发现多条数据拥有同一ID")
        
        // 更新数据
        var newRecord = fetchResult![0]
        newRecord.setValue(record.money_, forKey: "money")
        newRecord.setValue(record.primeCategory_, forKey: "primeCategory")
        newRecord.setValue(record.minorCategory_, forKey: "minorCategory")
        newRecord.setValue(record.shop_, forKey: "shop")
        newRecord.setValue(record.phone_, forKey: "phone")
        newRecord.setValue(record.addr_, forKey: "address")
        newRecord.setValue(record.comments_, forKey: "comments")
        if false == managedObjectContext!.save(&error) {
            println("写入失败: \(error), \(error!.userInfo)")
            return false
        }
        
        return true
    }
}