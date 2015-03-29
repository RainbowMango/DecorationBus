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

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        println("imageURLs: \(self.imageURLs)")
        println("curImageIndex: \(self.curImageIndex)")
        self.scrollview.delegate = self
        
        loadImage()
        
        //定位到第二个imageView
        self.scrollview.contentOffset = CGPointMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 0)
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
    
    func loadImage() -> Void {
        firstImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex - 1])
        secondImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex])
        thirdImageView.image = UIImage(contentsOfFile: imageURLs[curImageIndex + 1])
    }

//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        println("scrollViewDidScroll: contentOffset = \(scrollview.contentOffset)")
//    }
//    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        println("scrollViewWillBeginDragging")
//    }
//    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        println("scrollViewWillEndDragging")
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        println("scrollViewDidEndDragging")
//    }
}
