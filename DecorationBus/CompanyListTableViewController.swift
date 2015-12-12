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

    // MARK: - table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showCompanyCommentsSegue", sender: self.view)
        
//        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text
//        hud.labelText = "敬请期待"
//        hud.detailsLabelText = "功能正在开发中，接下来可以查看和点评"
//        hud.hide(true, afterDelay: 1)
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

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dstVC       = segue.destinationViewController as! CompanyCommentsTableViewController
        let indexPath   = self.tableView.indexPathForSelectedRow
        self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        dstVC.hidesBottomBarWhenPushed = true
        
        // 传递选中的cell信息到下一个view
        dstVC._company = companies[indexPath!.row]
    }

    // MARK: - Refresh
    
    func requestCompanies(counter: Int) -> Array<CompanyCellData> {
        let urlStr = REQUEST_COMPANIES_URL_STR + "?counter=\(counter)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            return parseComanies(data)
        }catch let error as NSError{
            print("网络异常--请求公司信息失败：" + error.localizedDescription)
        }
        
        return Array<CompanyCellData>()
    }
    
    // 解析请求到的JSON数据
    func parseComanies(jsonData: NSData) -> Array<CompanyCellData> {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray

            var requestedCompanies = Array<CompanyCellData>()
            for item in items {
                let company = CompanyCellData()
                company.id = item.objectForKey("id") as! UInt
                company.name = item.objectForKey("name") as! String
                company.logoPath = item.objectForKey("logo") as! String
                company.commentsNum = item.objectForKey("comments") as! UInt
                company.score = item.objectForKey("score") as! UInt
                requestedCompanies.append(company)
            }
            
            //服务端返回的JSON有误时仅打印一条信息
            if(itemNum != requestedCompanies.count) {
                print("Warning: items number mismatch in json!")
            }
            
            return requestedCompanies
        }catch let error as NSError {
            print("解析JSON数据失败: " + error.localizedDescription)
        }
        
        return Array<CompanyCellData>()
    }
    
    //下拉刷新
    func tableHeaderRefresh() {
        //注意：改变data source和reload务必放到一个queue里执行，否则reload时有一定几率crash
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let requestedCompanies = self.requestCompanies(0)
            
            //只有在成功请求到数据时才改变数据源
            if(!requestedCompanies.isEmpty) {
                self.companies = requestedCompanies
            }
            
            self.tableHeader.endRefreshing()
            self.tableView.reloadData()//重新请求数据
        }

        //重置没有更多的数据（消除没有更多数据的状态）
        self.tableFooter.resetNoMoreData()
    }
    
    //上拉刷新
    func tableFooterRefresh() {
        // 追加每次请求到的数据
        let requestedCompanies = requestCompanies(self.companies.count)
        if(requestedCompanies.isEmpty) {
            self.tableFooter.endRefreshingWithNoMoreData()
            return
        }
        for company in requestedCompanies {
            self.companies.append(company)
        }
        
        self.tableFooter.endRefreshing()
        self.tableView.reloadData()
    }
}
