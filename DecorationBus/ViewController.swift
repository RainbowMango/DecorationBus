//
//  ViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIntro()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        initAlbum()
        //setupScrollViewWithLocalImages()
        setupScrollViewWithRemoteImages()
        
        self.tableView.tableFooterView = UIView() // 清楚tableView中空白行
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //添加下拉刷新
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 启动友盟统计
        MobClick.beginLogPageView("首页")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 启动友盟统计
        MobClick.endLogPageView("首页")
        
    }
    
    // 启动系统引导页
    func startIntro() -> Void {
        //判断是否第一次启动，如是则跳过引导
        if IntroducePageHandler().isIntroShown() {
            return
        }
        
        UIApplication.sharedApplication().statusBarHidden = true
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true

        let item1 = RMParallaxItem(image: UIImage(named: "intr001")!, text: "装修路上处处陷阱...")
        let item2 = RMParallaxItem(image: UIImage(named: "intr002")!, text: "低价往往不是让利促销...")
        let item3 = RMParallaxItem(image: UIImage(named: "intr003")!, text: "设计师的时间总是伴随着利益...")
        let item4 = RMParallaxItem(image: UIImage(named: "intr004")!, text: "装修增项让人防不胜防...")
        let item5 = RMParallaxItem(image: UIImage(named: "intr005")!, text: "我们, 只是想让装修更简单一点点...")
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4, item5], motion: false)
        
        //定义结束引导页行为，显示导航栏，TAB栏
        rmParallaxViewController.completionHandler = {
            UIApplication.sharedApplication().statusBarHidden = false
            self.navigationController?.navigationBarHidden = false
            self.tabBarController?.tabBar.hidden = false
            UIView.animateWithDuration(0.4, animations: { () -> Void in

                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
        
        //增加标志以让下次启动不再显示引导页
        IntroducePageHandler().setIntroShown()
    }

    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }
    
    // 初始化类别列表，程序启动时拷贝资源文件到沙盒
    func initCategory() {
        CategoryHandler().copyFileToSandbox()
    }
    
    // 初始化相册列表，程序启动时拷贝资源文件到沙盒
    func initAlbum() {
        AlbumHandler().copyFileToSandbox()
    }
    
    func setupScrollViewWithLocalImages() -> Void {
        var images = [UIImage]()
        images.append(UIImage(named: "index.jpg")!)
        images.append(UIImage(named: "index.jpg")!)
        images.append(UIImage(named: "index.jpg")!)
        images.append(UIImage(named: "index.jpg")!)
        let w = self.view.bounds.size.width;
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 100, w, 180), imagesGroup: images)
        cycleScrollView.infiniteLoop = true
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView.autoScrollTimeInterval = 3.0
        
        self.tableView.tableHeaderView = cycleScrollView
    }
    
    func setupScrollViewWithRemoteImages() -> Void {
        var imagesURLStrings = [String]()
        imagesURLStrings.append("http://decorationbus.sinaapp.com/server/images/banner/ser01.jpg")
        imagesURLStrings.append("http://decorationbus.sinaapp.com/server/images/banner/ser02.jpg")
        imagesURLStrings.append("http://decorationbus.sinaapp.com/server/images/banner/ser03.jpg")
        imagesURLStrings.append("http://decorationbus.sinaapp.com/server/images/banner/ser04.jpg")
        
        var titles = [String]()
        titles.append("该产品属于开源公益项目, 不已盈利为目的")
        titles.append("目前处于开发内测阶段，功能尚不完善")
        titles.append("我们只是想让装修简单一点点")
        titles.append("欢迎加入我们一起开发")
        
        let w = self.view.bounds.size.width;
        
        
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 320, w, 180), imageURLStringsGroup: imagesURLStrings)
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.delegate = self
        cycleScrollView.titlesGroup = titles
        cycleScrollView.dotColor = UIColor.blackColor()
        cycleScrollView.autoScrollTimeInterval = 3.0
        cycleScrollView.placeholderImage = UIImage(named: "index.jpg")
        
        self.tableView.tableHeaderView = cycleScrollView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tab bar 切换时重新加载数据
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
    
    // 导航回来时刷新数据
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
    }
    
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        print("用户点击了第%d张图片", index)
    }
    
    //MARK: - tableView data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNum = 0
        switch section {
        case 0:
            rowNum = 1
        case 1:
            rowNum = 3
        default:
            rowNum = 0
        }
        
        return rowNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MainServiceTableViewCell", forIndexPath: indexPath) as! MainServiceTableViewCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("activitiesCell")
            cell?.imageView?.image = UIImage(named: "ser01.png")
            cell?.textLabel?.text = "这里是活动内容这里是活动内容这里是活动内容这里是活动内容这里是活动内容这里是活动内容"
            cell?.detailTextLabel?.text = "这里是detail活动内容这里是活动内容这里是活动内容这里是活动内容这里是活动内容这里是活动内容"
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight: CGFloat = 44
        
        switch indexPath.section{
        case 0:
            cellHeight =  self.view.bounds.height * 0.15
        case 1:
            cellHeight =  44
            
        default:
            print("使用默认高度")
        }
        
        return cellHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = String()
        switch section {
        case 0:
            title = "精选服务"
        case 1:
            title = "热门活动"
        default:
            title = "未定义"
        }
        
        return title
    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let screenWith = self.view.bounds.width
//        
//        switch section {
//        case 0:
//            let headerView = UIView(frame: CGRectMake(0, 0, screenWith, 20))
//            let leftLable = UILabel(frame: CGRectMake(10, 5, screenWith/2 - 10, 20))
//            leftLable.text = "精选服务"
//            headerView.addSubview(leftLable)
//            
////            let rightLable = UILabel(frame: CGRectMake(screenWith/2 + 10, 5, screenWith/2 - 20, 20))
////            rightLable.text = "显示更多 >>   "
////            rightLable.textAlignment = NSTextAlignment.Right
////            headerView.addSubview(rightLable)
//            
//            return headerView
//        case 1:
//            let headerView = UIView(frame: CGRectMake(0, 0, screenWith, 20))
//            let leftLable = UILabel(frame: CGRectMake(10, 5, screenWith/2 - 10, 20))
//            leftLable.text = "热门活动"
//            headerView.addSubview(leftLable)
//            
//            return headerView
//        default:
//            return nil
//        }
//    }
    
    //MARK: - tableView delegate
    
    // 刷新数据
    func refreshData() {
        // 刷新逻辑
        NSThread.sleepForTimeInterval(2.0)
        print("从服务器获取数据成功")
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}

