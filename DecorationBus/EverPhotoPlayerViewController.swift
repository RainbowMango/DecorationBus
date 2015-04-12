//
//  EverPhotoPlayerViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-28.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class EverPhotoPlayerViewController: MWPhotoBrowser {

    //图片列表以及当前选中的图片index
    var imageURLs: Array<String> = Array<String>()
    var curImageIndex: Int = 0
    var albumName: String = String()
    
    // 声明代理方法，可以监听本页面返回动作
    var myDelegate: EverPhotoPlayerViewControllerDelegate?
    var parentView: EverPhotoAlbumCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteButtonPressed")
        self.navigationItem.rightBarButtonItem = delButton
        
        
        // Create browser
        self.displayActionButton = true  //Show action button to allow sharing, copying, etc (defaults to YES)
        self.displayNavArrows = true     //Whether to display left and right nav arrows on toolbar (defaults to NO)
        self.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
        self.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        self.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        self.zoomPhotosToFill = true;
        self.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        self.startOnGrid = false // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        self.enableSwipeToDismiss = true;
        self.setCurrentPhotoIndex(UInt(curImageIndex))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("imageURLs: \(self.imageURLs)")
        println("curImageIndex: \(self.curImageIndex)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deleteButtonPressed() {
        self.myDelegate = parentView
        self.myDelegate?.removeImage(Int(currentIndex))
        
        //TODO: 删除图片后无法刷新
        reloadData()
    }
}

// 定义代理，用于向前个view传递最新的图片列表
protocol EverPhotoPlayerViewControllerDelegate {
    func currentImageURLs(curImageURLs: Array<String>) -> Void
    func removeImage(index: Int) -> Void
}
