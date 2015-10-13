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
    
    var orders_ = [NSManagedObject]()
    var managedObjectContext_: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        
        initManagedObjectContext()
        setTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        orders_ = getOrders()
        self.deTailTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }
    
    func initManagedObjectContext() {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
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
    
    // 从CoreData中读取所有订单
    func getOrders() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Order")
        
        var fetchResult = [NSManagedObject]()
        do{
            fetchResult = try managedObjectContext_!.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch{
            print("获取数据失败: ")
            return [NSManagedObject]()
        }
        
        return fetchResult
    }
    
    // MARK: -TableView data source
    
    // 每个section显示行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders_.count
    }
    
    // 设置cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) 
        let primeCategory = orders_[indexPath.row].valueForKey("primeCategory") as! String
        let minorCategory = orders_[indexPath.row].valueForKey("minorCategory") as! String
        let money         = orders_[indexPath.row].valueForKey("money") as! Float
        cell.textLabel!.text = "\(primeCategory)-\(minorCategory)   \(money)"
        
        return cell
    }
    
    // 设置section数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 设定选中时的动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath() \(indexPath.row)")
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 添加滑动按钮
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            managedObjectContext_!.deleteObject(orders_[indexPath.row])
            orders_.removeAtIndex(indexPath.row)

            do{
                try managedObjectContext_!.save()
            }catch{
                print("写入失败: ")
                return
            }

            self.deTailTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - Navigation
    
    // 向下个页面传值标准做法
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShowDetailPay" {
            // 获得选中cell元素
            let selectedIndex: NSIndexPath = self.deTailTableView.indexPathForSelectedRow!
            let selectedItem = orders_[selectedIndex.row]
            let money: Float  = selectedItem.valueForKey("money")          as! Float
            let primeCategory = selectedItem.valueForKey("primeCategory")  as! String
            let minorCategory = selectedItem.valueForKey("minorCategory")  as! String
            let shop          = selectedItem.valueForKey("shop")           as! String
            let phone         = selectedItem.valueForKey("phone")          as! String
            let address       = selectedItem.valueForKey("address")        as! String
            let comments      = selectedItem.valueForKey("comments")       as! String
            
            let destinationView: ShowPayDetailViewController = segue.destinationViewController as! ShowPayDetailViewController
            destinationView.setValue(money,         forKey: "money_")
            destinationView.setValue(primeCategory, forKey: "primeCategory_")
            destinationView.setValue(minorCategory, forKey: "minorCategory_")
            destinationView.setValue(shop,          forKey: "shop_")
            destinationView.setValue(phone,         forKey: "phone_")
            destinationView.setValue(address,       forKey: "address_")
            destinationView.setValue(comments,      forKey: "comments_")
        }
    }
}
