//
//  ViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var totalPaid: UILabel!
    @IBOutlet weak var leftBudget: UILabel!
    @IBOutlet weak var totalBudget: UILabel!
    
    var orders_ = [NSManagedObject]()
    var budgets_ = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
    }
    
    override func viewDidAppear(animated: Bool) {
        setSummaryData()
    }

    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    // 设置汇总数据
    func setSummaryData() {
        orders_ = getOrders()
        budgets_ = getBudgets()
        
        let orderSum = getOrderSum()
        let budgetSum = getBudgetSum()
        
        totalPaid!.text = "支出总额：\(orderSum)"
        leftBudget!.text = "预算余额：\(budgetSum - orderSum)"
        totalBudget!.text = "预算总额：\(budgetSum)"
    }
    
    // 获取订单金额汇总
    func getOrderSum() -> Float {
        var sum: Float = 0.00
        for item in orders_ {
            sum += item.valueForKey("money") as Float
        }
        
        return sum
    }
    
    // 获取预算金额汇总
    func getBudgetSum() -> Float {
        var sum: Float = 0.00
        for item in budgets_ {
            sum += item.valueForKey("money") as Float
        }
        
        return sum
    }
    
    // 从CoreData中读取所有订单
    func getOrders() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
    
    // 从CoreData中读取所有预算
    func getBudgets() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        
        var error: NSError?
        let fetchResult = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
    
    // 初始化类别列表，
    func initCategory() {
        var categoryDic = CategoryArchiver().getCategoryFromUserDefault()
        if categoryDic.isEmpty {
            CategoryArchiver().initCategoryInUserDefault()
            println("initCategory() count: \(categoryDic.count)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tab bar 切换时重新加载数据
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        setSummaryData()
    }
    
    // 导航回来时刷新数据
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        setSummaryData()
    }
}

