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
        startIntro()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        initAlbum()
    }
    
    override func viewDidAppear(animated: Bool) {
        setSummaryData()
    }
    
    // 启动系统引导页
    func startIntro() -> Void {
        //判断是否第一次启动，如是则跳过引导
        if IntroducePageHandler().isIntroShown() {
            return
        }
        
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        
        let item1 = RMParallaxItem(image: UIImage(named: "intr001")!, text: "装修路上处处陷阱...")
        let item2 = RMParallaxItem(image: UIImage(named: "intr002")!, text: "低价往往不是让利促销...")
        let item3 = RMParallaxItem(image: UIImage(named: "intr003")!, text: "设计师的时间总是伴随着利益...")
        let item4 = RMParallaxItem(image: UIImage(named: "intr004")!, text: "装修增项让人防不胜防...")
        let item5 = RMParallaxItem(image: UIImage(named: "intr005")!, text: "我们, 只是想让装修更简单一点点...")
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4, item5], motion: false)
        
        //定义结束引导页行为，显示导航栏，TAB栏
        rmParallaxViewController.completionHandler = {
            self.navigationController?.navigationBarHidden = false
            self.tabBarController?.tabBar.hidden = false
            UIView.animateWithDuration(0.4, animations: { () -> Void in

                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
        
        //增加标志以让下次启动不再显示引导页
        IntroducePageHandler().setIntroShown()
    }

    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
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
            sum += item.valueForKey("money") as! Float
        }
        
        return sum
    }
    
    // 获取预算金额汇总
    func getBudgetSum() -> Float {
        var sum: Float = 0.00
        for item in budgets_ {
            sum += item.valueForKey("money") as! Float
        }
        
        return sum
    }
    
    // 从CoreData中读取所有订单
    func getOrders() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var fetchResult = [NSManagedObject]()
        do {
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch {
            print("获取数据失败:")
            return [NSManagedObject]()
        }
        
        return fetchResult
    }
    
    // 从CoreData中读取所有预算
    func getBudgets() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let managedObjectContext = appDelegate!.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Budget")
        var fetchResult = [NSManagedObject]()
        do {
            fetchResult = try managedObjectContext!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch {
            print("获取数据失败:")
            return [NSManagedObject]()
        }
        
        return fetchResult
    }
    
    // 初始化类别列表，程序启动时拷贝资源文件到沙盒
    func initCategory() {
        CategoryHandler().copyFileToSandbox()
    }
    
    // 初始化相册列表，程序启动时拷贝资源文件到沙盒
    func initAlbum() {
        AlbumHandler().copyFileToSandbox()
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

