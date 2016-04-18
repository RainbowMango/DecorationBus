//
//  CommentTableViewController.swift
//  DecorationBus
//
//  Created by ruby on 16/3/20.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import KMPlaceholderTextView

class CommentTableViewController: UITableViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let MAXIMUM_NUMBER_OF_PHOTOS = 4 //最多可以上传的图片数
    
    var delegate: CommentTableViewControllerDelegate?
    
    //定义AGImagePickerController实例
    var ipc = AGImagePickerController()
    
    var reviewItems = Array<String>() //评论项目，由前面controller传入
    var comment     = Comment()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        ipc.delegate = self
        
        
        // AGImagePickerController取消选取图片处理
        ipc.didFailBlock = { (error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }
        
        //AGImagePickerController确定选取图片
        ipc.didFinishBlock = { (info) -> Void in
            for item in info {
                let result = item as! ALAsset
                
                //获取全屏图
                let cgImage = result.defaultRepresentation().fullScreenImage().takeUnretainedValue()
                let image = UIImage(CGImage: cgImage)
                let imagePath = CommentHandler().saveImageToSandbox(image)
                let collectionCellData = ImageCollectionViewCellData(thumb: imagePath.thumbnails, orig: imagePath.originimages)
                self.comment.imageArray.insert(collectionCellData, atIndex: 0)
            }
            self.collectionView?.reloadData()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        }
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     发布评价
     
     - parameter sender: 触发事件的view
     */
    @IBAction func publishComments(sender: AnyObject) {
        self.comment.textContent = self.textView.text
        
        //取得评价得分
        for row in 0..<self.tableView.numberOfRowsInSection(0) {
            let tableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as! StarReviewTableViewCell
            self.comment.itemScore.updateValue(tableViewCell.score, forKey: tableViewCell.itemName.text!)
        }
        
        let validationResult = self.comment.validate()
        if(!validationResult.valid) {
            showSimpleHint(self.view, title: "", message: validationResult.info)
            return
        }
        
        if(self.delegate != nil && self.delegate!.SubmitComments(self.comment)) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StarReviewCell", forIndexPath: indexPath) as! StarReviewTableViewCell

        cell.configure(reviewItems[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionView的数据源和代理方法
extension CommentTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.comment.imageArray.count >= MAXIMUM_NUMBER_OF_PHOTOS) { //如果超出允许的最大图片数，则不再显示提示图片
            return self.comment.imageArray.count
        }
        else { //除了显示已经选取的图片外，再显示提示图片
            return self.comment.imageArray.count + 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCollectionViewCell.identifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if(indexPath.row < self.comment.imageArray.count) { //首先显示用户已经选取的图片
            cell.configure(self.comment.imageArray[indexPath.row].thumbnails)
        }
        else { //最后添加提示图片
            cell.configure("camera")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /**
         *  判断选择的cell是引导图片还是已经选择的图片
         *  选取cell的index    用户已经选择的图片数    是否引导图
         *        0                   0               true
         *        0                 >=1               false
         *        1                   1               true
         *        1                  >1               false
         */
        if(indexPath.row == self.comment.imageArray.count) { //添加图片
            
            let alertVC = UIAlertController(title: "添加图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let cameraSheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowCamera()) {
                        //用户隐私设置禁用相机，弹出alert
                        let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-相机”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                        alertView.show()
                        return
                    }
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                    imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeMedium // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
                    
                    /*
                     * 调用相机时会产生一条log, 应该是IOS8.1的一个bug：
                     Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
                     */
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                alertVC.addAction(cameraSheet)
            }
            
            // 检测是否支持图库
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let photoLibrarySheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowPhotoLibrary()) {
                        //用户隐私设置禁用相册，弹出alert
                        let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-照片”选项中允许“装修巴士”访问您的照片。", delegate: self, cancelButtonTitle: "确定")
                        alertView.show()
                        return
                    }

                    self.startImportPhotoFromLibrary(UInt(self.MAXIMUM_NUMBER_OF_PHOTOS - self.comment.imageArray.count))
                }
                alertVC.addAction(photoLibrarySheet)
            }
            
            let cancelSheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitleCancel, style: UIAlertActionStyle.Cancel) { (action) -> Void in
            }
            alertVC.addAction(cancelSheet)
            
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        else { //浏览图片
            startBrowse(indexPath.row)
        }
    }
    
    /**
     实现代理方法，调整cell大小
     
     - parameter collectionView:       <#collectionView description#>
     - parameter collectionViewLayout: <#collectionViewLayout description#>
     - parameter indexPath:            <#indexPath description#>
     
     - returns: <#return value description#>
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = UIScreen.mainScreen().bounds.size.width/4 - 5
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - UIImagePickerController的代理方法
extension CommentTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     读取图片并保存到沙盒，同时保存图片URL，最后刷新collection view
     
     - parameter picker: picker实例
     - parameter info:   读取到的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil) // 首先释放picker以节省内存
        
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let imagePath = CommentHandler().saveImageToSandbox(image)
        let collectionCellData = ImageCollectionViewCellData(thumb: imagePath.thumbnails, orig: imagePath.originimages)
        self.comment.imageArray.insert(collectionCellData, atIndex: 0)
        
        
        /*添加图片后刷新view*/
        self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CommentTableViewController: AGImagePickerControllerDelegate {
    func startImportPhotoFromLibrary(maxNumber: UInt) {
        
        // Show saved photos on top
        ipc.shouldShowSavedPhotosOnTop = false
        ipc.shouldChangeStatusBarStyle = true
        ipc.maximumNumberOfPhotosToBeSelected = maxNumber
        
        // 自定义工具栏按钮（官方例子中有全选、奇偶选）
        let flexibleSysButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let flexible = AGIPCToolbarItem(barButtonItem: flexibleSysButton, andSelectionBlock: nil)
        
        let deselectAllSysButton = UIBarButtonItem(title: "重新选择", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        let deselectAll = AGIPCToolbarItem(barButtonItem: deselectAllSysButton) { (index, asset) -> Bool in
            return false
        }
        
        ipc.toolbarItemsForManagingTheSelection = [ flexible, deselectAll, flexible]
        
        self.presentViewController(ipc, animated: true, completion: nil)
    }
}

// MARK: - SKPhotoBrowserDelegate
extension CommentTableViewController: SKPhotoBrowserDelegate {
    
    func startBrowse(startIndex: Int) -> Void {
        var skImages = [SKPhoto]()
        
        for image in self.comment.imageArray {
            let skPhoto = SKPhoto.photoWithImage(UIImage(contentsOfFile: image.originimages)!)
            skImages.append(skPhoto)
        }
        
        let browser = SKPhotoBrowser(photos: skImages)
        browser.initializePageIndex(startIndex)
        browser.delegate = self
        browser.displayDeleteButton = true
        browser.statusBarStyle = .LightContent
        browser.bounceAnimation = true
        browser.displayAction = false
        browser.displayDeleteButton = true
        
        presentViewController(browser, animated: true, completion: {})
    }
    
    func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void)) {
        self.comment.imageArray.removeAtIndex(index)
        self.collectionView.reloadData()
        reload()
    }
}

/**
 *  定义代理方法
 */
protocol CommentTableViewControllerDelegate {
    func SubmitComments(comment: Comment) -> Bool
}