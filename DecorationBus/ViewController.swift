//
//  ViewController.swift
//  DecorationBus
//
//  Created by ruby on 14-10-15.
//  Copyright (c) 2014年 ruby. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIntro()
        setViewColor()
        self.tabBarController?.delegate = self
        self.navigationController?.delegate = self
        initCategory()
        initAlbum()
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
}

