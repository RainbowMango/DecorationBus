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
    let pointMessageView_ = PointMessageViewController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        initAlbum()
        //setupScrollViewWithLocalImages()
        setupScrollViewWithRemoteImages()
        addPointMessageView()
        
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
        var titles = [String]()
        titles.append("该产品属于开源公益项目, 不以盈利为目的")
        titles.append("目前处于开发内测阶段，功能尚不完善")
        titles.append("我们只是想让装修简单一点点")
        titles.append("欢迎加入我们一起开发")
        
        let w = self.view.bounds.size.width;
        
        
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 320, w, 180), imageURLStringsGroup: REQUEST_INDEX_BANNERS_URL_STR)
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
            cell?.imageView?.image = UIImage(named: "github.png")
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "招募产品经理"
                cell?.detailTextLabel?.text = "要求不多，只要会画图就行啦~"
            case 1:
                cell?.textLabel?.text = "招募IOS开发工程师"
                cell?.detailTextLabel?.text = "需要Swift工程师，如果也懂OC就更好了！"
            case 2:
                cell?.textLabel?.text = "招募视觉设计"
                cell?.detailTextLabel?.text = "有想法，会抠图，急需，急需！"
            default:
                cell?.textLabel?.text = "未定义的活动"
                cell?.detailTextLabel?.text = "未定义的活动"
            }
            
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pointMessageView_.setMessageView(0, withMessage: "可以通过“提交反馈”功能联系我")
        pointMessageView_.removeMessageView(0);
    }
    
    // 刷新数据
    func refreshData() {
        // 刷新逻辑
        NSThread.sleepForTimeInterval(2.0)
        print("从服务器获取数据成功")
        
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //MARK: - Service跳转

    @IBAction func service1Selected(sender: UITapGestureRecognizer) {
//        print("点击了第一个service")
//        pointMessageView_.setMessageView(0, withMessage: "功能还在开发中")
//        pointMessageView_.removeMessageView(0);
        print("service1Selected: 转入装修公司列表view")
        performSegueWithIdentifier("segueToCompanyList", sender: self.view)
    }
    @IBAction func service2Selected(sender: UITapGestureRecognizer) {
        print("点击了第二个service")
        pointMessageView_.setMessageView(0, withMessage: "功能还在开发中")
        pointMessageView_.removeMessageView(0);
    }
    @IBAction func service3Selected(sender: UITapGestureRecognizer) {
        print("点击了第三个service")
        pointMessageView_.setMessageView(0, withMessage: "功能还在开发中")
        pointMessageView_.removeMessageView(0);
    }
    @IBAction func service4Selected(sender: UITapGestureRecognizer) {
        print("点击了第四个service")
        pointMessageView_.setMessageView(0, withMessage: "功能还在开发中")
        pointMessageView_.removeMessageView(0);
    }
    
    //MARK: - 消息气泡
    
    
    //添加消息弹出界面
    func addPointMessageView()
    {
        let viewSize:CGSize = self.view.frame.size;
        let viewHeight:CGFloat = viewSize.height;
        let viewWidth:CGFloat = viewSize.width;
        
        let pointMessageViewRect:CGRect = CGRectMake((viewWidth - 120) / 2,
            (viewHeight - 150) / 1,
            120,
            50);
        pointMessageView_.view.frame = pointMessageViewRect;
        
        self.view.addSubview(pointMessageView_.view);
        
    }
}

