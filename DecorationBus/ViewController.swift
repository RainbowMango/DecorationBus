//
//  ViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate, UINavigationControllerDelegate, SDCycleScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIntro()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        initAlbum()
        setupScrollViewWithLocalImages()
        setupScrollViewWithRemoteImages()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    // 启动系统引导页
    func startIntro() -> Void {
        //判断是否第一次启动，如是则跳过引导
        if IntroducePageHandler().isIntroShown() {
            return
        }
        
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
        images.append(UIImage(named: "settings")!)
        images.append(UIImage(named: "settings")!)
        let w = self.view.bounds.size.width;
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 100, w, 180), imagesGroup: images)
        cycleScrollView.infiniteLoop = true
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView.autoScrollTimeInterval = 3.0
        self.view.addSubview(cycleScrollView)
    }
    
    func setupScrollViewWithRemoteImages() -> Void {
        var imagesURLStrings = [String]()
        imagesURLStrings.append("http://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=%E7%BE%8E%E5%A5%B3%E5%9B%BE%E7%89%87%E5%BA%93&pn=6&spn=0&di=146112292700&pi=&rn=1&tn=baiduimagedetail&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=4075987987%2C2813587320&os=257017418%2C2687922542&adpicid=0&ln=21&fr=ala&sme=&cg=&bdtype=0&objurl=http%3A%2F%2Fimg3.douban.com%2Fview%2Fphoto%2Fraw%2Fpublic%2Fp1569226503.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fftpj_z%26e3B157kwg_z%26e3Bv54AzdH3F89nbllAzdH3Fot12jpAzdH3Fri5p5fAzdH3F0lmn9a0AzdH3Fri5p5AzdH3F8cmlddmcanAzdH3F&gsm=0")
        imagesURLStrings.append("http://image.baidu.com/search/detail?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&cl=2&cm=1&sc=0&lm=-1&ie=gbk&pn=0&rn=1&di=48745245010&ln=21&word=%C3%C0%C5%AE%CD%BC%C6%AC%BF%E2&os=641242292,2435827036&cs=2253455426,2223617168&objurl=http%3A%2F%2Fc11.eoemarket.com%2Fapp0%2F403%2F403225%2Fscreen%2F2157036.jpg&bdtype=0&fr=ala&ori_query=%E7%BE%8E%E5%A5%B3%E5%9B%BE%E7%89%87%E5%BA%93&ala=0&alatpl=sp&pos=1")
        
        var titles = [String]()
        titles.append("谢谢支持")
        titles.append("谢谢支持")
        
        let w = self.view.bounds.size.width;
        
        
        let cycleScrollView = SDCycleScrollView(frame: CGRectMake(0, 320, w, 180), imageURLStringsGroup: imagesURLStrings)
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.delegate = self
        cycleScrollView.titlesGroup = titles
        cycleScrollView.dotColor = UIColor.blackColor()
        cycleScrollView.placeholderImage = UIImage(named: "settings")
        self.view.addSubview(cycleScrollView)
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
}

