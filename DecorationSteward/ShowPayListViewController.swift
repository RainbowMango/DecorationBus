//
//  ShowPayListViewController.swift
//  DecorationSteward
//
//  Created by ruby on 14-11-23.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit

class ShowPayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var deTailTableView: UITableView!
    
    var cellReuseIdentifier: String = "payCell"
    var orders: Array<OrderItem> = OrderArchiver().getOrdesFromUserDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        
        setTableView()
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear: \(self)")
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
    // MARK: -TableView data source
    
    // 每个section显示行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("显示行数: \(self.orders.count)")
        return self.orders.count
    }
    
    // 设置cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.orders[indexPath.row].category + "   \(self.orders[indexPath.row].money)"
        
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
            self.orders.removeAtIndex(indexPath.row)
            OrderArchiver().saveOrdersToUserDefault(self.orders)
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
