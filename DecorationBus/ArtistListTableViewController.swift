//
//  ArtistListTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15/12/23.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class ArtistListTableViewController: UITableViewController {
    
    var tableHeader = MJRefreshNormalHeader()
    var tableFooter = MJRefreshAutoNormalFooter()
    var artists     = Array<ArtistCellData>()
    
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
        return self.artists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //从队列中获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier("artistItem", forIndexPath: indexPath) as! ArtistTableViewCell
        
        // 更新cell数据
        if(indexPath.row > self.artists.count) {
            print("警告：当前source数量\(self.artists.count), 当前cell行数\(indexPath.row)")
            return cell
        }
        
        cell.configureViews(self.artists[indexPath.row])
        
        return cell
    }
    
    // MARK: - table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showArtistCommentsSegue", sender: self.view)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - Refresh
    
    func requestArtists(counter: Int) -> Array<ArtistCellData> {
        let urlStr = REQUEST_ARTISTS_URL_STR + "?counter=\(counter)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            return parseArtists(data)
        }catch let error as NSError{
            print("网络异常--请求公司信息失败：" + error.localizedDescription)
        }
        
        return Array<ArtistCellData>()
    }
    
    // 解析请求到的JSON数据
    func parseArtists(jsonData: NSData) -> Array<ArtistCellData> {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray
            
            var requestedArtists = Array<ArtistCellData>()
            for item in items {
                let artist = ArtistCellData()
                artist.id = item.objectForKey("id") as! UInt
                artist.name = item.objectForKey("name") as! String
                artist.avatar = item.objectForKey("avatar") as! String
                artist.companyName = item.objectForKey("company") as! String
                artist.commentsNum = item.objectForKey("comments") as! UInt
                artist.score = item.objectForKey("score") as! UInt
                requestedArtists.append(artist)
            }
            
            //服务端返回的JSON有误时仅打印一条信息
            if(itemNum != requestedArtists.count) {
                print("Warning: items number mismatch in json!")
            }
            
            return requestedArtists
        }catch let error as NSError {
            print("解析JSON数据失败: " + error.localizedDescription)
        }
        
        return Array<ArtistCellData>()
    }
    
    //下拉刷新
    func tableHeaderRefresh() {
        //注意：改变data source和reload务必放到一个queue里执行，否则reload时有一定几率crash
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let requestedArtists = self.requestArtists(0)
            
            //只有在成功请求到数据时才改变数据源
            if(!requestedArtists.isEmpty) {
                self.artists = requestedArtists
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
        let requestedArtists = requestArtists(self.artists.count)
        if(requestedArtists.isEmpty) {
            self.tableFooter.endRefreshingWithNoMoreData()
            return
        }
        for artist in requestedArtists {
            self.artists.append(artist)
        }
        
        self.tableFooter.endRefreshing()
        self.tableView.reloadData()
    }
}
