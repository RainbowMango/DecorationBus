//
//  EverPhotoPlayerViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-28.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

/*
本类用于扩展MWPhotoBrowser，以增加删除按钮
在继承过程中出现错误：“error: cannot override 'init' which has been marked unavailable”
修改了MWPhotoBrowser.h中部分代码
修改前
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate NS_DESIGNATED_INITIALIZER;
修改后
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate NS_DESIGNATED_INITIALIZER;
参考链接：http://stackoverflow.com/questions/26958155/subclassing-objective-c-classes-in-swift
*/
class EverPhotoPlayerViewController: MWPhotoBrowser {
    // 接收前一ViewController实例，用于发送代理
    var parentView: EverPhotoAlbumCollectionViewController?
    
    // 声明代理实例
    var myDelegate: EverPhotoPlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        // 添加删除按钮
        let delButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteButtonPressed")
        self.navigationItem.rightBarButtonItem = delButton
        
        // 设置MWPhotoBrowser属性
        self.displayActionButton = true  //Show action button to allow sharing, copying, etc (defaults to YES)
        self.displayNavArrows = true     //Whether to display left and right nav arrows on toolbar (defaults to NO)
        self.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
        self.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        self.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        self.zoomPhotosToFill = true;
        self.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        self.startOnGrid = false // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        self.enableSwipeToDismiss = true;
        
        // super viewDidLoad属性需要在自定义属性设置之后执行，否则会使用默认值
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deleteButtonPressed() {
        // 给父view发送代理，通知图片删除
        self.myDelegate = parentView
        self.myDelegate?.EverPhotoPlayerView(willRemoveImage: currentIndex)
        
        // 刷新
        reloadData()
    }
}

// 定义代理，用于向前个view传递最新的图片列表
protocol EverPhotoPlayerViewControllerDelegate {
    func EverPhotoPlayerView(willRemoveImage index: UInt)
}
