//
//  EverPhotoAlbumCollectionViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-14.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import DKImagePickerController

let reuseIdentifier = "EverPhotoCollectionCell"

class EverPhotoAlbumCollectionViewController: UICollectionViewController, UIActionSheetDelegate, MWPhotoBrowserDelegate, EverPhotoPlayerViewControllerDelegate {

    private var didSelectBlock: ((assets: [DKAsset]) -> Void)?  //picker回调
    var albumName:String = String()
    var imageURLs: Array<String> = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImagePicker()
        
        // 放置添加按钮到导航栏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: #selector(EverPhotoAlbumCollectionViewController.addPhotoButtonPressed(_:)))
        
        // 将相册名称放入导航栏标题中
        self.navigationItem.title = albumName
        
        // 使用统一的背景颜色
        self.view.backgroundColor = ColorScheme().viewBackgroundColor
        self.collectionView?.backgroundColor = ColorScheme().viewBackgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - User common functions
    
    func addPhotoButtonPressed(_: UIBarButtonItem!) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: HCImagePickerHandler().actionSheetTitleCancel, destructiveButtonTitle: nil)
        
        // 检测是否支持拍照（模拟器不支持会引起crash, 真机中访问控制相机被禁后也会crash）
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            actionSheet.addButtonWithTitle(HCImagePickerHandler().actionSheetTitleCamera)
        }
        
        // 检测是否支持图库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            actionSheet.addButtonWithTitle(HCImagePickerHandler().actionSheetTitlePhotoLibrary)
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
        
        return true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueImagePlayer" {
            let selectedRow = (self.collectionView?.indexPathsForSelectedItems())![0].row
            let destinationView = segue.destinationViewController as! EverPhotoPlayerViewController
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
        switch title! {
        case HCImagePickerHandler().actionSheetTitleCamera:
            if !allowCamera() {
                //用户隐私设置禁用相机，弹出alert
                let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-相机”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            
            HCImagePickerHandler().importPhotoFromCamera(self, didSelectAssets: self.didSelectBlock)
            
        case HCImagePickerHandler().actionSheetTitlePhotoLibrary:
            if !allowPhotoLibrary() {
                //用户隐私设置禁用相册，弹出alert
                let alertView = UIAlertView(title: nil, message: "请在“设置-隐私-照片”选项中允许“装修巴士”访问您的相机。", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            HCImagePickerHandler().importPhotoFromAlbum(self, maxCount: 9, defaultAssets: nil, didSelectAssets: self.didSelectBlock)
            
        case HCImagePickerHandler().actionSheetTitleCancel:
            print("Cancelled by user")
        default:
            print("Never execute")
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

// MARK: - DKImagePickerController
extension EverPhotoAlbumCollectionViewController {
    
    func setupImagePicker() -> Void {
        self.didSelectBlock = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    AlbumHandler().saveImageToSandbox(self.albumName, image: image!)
                    self.collectionView?.reloadData()
                })
            }
        }
    }
}
