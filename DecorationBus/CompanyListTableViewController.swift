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
    var tableFooter = MJRefreshAutoNormalFooter()
    var companies   = Array<CompanyCellData>()
    
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
        return self.companies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //从队列中获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("companyItem", forIndexPath: indexPath) as! CompanyTableViewCell

        // 更新cell数据
        if(indexPath.row > self.companies.count) {
            print("警告：当前source数量\(self.companies.count), 当前cell行数\(indexPath.row)")
            return cell
        }
        
        cell.configureViews(self.companies[indexPath.row])

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
    
    func requestCompanies(counter: Int) -> Int {
        let urlStr = REQUEST_COMPANIES_URL_STR + "?counter=\(counter)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            return parseComanies(data)
        }catch {
            print("网络异常")
        }
        
        return 0
    }
    
    // 解析请求到得JSON数据，追加到table view source
    func parseComanies(jsonData: NSData) -> Int {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray

            for item in items {
                let company = CompanyCellData()
                company.id = item.objectForKey("id") as! UInt
                company.name = item.objectForKey("name") as! String
                company.logoPath = item.objectForKey("logo") as! String
                company.commentsNum = item.objectForKey("comments") as! UInt
                company.score = item.objectForKey("score") as! UInt
                self.companies.append(company)
            }
            return itemNum
        }catch {
            print("解析JSON数据失败")
        }
        
        return 0
    }
    
    //下拉刷新
    func tableHeaderRefresh() {
        //注意：改变data source和reload务必放到一个queue里执行，否则reload时有一定几率crash
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.companies.removeAll()
            self.requestCompanies(0)
            self.tableView.reloadData()//重新请求数据
        }
        
        self.tableHeader.endRefreshing()
        
        //重置没有更多的数据（消除没有更多数据的状态）
        self.tableFooter.resetNoMoreData()
    }
    
    //上拉刷新
    func tableFooterRefresh() {
        // 追加每次请求到的数据
        let num = requestCompanies(self.companies.count)
        
        //根据是否还有数据设置footer的状态
        (num > 0) ? self.tableFooter.endRefreshing() : self.tableFooter.endRefreshingWithNoMoreData()
        
        self.tableView.reloadData()
    }
}
