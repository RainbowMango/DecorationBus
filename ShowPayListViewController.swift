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
        println("viewDidLoad() \(self)")
        super.viewDidLoad()
        
        initTableView()

        orders = OrderArchiver().getOrdesFromUserDefault()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Init functions
    
    // 初始化table view
    func initTableView() {
        self.deTailTableView.dataSource = self
        self.deTailTableView.delegate = self
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
