//
//  EverPhotoAlbumCollectionViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-14.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

let reuseIdentifier = "EverPhotoCollectionCell"

class EverPhotoAlbumCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MWPhotoBrowserDelegate, EverPhotoPlayerViewControllerDelegate {

    var albumName:String = String()
    var imageURLs: Array<String> = Array<String>()
    
    // 定义照片源字符串，方便创建actionSheet和处理代理
    let actionSheetTitleCancel = "取消"
    let actionSheetTitleCamera = "拍照"
    let actionSheetTitlePhotoLibrary = "照片库"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 放置添加按钮到导航栏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "addPhotoButtonPressed:")
        
        // 将相册名称放入导航栏标题中
        self.navigationItem.title = albumName
        
        // 使用统一的背景颜色
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
        self.collectionView?.backgroundColor = ColorScheme().viewBackgroundColor
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User common functions
    
    func addPhotoButtonPressed(_: UIBarButtonItem!) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: actionSheetTitleCancel, destructiveButtonTitle: nil)
        
        // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            actionSheet.addButtonWithTitle(actionSheetTitleCamera)
        }
        
        // 检测是否支持图库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            actionSheet.addButtonWithTitle(actionSheetTitlePhotoLibrary)
        }
        
        actionSheet.showInView(self.view)
    }
    
    // 判断用户隐私设置中是否对本APP禁用相机功能
    func allowCamera() -> Bool {
        //IOS7.0引入，需要import AVFoundation
        let authStatus :AVAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if authStatus == AVAuthorizationStatus.Denied ||
            authStatus == AVAuthorizationStatus.Restricted {
            return false
        }
        
        return true
    }
    
    // 判断用户隐私设置中是否对本APP禁用照片功能
    func allowPhotoLibrary() -> Bool {
        // IOS 6.0提供，需要import AssetsLibrary
        let authStatus: ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
        if authStatus == ALAuthorizationStatus.Denied ||
            authStatus == ALAuthorizationStatus.Restricted {
                return false
        }
        
        // IOS 8.0提供，需要import Photos
//        let authStatus :PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        if authStatus == PHAuthorizationStatus.Denied ||
//            authStatus == PHAuthorizationStatus.Restricted {
//            return false
//        }
        
        return true
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueImagePlayer" {
            let selectedRow = (self.collectionView?.indexPathsForSelectedItems() as! Array<NSIndexPath>)[0].row
            var destinationView = segue.destinationViewController as! EverPhotoPlayerViewController
            destinationView.delegate = self
            destinationView.setCurrentPhotoIndex(UInt(selectedRow))
            destinationView.setValue(self, forKey: "parentView")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 取得图片列表
        self.imageURLs = AlbumHandler().getURLList(albumName)
        
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionPhotoCell
        photoCell.photoImageView.image = UIImage(contentsOfFile: imageURLs[indexPath.row])
        photoCell.photoImageView.alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            photoCell.photoImageView.alpha = 1.0
        })
        
        return photoCell;
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueImagePlayer", sender: self.view)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        // 每个cell横向间隔为10, 每行放置三个cell
        let cellEdge = (CGRectGetWidth(UIScreen.mainScreen().bounds) - 20) / 3
        return CGSizeMake(cellEdge, cellEdge)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil) // 首先释放picker以节省内存
        
        var image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        AlbumHandler().saveImageToSandbox(albumName, image: image)
        
        /*添加图片后刷新view*/
        self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - EverPhotoPlayerViewControllerDelegate
    
    func EverPhotoPlayerView(willRemoveImage index: UInt) {
        // 删除sandbox图片
        AlbumHandler().removeImageFromSandbox(albumName, imageURL: imageURLs[Int(index)])
        
        // 从collection列表中删除图片
        imageURLs.removeAtIndex(Int(index))
        
        self.collectionView?.reloadData()
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let title = actionSheet.buttonTitleAtIndex(buttonIndex)
        switch title {
        case actionSheetTitleCamera:
            if !allowCamera() {
                //用户隐私设置禁用相机，弹出alert
                var alertView = UIAlertView(title: nil, message: "请在“设置-隐私-相机”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.videoQuality = UIImagePickerControllerQualityType.TypeLow // 获取低质量图片已经足够使用，避免内存使用过多引起内存警告
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        case actionSheetTitlePhotoLibrary:
            if !allowPhotoLibrary() {
                //用户隐私设置禁用相册，弹出alert
                var alertView = UIAlertView(title: nil, message: "请在“设置-隐私-照片”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        case actionSheetTitleCancel:
            println("Cancelled by user")
        default:
            println("Never execute")
        }
    }
    
    // MARK: - MWPhotoBrowserDelegate
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(imageURLs.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(imageURLs.count) {
            let photoURL = NSURL(fileURLWithPath: imageURLs[Int(index)])
            return MWPhoto(URL: photoURL)
        }

        return nil;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.None
    }
}
