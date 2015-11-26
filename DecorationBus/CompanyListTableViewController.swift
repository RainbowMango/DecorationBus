//
//  CompanyListTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15/11/18.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class CompanyListTableViewController: UITableViewController {

    var tableHeader = MJRefreshNormalHeader()
    //var tableFooter = MJRefreshBackNormalFooter()
    var tableFooter = MJRefreshAutoNormalFooter()
    var companyList = Array<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //解决tableview和导航之间留白，留白尺寸=状态栏高度+导航栏的高度+10
        let navbarHeight = self.navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        self.tableView.contentInset = UIEdgeInsetsMake(0 + 10 - statusBarHeight - navbarHeight!, 0, 0, 0)
        
        //添加下拉刷新控件
        tableHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "tableHeaderRefresh")
        tableHeader.automaticallyChangeAlpha = true
        self.tableView.tableHeaderView = tableHeader
        
        //添加上拉刷新控件
        tableFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "tableFooterRefresh")
        self.tableView.tableFooterView = tableFooter
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableHeader.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.companyList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //将源数据转换
        let cellData = CompanyCellData()
        cellData.name = "测试公司名字"
        cellData.commentsNum = indexPath.row
        cellData.score = indexPath.row * 10 + 5
        
        //从队列中获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("companyItem", forIndexPath: indexPath) as! CompanyTableViewCell

        // Configure the cell...
        cell.configureViews(cellData)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - MJRefresh
    func tableHeaderRefresh() {
        NSThread.sleepForTimeInterval(1.0)
        
        //重新请求数据
        self.companyList.removeAll()
        for(var i = 0; i < 20; i++) {
            self.companyList.append(i)
        }
        
        print("下拉刷新了")
        self.tableHeader.endRefreshing()
        self.tableView.reloadData()
        
        //重置没有更多的数据（消除没有更多数据的状态）
        self.tableFooter.resetNoMoreData()
    }
    
    func tableFooterRefresh() {
        NSThread.sleepForTimeInterval(1.0)
        
        // 追加每次请求到的数据
        let currentCount = self.companyList.count
        for(var i = currentCount; i < currentCount + 20; i++) {
            self.companyList.append(i)
        }
        print("上拉刷新了")
        
        self.tableFooter.endRefreshing()//后续还有数据
        
        if(self.companyList.count >= 60) {
            self.tableFooter.endRefreshingWithNoMoreData() //没数据了
        }
        
        self.tableView.reloadData()
    }
}
