//
//  EverPhotoPlayerViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-28.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class EverPhotoPlayerViewController: UIViewController, UIScrollViewDelegate {

    //图片列表以及当前选中的图片index
    var imageURLs: Array<String> = Array<String>()
    var curImageIndex: Int = 0
    
    @IBOutlet weak var scrollviewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondImageViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var secondImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollview.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        println("imageURLs: \(self.imageURLs)")
        println("curImageIndex: \(self.curImageIndex)")
        
        loadImageWhenAppear()
        
        //定位到第二个imageView
        self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0)
    }
    
    /*view消失时取消代理，否则仍然会收到代理消息导致crash,原因不明*/
    override func viewDidDisappear(animated: Bool) {
        self.scrollview.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 动态更新约束以满足不同屏幕尺寸
    override func updateViewConstraints() {
        super.updateViewConstraints() // 更新约束时必须要调用改方法通知本view，否则crash
        //println("更新约束前scrollview宽度:\(self.scrollviewWidthConstraint.constant)")
        self.scrollviewWidthConstraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds) * 3
        //println("更新约束后scrollview宽度:\(self.scrollviewWidthConstraint.constant)")
        self.firstImageViewWidthConstraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.secondImageViewLeadingContraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.secondImageViewWidthConstraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.thirdImageViewLeadingConstraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds) * 2
        self.thirdImageViewWidthConstraint.constant = CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    
    /*初次载入图片，永远将当前图片放入第二个imageView，当前图片的前后两张图片分别放入第一三个imageView*/
    func loadImageWhenAppear() -> Void {
        /*改动思路
        1. 永远将当前图片放置到中间的imageView
        1.1 如果只有一张图片，不允许滑动
        1.2 如果有两张图片
        1.2.1 如果当前图片是第一张，将第二张图片放到第三个imageView
        1.2.1.1 向左滑动时归正contentoffset至第二张imageView，即不允许向左滑动
        1.2.1.2 向右滑动时正常显示不做特殊处理
        1.3 如果有三张及以上图片时
        1.3.1 如果当前图片是第一张，处理同1.2.1.1
        1.3.2 向左滑动时发现当前已经是第一张，处理同1.2.1.1
        1.3.3 向右滑动时发现当前已经是最后一张，处理同1.2.1.1
        1.3.4 向右滑动时先显示右边图片，同时将右边图片也放到中间imageView里，再将contentoffset设置到第二张imageView 然后将第一、三个imageView,更新*/
        
        // 当前图片是第一张时不载入
        if curImageIndex > 0 {
            firstImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex - 1])
        }
        
        secondImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex])
        
        // 当前图片是最后一张时不载入
        if curImageIndex < (imageURLs.count - 1) {
            thirdImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex + 1])
        }
    }

    /*检测滑动方向，第一张图片向左滑动时及最后一张图片向右滑动时归正contentOffset*/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.scrollview.contentOffset.x > secondImageView.frame.origin.x {
            if curImageIndex == imageURLs.count - 1 {
                self.scrollview.setContentOffset(CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0), animated: false)
                println("最后一张图片，禁止右划")
            }
        }
        else if scrollview.contentOffset.x < secondImageView.frame.origin.x{
            if curImageIndex == 0 {
                self.scrollview.setContentOffset(CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0), animated: false)
                println("第一张图片，禁止左划")
            }
        }
    }
//
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        println("scrollViewWillBeginDragging")
//    }
//    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        println("scrollViewWillEndDragging")
//    }
//    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        println("scrollViewDidEndDragging")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var pageWidth:CGFloat = scrollview.frame.size.width
        var pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)) + 1
        
        switch pageNumber {
        case 0:
            println("当前显示的是第1页，需要在第二个imageView中加载本图片，并调整contentOffset至第二个ImageView")
            self.curImageIndex--
            loadImageWhenAppear()
            self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0)
        case 1:
            println("当前显示的是第2页，不改变")
        case 2:
            println("当前显示的是第3页，需要在第二个imageView中加载本图片，并调整contentOffset至第二个ImageView")
            self.curImageIndex++
            loadImageWhenAppear()
            self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0)
        default:
            println("Do nothing")
        }
    }
}