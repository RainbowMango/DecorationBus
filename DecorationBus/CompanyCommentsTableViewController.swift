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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() // 清除tableView中空白行
        
        self._comments = requestCompanyComments(0, companyId: self._company.id)
        
//        //添加测试数据
//        let comment = CompanyComment()
//        comment.avatar   = "http://decorationbus.sinaapp.com/server/images/banner/ser01.jpg"
//        comment.nickname = "用户昵称"
//        comment.date     = "2015-12-11"
//        comment.score    = 87
//        comment.comment  = "还不错哦还不错哦还不错哦还不错哦还不错哦还不错哦还不错哦还不错哦还不错哦"
//        self._comments.append(comment)
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

    
}
