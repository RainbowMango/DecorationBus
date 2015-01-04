//
//  ShowPayListViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-11-23.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ShowPayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var deTailTableView: UITableView!
    
    var cellReuseIdentifier: String = "payCell"
    var orders: Array<OrderItem> = OrderArchiver().getOrdesFromUserDefault()
    
    var orders_ = [NSManagedObject]()
    var managedObjectContext_: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        
        initManagedObjectContext()
        setTableView()
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        orders_ = getOrders()
        reloadData()
        self.deTailTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
    }
    
    func initManagedObjectContext() {
        var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        managedObjectContext_ = appDelegate!.managedObjectContext
    }

    // MARK: Init functions
    
    // 初始化table view
    func setTableView() {
        self.deTailTableView.dataSource = self
        self.deTailTableView.delegate = self
        
        // 删除table下面多于空白cell
        self.deTailTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func reloadData() -> Void {
        orders = OrderArchiver().getOrdesFromUserDefault()
    }
    
    // 从CoreData中读取所有订单
    func getOrders() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var error: NSError?
        let fetchResult = managedObjectContext_!.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        if fetchResult == nil {
            println("获取数据失败: \(error), \(error!.userInfo)")
            return [NSManagedObject]()
        }
        
        return fetchResult!
    }
    
    // MARK: -TableView data source
    
    // 每个section显示行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders_.count
    }
    
    // 设置cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        let primeCategory = orders_[indexPath.row].valueForKey("primeCategory") as String
        let minorCategory = orders_[indexPath.row].valueForKey("minorCategory") as String
        let money         = orders_[indexPath.row].valueForKey("money") as Float
        cell.textLabel.text = "\(primeCategory)-\(minorCategory)   \(money)"
        
        return cell
    }
    
    // 设置section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath() \(indexPath.row)")
        
        //performSegueWithIdentifier("toShowDetailPay", sender: self.view)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 添加滑动按钮
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext_!.deleteObject(orders_[indexPath.row])
            orders_.removeAtIndex(indexPath.row)
            var error: NSError?
            if false == managedObjectContext_!.save(&error) {
                println("写入失败: \(error), \(error!.userInfo)")
            }

            self.deTailTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Navigation
    
    // 向下个页面传值标准做法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowDetailPay" {
            println("将要转入toShowDetailPay页面")
            
            // 获得选中cell元素
            var selectedIndex: NSIndexPath = self.deTailTableView.indexPathForSelectedRow()!
            var orderItem = self.orders[selectedIndex.row]
            
            var destinationView: ShowPayDetailViewController = segue.destinationViewController as ShowPayDetailViewController
            destinationView.setValue(orderItem, forKey: "orderItem")
        }
    }
}
