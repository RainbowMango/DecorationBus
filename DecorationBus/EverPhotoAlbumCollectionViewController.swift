//
//  EverPhotoAlbumCollectionViewController.swift
//  DecorationBus
//
//  Created by ruby on 15-3-14.
//  Copyright (c) 2015年 ruby. All rights reserved.
//

import UIKit

let reuseIdentifier = "EverPhotoCollectionCell"

class EverPhotoAlbumCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MWPhotoBrowserDelegate, EverPhotoPlayerViewControllerDelegate {

    var albumName:String = String()
    var imageURLs: Array<String> = Array<String>()
    
    var _photos = NSMutableArray() //图片展示列表
    var _thumbs = NSMutableArray() //缩略图列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 放置添加按钮到导航栏
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .Bordered, target: self, action: "addPhoto:")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueImagePlayer" {
            var destinationView = segue.destinationViewController as EverPhotoPlayerViewController
            destinationView.delegate = self
            let selectedRow = (self.collectionView?.indexPathsForSelectedItems() as Array<NSIndexPath>)[0].row
            destinationView.setValue(selectedRow, forKey: "curImageIndex")
            destinationView.setValue(imageURLs, forKey: "imageURLs")
            destinationView.setValue(albumName, forKey: "albumName")
            destinationView.setValue(self, forKey: "parentView")
            
            // 下个view隐藏tabbar, 给予用户更多浏览空间
            self.hidesBottomBarWhenPushed = true
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 取得图片列表
        self.imageURLs = AlbumHandler().getURLList(albumName)
        println(self.imageURLs)
        
        var photo = MWPhoto()
        _photos.removeAllObjects()
        for imageURL in imageURLs {
            var myImage = UIImage(contentsOfFile: imageURL)
            photo = MWPhoto(image: myImage)
            photo.caption = ""
            _photos.addObject(photo)
        }
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
//    
//        (cell.contentView.viewWithTag(1) as UIImageView).image = UIImage(contentsOfFile: imageURLs[indexPath.row])
//    
//        return cell
        
        let photoCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CollectionPhotoCell
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
//        // 添加图片
//        var photo = MWPhoto()
//        _photos.removeAllObjects()
//        for imageURL in imageURLs {
//            var myImage = UIImage(contentsOfFile: imageURL)
//            photo = MWPhoto(image: myImage)
//            photo.caption = ""
//            _photos.addObject(photo)
//        }
//        
//        // Create browser
//        var browser = MWPhotoBrowser(delegate: self)
//        browser.displayActionButton = true  //Show action button to allow sharing, copying, etc (defaults to YES)
//        browser.displayNavArrows = true     //Whether to display left and right nav arrows on toolbar (defaults to NO)
//        browser.displaySelectionButtons = true // Whether selection buttons are shown on each image (defaults to NO)
//        browser.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
//        browser.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
//        browser.zoomPhotosToFill = true;
//        browser.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
//        browser.startOnGrid = false // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
//        browser.enableSwipeToDismiss = true;
//        browser.setCurrentPhotoIndex(UInt(indexPath.row))
//        
//        // Show
//        self.navigationController?.pushViewController(browser, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        //TODO: 优化cell布局，不同屏幕尺寸下都有合适的cell尺寸与间隔
        return CGSizeMake(100, 100)
    }

    /*添加照片，目前只支持从照片库中添加，后期可以扩展到三种方式：照片库、相册和相机*/
    func addPhoto(_: UIBarButtonItem!) {
        println("开始导入图片")
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info["UIImagePickerControllerOriginalImage"] as UIImage
        println(info.description)
        //self.imageView01.image = image
        AlbumHandler().saveImageToSandbox(albumName, image: image)
        println("保存照片到\(albumName)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        /*添加图片后刷新view*/
        self.collectionView?.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func currentImageURLs(curImageURLs: Array<String>) -> Void {
        if curImageURLs != imageURLs {
            println("导航回来刷新数据")
            imageURLs = curImageURLs
            self.collectionView?.reloadData()
        }
    }
    
    func removeImage(index: Int) -> Void {
        println("收到代理方法：removeImage with index \(index)")
        // 删除sandbox图片
        AlbumHandler().removeImageFromSandbox(albumName, imageURL: imageURLs[index])
        _photos.removeObjectAtIndex(index)
        
        self.collectionView?.reloadData()
    }
    
    // MARK: MWPhotoBrowserDelegate
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(_photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(_photos.count)) {
            return _photos.objectAtIndex(Int(index)) as MWPhotoProtocol
        }
        
        return nil;
    }
    
//    // 自定义actionButton点击动作
//    func photoBrowser(photoBrowser: MWPhotoBrowser!, actionButtonPressedForPhotoAtIndex index: UInt) {
//        println("actionButtonPressedForPhotoAtIndex")
//    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.None
    }
}
