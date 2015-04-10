//
//  EverPhotoTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-2-4.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

class EverPhotoTableViewController: UITableViewController, MWPhotoBrowserDelegate {

    var phase_ = ["素颜", "设计", "改造", "水电", "木工", "泥工", "油漆", "墙纸", "软装"]
    var phaseTips_ = ["开始动工前，给您的爱家留个影吧~", "设计图纸存档，方便后期查看哦~", "我的房子我做主，想要几房要房~", "线管走向务必拍照哦，后期打洞洞不小心打到了可不是闹着玩滴~", "除了秀下木工师傅手艺，还能干嘛~", "瓷砖贴上大大提升房主逼格~", "我家的样子开始显现了哦~", "墙纸还是壁画？还是墙纸吧，谁用谁知道~", "哇塞，美得一塌糊涂"]
    
    var selectedAlbum: String = String() // 选中特定相册时设置为相册名字，传递到下一个相册

    var _photos = NSMutableArray() //图片展示列表
    var _thumbs = NSMutableArray() //缩略图列表
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // view配色方案
    func setViewColor() -> Void {
        self.navigationController?.navigationBar.backgroundColor = ColorScheme().navigationBarBackgroundColor
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return phase_.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // 配置cell，后期可以自定义cell显示每个相册的图片数量以及添加时间
        cell.textLabel?.text = phase_[indexPath.section]
        cell.imageView?.image = UIImage(named: "Album")

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return phaseTips_[section]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedAlbum = self.phase_[indexPath.section]
        
        //performSegueWithIdentifier("toEverPhotoAlbum", sender: self.view)
        
        var photo = MWPhoto()
        var displaySelectionButtons = false
        var displayNavArrows = false
        var enableGrid = true
        var startOnGrid = false
        
        var imageURLs = AlbumHandler().getURLList(selectedAlbum)
        // Photos
        for imageURL in imageURLs {
            var myImage = UIImage(contentsOfFile: imageURL)
            photo = MWPhoto(image: myImage)
            photo.caption = ""
            _photos.addObject(photo)
        }
        
        // Thumbs
        for imageURL in imageURLs {
            var myImage = UIImage(contentsOfFile: imageURL)
            photo = MWPhoto(image: myImage)
            _thumbs.addObject(photo)
        }
        
        // Options
        startOnGrid = true
        displayNavArrows = true
        
        // Create browser
        var browser = MWPhotoBrowser(delegate: self)
        browser.displayActionButton = true  //网格视图右上角分享按钮,默认是
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons //是否显示选择按钮在图片上,默认否
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = true;
//        #if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//            browser.wantsFullScreenLayout = YES;
//        #endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = true;
        browser.setCurrentPhotoIndex(0)
        
        // Reset selections
        if (displaySelectionButtons) {
            var _selections = NSMutableArray()
            for (var i = 0; i < _photos.count; i++) {
                _selections.addObject(NSNumber(bool: false))
            }
        }
        
        // Show
        self.navigationController?.pushViewController(browser, animated: true)
        
        // Deselect
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toEverPhotoAlbum" {
            var destinationView = segue.destinationViewController as EverPhotoAlbumCollectionViewController
            destinationView.setValue(self.selectedAlbum, forKey: "albumName")
        }
    }

    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(_photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, captionViewForPhotoAtIndex index: UInt) -> MWCaptionView! {
        if index < UInt(_photos.count) {
            return _photos.objectAtIndex(Int(index)) as MWCaptionView
        }
        return nil
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(_photos.count)) {
            return _photos.objectAtIndex(Int(index)) as MWPhotoProtocol
        }
        return nil;
    }
    
    
//     override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        return true
//    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.None
    }
}
