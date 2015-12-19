//
//  CompanyCommentsTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15/12/10.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit

class CompanyCommentsTableViewController: UITableViewController {

    var _company: CompanyCellData = CompanyCellData()
    var _comments: Array<CompanyComment> = Array<CompanyComment>()
    
    var tableFooter = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() // 清除tableView中空白行
        self.tableView.estimatedRowHeight = 120
        
        //IOS7不能很好支持该设置
        if #available(iOS 8, *) {
            self.tableView.rowHeight = UITableViewAutomaticDimension // cell 高度自适应
        }
        
        self._comments = requestCompanyComments(0, companyId: self._company.id)
        
        //添加上拉刷新控件
        tableFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "tableFooterRefresh")
        self.tableView.tableFooterView = tableFooter
        
        self.tableView.reloadData()
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
        return self._comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("companycommentcell", forIndexPath: indexPath) as! CompanyCommentTableViewCell

        cell.configureViews(self._comments[indexPath.row])
        
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

    // MARK: - Request And Refresh
    func requestCompanyComments(counter: Int, companyId: UInt) -> Array<CompanyComment> {
        let urlStr = REQUEST_COMPANY_COMMENTS_URL_STR + "?counter=\(counter)" + "&company=\(companyId)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            return parseComanyComments(data)
        }catch let error as NSError{
            print("网络异常--请求公司评论信息失败：" + error.localizedDescription)
        }
        
        return Array<CompanyComment>()
    }
    
    // 解析请求到的JSON数据
    func parseComanyComments(jsonData: NSData) -> Array<CompanyComment> {
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
            let itemNum = jsonStr.objectForKey("total") as! Int
            let items = jsonStr.objectForKey("row") as! NSArray
            
            var requestedCompanyComments = Array<CompanyComment>()
            for item in items {
                let comment = CompanyComment()
                comment.avatar   = item.objectForKey("avatar") as! String
                comment.nickname = item.objectForKey("nickname") as! String
                comment.date     = item.objectForKey("date") as! String
                comment.comment  = item.objectForKey("comment") as! String
                comment.score    = item.objectForKey("score") as! UInt
                //解析缩略图
                let thumbnail01: String = item.objectForKey("thumbnail01") as! String
                if(!thumbnail01.isEmpty) {comment.thumbnails.append(thumbnail01)}
                let thumbnail02: String = item.objectForKey("thumbnail02") as! String
                if(!thumbnail02.isEmpty) {comment.thumbnails.append(thumbnail02)}
                let thumbnail03: String = item.objectForKey("thumbnail03") as! String
                if(!thumbnail03.isEmpty) {comment.thumbnails.append(thumbnail03)}
                let thumbnail04: String = item.objectForKey("thumbnail04") as! String
                if(!thumbnail04.isEmpty) {comment.thumbnails.append(thumbnail04)}
                //解析源图
                let image01: String = item.objectForKey("image01") as! String
                if(!image01.isEmpty) {comment.originimages.append(image01)}
                let image02: String = item.objectForKey("image02") as! String
                if(!image02.isEmpty) {comment.originimages.append(image02)}
                let image03: String = item.objectForKey("image03") as! String
                if(!image03.isEmpty) {comment.originimages.append(image03)}
                let image04: String = item.objectForKey("image04") as! String
                if(!image04.isEmpty) {comment.originimages.append(image04)}
                
                requestedCompanyComments.append(comment)
            }
            
            //服务端返回的JSON有误时仅打印一条信息
            if(itemNum != requestedCompanyComments.count) {
                print("Warning: items number mismatch in json!")
            }
            
            return requestedCompanyComments
        }catch let error as NSError {
            print("解析JSON数据失败: " + error.localizedDescription)
        }
        
        return Array<CompanyComment>()
    }

    //上拉刷新
    func tableFooterRefresh() {
        // 追加每次请求到的数据
        let requestedCompanyComments = requestCompanyComments(self._comments.count, companyId: self._company.id)
        if(requestedCompanyComments.isEmpty) {
            self.tableFooter.endRefreshingWithNoMoreData()
            return
        }
        for item in requestedCompanyComments {
            self._comments.append(item)
        }
        
        self.tableFooter.endRefreshing()
        self.tableView.reloadData()
    }
}
