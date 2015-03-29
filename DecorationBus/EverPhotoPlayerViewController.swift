//
//  EverPhotoPlayerViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-28.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class EverPhotoPlayerViewController: UIViewController {

    //图片列表以及当前选中的图片index
    var imageURLs: Array<String> = Array<String>()
    var curImageIndex: Int = 0
    
    @IBOutlet weak var scrollviewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondImageViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var secondImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdImageViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        println("imageURLs: \(self.imageURLs)")
        println("curImageIndex: \(self.curImageIndex)")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
