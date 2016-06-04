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
import Alamofire
import DKImagePickerController

class CommentTableViewController: UITableViewController {
    
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let MAXIMUM_NUMBER_OF_PHOTOS = 4 //最多可以上传的图片数
    
    var delegate: CommentTableViewControllerDelegate?
    
    private var didSelectBlock: ((assets: [DKAsset]) -> Void)?  //picker回调
    
    var reviewItems = Array<String>() //评论项目，由前面controller传入
    var comment     = Comment()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        setupImagePicker()
        
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
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            
            disableBarButton(self.doneButton) //提交过程中禁用button，防止重复提交
            
            Alamofire.upload(
                Method.POST,
                REQUEST_POST_COMMENTS_URL_STR,
                multipartFormData: { (multipartFormData) in
                    
                    //添加用户ID
                    let user = self.comment.makeParmDataForUserID()
                    multipartFormData.appendBodyPart(data: user, name: "userID")
                    
                    //添加评论对象类型
                    let targetType = self.comment.makeParmDataForTargetType()
                    multipartFormData.appendBodyPart(data: targetType, name: "targetType")
                    
                    //添加评论对象ID
                    let targetID = self.comment.makeParmDataForTargetID()
                    multipartFormData.appendBodyPart(data: targetID, name: "targetID")
                    
                    //添加文字评论内容
                    multipartFormData.appendBodyPart(data: self.comment.textContent.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, name: "textContent")
                    
                    //添加分项评分
                    multipartFormData.appendBodyPart(data: self.comment.makeParmDataForScore(), name: "itemScore")
                    
                    //添加图片张数数据
                    multipartFormData.appendBodyPart(data: self.comment.makeParmDataForImageCount(), name: "imageCount")
                    
                    //添加图片数据
                    for index in 0..<self.comment.assets.count {
//                        multipartFormData.appendBodyPart(data: self.comment.makeParmDataForImage(index, thumb: true), name: "image\(index)thumb")
//                        multipartFormData.appendBodyPart(data: self.comment.makeParmDataForImage(index, thumb: false), name: "image\(index)origin")
                        
//                        multipartFormData.appendBodyPart(data: self.comment.makeParmDataForImage(index, thumb: true), name: "image\(index)thumb", mimeType: "image/png")
//                        multipartFormData.appendBodyPart(data: self.comment.makeParmDataForImage(index, thumb: false), name: "image\(index)origin", mimeType: "image/png")
                        //TODO：不了解如何直接上传图片，所以将图片以文件形式上传
                        multipartFormData.appendBodyPart(fileURL: self.comment.makeImageURL(index, thumb: true), name: "image\(index)thumb")
                        multipartFormData.appendBodyPart(fileURL: self.comment.makeImageURL(index, thumb: false), name: "image\(index)origin")
                    }
                },
                encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            debugPrint(response)
                            if(!self.comment.commentAccept(response.data!)) {
                                debugPrint(response.data)
                                showSimpleAlert(self, title: "提交失败", message: self.comment.serverAckInfo)
                                enableBarButton(self.doneButton) //提交失败重新激活提交按钮，方便重试
                                stopProgressHUD(self.view, animated: true)
                                return
                            }
                            
                            if(self.delegate != nil) {
                                self.delegate!.commentSubmitted(submittedComment: self.comment)
                            }
                            dispatch_async(dispatch_get_main_queue(), { 
                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    case .Failure(let encodingError):
                        showSimpleAlert(self, title: "提交失败", message: "错误代码\(encodingError)")
                        enableBarButton(self.doneButton) //提交失败重新激活提交按钮，方便重试
                        stopProgressHUD(self.view, animated: true)
                    }
                }
            )
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
        
        let curCount =  self.comment.assets.count
        let itemNumber = curCount >= MAXIMUM_NUMBER_OF_PHOTOS ? curCount : curCount + 1
        return itemNumber
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCollectionViewCell.identifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if(indexPath.row < comment.assets.count) {
            let thumbSize = CGSizeMake(120, 120)
            comment.assets[indexPath.row].fetchImageWithSize(thumbSize, completeBlock: { (image, info) in
                cell.configureWithImage(image)
            })
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
        if(indexPath.row == self.comment.assets.count) { //添加图片
            
            let alertVC = UIAlertController(title: "添加图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let cameraSheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitleCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowCamera()) {
                        DeviceLimitHandler().showAlertForCameraRestriction(self)
                        return
                    }
                    HCImagePickerHandler().importPhotoFromCamera(self, didSelectAssets: self.didSelectBlock)
                }
                alertVC.addAction(cameraSheet)
            }
            
            // 检测是否支持图库
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let photoLibrarySheet = UIAlertAction(title: HCImagePickerHandler().actionSheetTitlePhotoLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
                    if(!DeviceLimitHandler().allowPhotoLibrary()) {
                        DeviceLimitHandler().showAlertForPhotoRestriction(self)
                        return
                    }

                    HCImagePickerHandler().importPhotoFromAlbum(self, maxCount: self.MAXIMUM_NUMBER_OF_PHOTOS, defaultAssets: self.comment.assets, didSelectAssets: self.didSelectBlock)
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

// MARK: - DKImagePickerController
extension CommentTableViewController {
    
    func setupImagePicker() -> Void {
        
        self.didSelectBlock = { (assets: [DKAsset]) in
            
            //新选择的图片加入列表中
            for asset in assets {
                if(self.comment.assets.contains(asset)) {
                    continue
                }
                
                self.comment.assets.append(asset)
            }
            
            //如果总张数超过限定数则将最早的图片删除
            while self.comment.assets.count > self.MAXIMUM_NUMBER_OF_PHOTOS {
                self.comment.assets.removeFirst()
            }
            
            self.collectionView.reloadData()
        }
    }
}

// MARK: - SKPhotoBrowserDelegate
extension CommentTableViewController: SKPhotoBrowserDelegate {
    
    func startBrowse(startIndex: Int) -> Void {
        var skImages = [SKPhoto]()
        for asset in self.comment.assets {
            asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                if(image == nil) {
                    print("无法获取original image ")
                    return
                }
                
                skImages.append(SKPhoto.photoWithImage(image!))
            })
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
        self.comment.assets.removeAtIndex(index)
        self.collectionView.reloadData()
        reload()
    }
}

/**
 *  定义代理方法
 */
protocol CommentTableViewControllerDelegate: NSObjectProtocol {
    
    /**
     提交评论成功代理方法，客户可以执行页面刷新等
     
     - parameter comment: 已经提交的评论
     
     - returns: Void
     */
    func commentSubmitted(submittedComment comment: Comment) -> Void
}