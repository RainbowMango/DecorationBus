//
//  ManagerTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15/12/29.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class ManagerTableViewController: UITableViewController {

    var tableHeader = MJRefreshNormalHeader()
    var tableFooter = MJRefreshAutoNormalFooter()
    var managers    = Array<ManagerCellData>()
    
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
        
        self.tableHeader.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.managers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //从队列中获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("managerItem", forIndexPath: indexPath) as! ManagerTableViewCell
        
        // 更新cell数据
        if(indexPath.row > self.managers.count) {
            print("警告：当前source数量\(self.managers.count), 当前cell行数\(indexPath.row)")
            return cell
        }
        
        cell.configureViews(self.managers[indexPath.row])
        
        return cell
    }
    
    // MARK: - table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showManagerCommentsSegue", sender: self.view)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dstVC       = segue.destinationViewController as! ManagerCommentsTableViewController
        let indexPath   = self.tableView.indexPathForSelectedRow
        self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        dstVC.hidesBottomBarWhenPushed = true
        
        // 传递选中的cell信息到下一个view
        dstVC._manager = managers[indexPath!.row]
    }
    
    // MARK: - Refresh
    
    func requestManagers(counter: Int) -> Array<ManagerCellData> {
        let urlStr = REQUEST_MANAGERS_URL_STR + "?counter=\(counter)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            return parseManagers(data)
        }catch let error as NSError{
            print("网络异常--请求项目经理信息失败：" + error.localizedDescription)
        }
        
        return Array<ManagerCellData>()
    }
    
    // 解析请求到的JSON数据
    func parseManagers(jsonData: NSData) -> Array<ManagerCellData> {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray
            
            var requestedManagers = Array<ManagerCellData>()
            for item in items {
                let artist = ManagerCellData()
                artist.id = item.objectForKey("id") as! UInt
                artist.name = item.objectForKey("name") as! String
                artist.avatar = item.objectForKey("avatar") as! String
                artist.companyName = item.objectForKey("company") as! String
                artist.commentsNum = item.objectForKey("comments") as! UInt
                artist.score = item.objectForKey("score") as! UInt
                requestedManagers.append(artist)
            }
            
            //服务端返回的JSON有误时仅打印一条信息
            if(itemNum != requestedManagers.count) {
                print("Warning: items number mismatch in json!")
            }
            
            return requestedManagers
        }catch let error as NSError {
            print("解析JSON数据失败: " + error.localizedDescription)
        }
        
        return Array<ManagerCellData>()
    }
    
    //下拉刷新
    func tableHeaderRefresh() {
        //注意：改变data source和reload务必放到一个queue里执行，否则reload时有一定几率crash
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let requestedManagers = self.requestManagers(0)
            
            //只有在成功请求到数据时才改变数据源
            if(!requestedManagers.isEmpty) {
                self.managers = requestedManagers
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
        let requestedManagers = requestManagers(self.managers.count)
        if(requestedManagers.isEmpty) {
            self.tableFooter.endRefreshingWithNoMoreData()
            return
        }
        for manager in requestedManagers {
            self.managers.append(manager)
        }
        
        self.tableFooter.endRefreshing()
        self.tableView.reloadData()
    }
}
