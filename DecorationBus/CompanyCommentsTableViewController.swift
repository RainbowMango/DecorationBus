//
//  CompanyCommentsTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15/12/10.
//  Copyright © 2015年 ruby. All rights reserved.
//

import UIKit
import MJRefresh
import MWPhotoBrowser

class CompanyCommentsTableViewController: UITableViewController, MWPhotoBrowserDelegate {

    var _company: CompanyCellData = CompanyCellData()
    var _comments: Array<CompanyComment> = Array<CompanyComment>()
    
    var tableFooter = MJRefreshAutoNormalFooter()
    
    var photoBrowserSource = Array<MWPhoto>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self._company.name //设置导航栏标题
        
        self.tableView.tableFooterView = UIView() // 清除tableView中空白行
        self.tableView.estimatedRowHeight = 160 //预估高度要大于SB中最小高度，否则cell可能被压缩
        self.tableView.rowHeight = UITableViewAutomaticDimension // cell 高度自适应
        
        self._comments = requestCompanyComments(0, companyId: self._company.id)
        
        //添加上拉刷新控件
        tableFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(CompanyCommentsTableViewController.tableFooterRefresh))
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

        let commentsData = self._comments[indexPath.row]
        cell.configureViews(commentsData)
        
        /**
         给cell内图片添加点击手势
         注：在SB中添加不成功，原因不明，错误信息如下
         2015-12-20 14:32:46.155 DecorationBus[26381:1098727] WARNING:
         A Gesture recognizer (<UITapGestureRecognizer: 0x7fb3f155f070; state = Possible; view = <UIImageView 0x7fb3f39855b0>; target= <(action=imageTapped:, target=<DecorationBus.CompanyCommentsTableViewController 0x7fb3f1725fd0>)>>)
         was setup in a storyboard/xib to be added to more than one view (-><UIImageView: 0x7fb3f3994650; frame = (0 0; 69 69); autoresize = RM+BM; gestureRecognizers = <NSArray: 0x7fb3f39a2b50>; layer = <CALayer: 0x7fb3f3991700>>) at a time,
         this was never allowed, and is now enforced.
         Beginning with iOS 9.0 it will be put in the first view it is loaded into.
        */
        cell.removeImagesGesture()
        for index in 0..<commentsData.thumbnails.count {
            let viewTag = indexPath.row * 100 + index
            cell.configureImageGesture(index, target: self, action: #selector(CompanyCommentsTableViewController.imageTapped(_:)), tag: viewTag)
        }
        
        return cell
    }

    /*
    处理图片点击动作
    注意：不能使用tableView.indexPathForSelectedRow获取点击cell行数，因为图片获取点击动作后默认不再传递给tableView.
    */
    func imageTapped(gesture: UITapGestureRecognizer) {
        let cellRow = (gesture.view?.tag)! / 100
        let imageIndex = (gesture.view?.tag)! % 100
        
        //将改行的图片URL赋给图片浏览器数据源
        let originImages = self._comments[cellRow].originimages
        photoBrowserSource.removeAll()
        for image in originImages {
            let imageURL = NSURL(string: image)
            let mwPhoto = MWPhoto(URL: imageURL)
            photoBrowserSource.append(mwPhoto)
        }
        
        //创建图片浏览器并设置
        let browser = MWPhotoBrowser(delegate: self)
        browser.displayActionButton = false; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = false; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = false; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = true; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = false; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = false; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = false; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = false; // Auto-play first video
        
        //启动浏览器
        browser.setCurrentPhotoIndex(UInt(imageIndex))
        self.navigationController?.pushViewController(browser, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("用户点击了cell: \(indexPath.row)")
    }
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photoBrowserSource.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(photoBrowserSource.count) {
            return self.photoBrowserSource[Int(index)]
        }
        
        return nil;
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentSegue" {
            let destinationView = segue.destinationViewController as! CommentTableViewController
            let reviewItems = ["设计水平", "施工质量", "服务", "性价比"]
            destinationView.setValue(reviewItems, forKey: "reviewItems")
            destinationView.delegate = self
        }
    }
    
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

extension CompanyCommentsTableViewController: CommentTableViewControllerDelegate {
    func SubmitComments(comment: Comment) -> Bool {
        print("收到代理方法，我自己提交comments")
        return true
    }
}