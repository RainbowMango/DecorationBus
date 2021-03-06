//
//  BudgetDataModel.swift
//  DecorationBus
//
//  Created by ruby on 15-1-21.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BudgetDataModel {
    class func getBudgetsByPrimeCategory(primeCategory: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@", primeCategory)
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult
    }
    
    class func getBudgets(primeCategory: String, minorCategory: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@ AND minorCategory = %@", primeCategory, minorCategory)
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult
    }
    
    /*
    从数据库对象中读取记录
    */
    class func getRecordByManagedObject(manageObj: NSManagedObject) -> BudgetRecord {
        let record = BudgetRecord()
        record.id_              = manageObj.valueForKey("id")               as! String
        record.money_           = manageObj.valueForKey("money")            as! Float
        record.primeCategory_   = manageObj.valueForKey("primeCategory")    as! String
        record.minorCategory_   = manageObj.valueForKey("minorCategory")    as! String
        record.comments_        = manageObj.valueForKey("comments")         as! String
        
        return record
    }
    
    class func getRecordsByCategory(primeCategory: String, minorCategory: String) -> [BudgetRecord] {
        var records = Array<BudgetRecord>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "primeCategory = %@ AND minorCategory = %@", primeCategory, minorCategory)
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return records
        }
        
        for result in fetchResult {
            records.append(getRecordByManagedObject(result))
        }
        
        return records
    }
    
    /*
    获取所有数据列表
    */
    class func getAll() -> Array<BudgetRecord> {
        var records = Array<BudgetRecord>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return records
        }
        
        for result in fetchResult {
            records.append(getRecordByManagedObject(result))
        }
        
        return records
    }
    
    // 删除所有数据，成功true, 失败false
    class func deleteAll() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return false
        }
        
        for result in fetchResult {
            managedObjectContext?.deleteObject(result)
        }
        
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("保存数据失败: \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    /*
    保存一条记录
    */
    class func saveRecord(record: BudgetRecord) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate  as? AppDelegate
        let managedObjectContext = appDelegate?.managedObjectContext
        let entity = NSEntityDescription.entityForName("Budget", inManagedObjectContext: managedObjectContext!)
        let manageObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        manageObj.setValue(record.id_, forKey: "id")
        manageObj.setValue(record.money_, forKey: "money")
        manageObj.setValue(record.primeCategory_, forKey: "primeCategory")
        manageObj.setValue(record.minorCategory_, forKey: "minorCategory")
        manageObj.setValue(record.comments_, forKey: "comments")

        do{
            try managedObjectContext!.save()
        }catch let error as NSError{
            print("写入失败: \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    /*
    删除单条记录
    */
    class func removeRecord(uniqueID: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueID)
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return false
        }
        
        for result in fetchResult {
            managedObjectContext?.deleteObject(result)
        }
        
        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("删除数据失败: \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    /*
    更新单条记录
    */
    class func updateRecord(record: BudgetRecord) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        fetchRequest.predicate = NSPredicate(format: "id = %@", record.id_)
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch let error as NSError{
            print("获取数据失败: \(error), \(error.userInfo)")
            return false
        }
        
        assert(fetchResult.count == 1, "发现多条数据拥有同一ID")
        
        // 更新数据
        let newRecord = fetchResult[0]
        newRecord.setValue(record.money_, forKey: "money")
        newRecord.setValue(record.primeCategory_, forKey: "primeCategory")
        newRecord.setValue(record.minorCategory_, forKey: "minorCategory")
        newRecord.setValue(record.comments_, forKey: "comments")
        do{
            try managedObjectContext!.save()
        }catch let error as NSError{
            print("写入失败: \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
}
